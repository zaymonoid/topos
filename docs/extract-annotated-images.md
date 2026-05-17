# Extracting annotated images from an annotated PDF

The original `paradise-alley-original.pdf` (built in Canva, then re-saved by macOS Preview) embeds wall photos as raw JPEGs and draws the topo annotations — route lines, grade labels, numbered circles, "Wall N" headers — as separate PDF objects on top.

`pdfimages` only extracts the underlying photos, so any approach that pulls raw image streams loses every annotation. This doc captures the workaround: render the pages to high-DPI rasters, then crop the annotated photo regions out of those rasters.

## TL;DR

```
# 1. Render every page of the source PDF at 300 DPI
pdftoppm -r 300 paradise-alley-original.pdf paradise-alley-images/annotated/page -png

# 2. Crop each wall's photo region from the rendered page (Python + PIL).
#    Iterate visually until each crop captures only the photo + its annotations.
uv run --with pillow python3 crop.py

# 3. Auto-trim leftover whitespace borders.
uv run --with pillow python3 trim.py

# 4. Downscale + convert to JPEG q=85 for size.
uv run --with pillow python3 optimize.py
```

End result: each wall ends up as a single `walls/wall<N>.jpg` with annotations baked in, sized for print at ~200 DPI.

## Step 1 — Render the PDF at print resolution

US Letter at 300 DPI is `2550 × 3300` px. Rendering at 300 DPI gives enough headroom that the cropped sub-images still look crisp on print and on Retina screens.

```sh
pdftoppm -r 300 paradise-alley-original.pdf paradise-alley-images/annotated/page -png
```

This writes `page-1.png` … `page-6.png`. Each is the full page including text, photos, and annotations as a single flat raster.

## Step 2 — Identify crop boxes

The PDF's coordinate system is in points (612 × 792 for US Letter); at 300 DPI those become pixels (`612/72*300 = 2550`, `792/72*300 = 3300`).

There's no good way to recover the exact bounding box of each photo + annotation cluster from the PDF metadata — annotations are drawn outside the image's bounding box. So I eyeballed crop coordinates from the rendered pages, ran the crop, viewed the output, and iterated.

```python
# crop.py — iterate visually until every wall's annotations are inside the box
from PIL import Image
import os

SRC = "paradise-alley-images/annotated"
OUT = "paradise-alley-images/walls"
os.makedirs(OUT, exist_ok=True)

# (page, name, x, y, w, h)  — coords in pixels at 300 DPI
crops = [
    (2, "wall1", 100,  820, 1240, 1450),
    (2, "wall2", 1380, 1660, 1060,  800),
    (3, "wall3",  90,   60, 2410, 1320),
    (3, "wall4", 1330, 1480, 1120, 1080),
    (4, "wall5",  90,   30, 2410, 1810),
    (5, "wall6",  90,  610, 2410, 1620),
    (6, "wall7",  90,   30, 2410, 1820),
]

for pg, name, x, y, w, h in crops:
    img = Image.open(f"{SRC}/page-{pg}.png")
    img.crop((x, y, x + w, y + h)).save(f"{OUT}/{name}.png", optimize=True)
```

### Lessons learned about choosing the box

- **Be generous on the edges that contain annotations.** Numbered circles and "open project" labels often sit *outside* the photo's actual border. Tight crops will clip them. Wall 7 originally lost numbers 42–46 because I cropped the bottom too aggressively — fixed by extending `h` from `1650` → `1820`.
- **Don't worry about getting flush borders here** — Step 3 trims whitespace automatically. Better to over-include than under-include.
- **Verify by reading each PNG back.** Render is cheap. After every crop pass: open the output and scan for clipped annotations, especially at the edges.

## Step 3 — Auto-trim whitespace

Rendered pages have page-background bleed (the cream/paper color around the photo). Rather than fine-tune each crop to flush borders, run a whitespace-trim pass: scan inward from each edge and stop at the first row/column with non-white content.

```python
# trim.py
from PIL import Image
import os, glob

def trim_whitespace(img, threshold=245):
    rgb = img.convert("RGB")
    w, h = rgb.size
    px = rgb.load()

    # A pixel is "content" if ANY of its channels is below threshold.
    # This is the key insight for preserving saturated annotations:
    # a pure-yellow label is (255, 255, 0) — R and G are above 245, but
    # B=0 keeps it classified as content.
    def is_content_row(y):
        return any(px[x, y][i] < threshold for x in range(w) for i in (0, 1, 2))
    def is_content_col(x):
        return any(px[x, y][i] < threshold for y in range(h) for i in (0, 1, 2))

    top = 0
    while top < h and not is_content_row(top): top += 1
    bottom = h - 1
    while bottom > top and not is_content_row(bottom): bottom -= 1
    left = 0
    while left < w and not is_content_col(left): left += 1
    right = w - 1
    while right > left and not is_content_col(right): right -= 1

    return img.crop((left, top, right + 1, bottom + 1))

for src in sorted(glob.glob("paradise-alley-images/walls/wall*.png")):
    img = Image.open(src)
    trim_whitespace(img, threshold=245).save(src, optimize=True)
```

### Why `any(channel < threshold)` matters

The naive trim — "drop the row if every pixel is bright" — checks all three channels together. That kills saturated annotations: pure yellow `(255, 255, 0)` has two channels at max, and a row containing only yellow circles on a white background would get flagged as whitespace and trimmed.

The fix: treat a pixel as content if **any single channel** falls below threshold. Yellow's B=0 saves it. Same for orange, pink, the cyan project squares — all of them have at least one channel that's clearly not "white".

Threshold of `245` (out of 255) is loose enough to ignore JPEG/render fringing around the page edge, tight enough to preserve real content.

## Step 4 — Downscale + JPEG

The trimmed PNGs are ~4–7 MB each (300 DPI is overkill once the image is sitting at ~3 inches wide on a printed page). Downscale to a max dimension of 1600 px and re-encode as progressive JPEG at q=85:

```python
# optimize.py
from PIL import Image
import os, glob

for src in sorted(glob.glob("paradise-alley-images/walls/wall*.png")):
    img = Image.open(src).convert("RGB")
    w, h = img.size
    if max(w, h) > 1600:
        scale = 1600 / max(w, h)
        img = img.resize((int(w * scale), int(h * scale)), Image.LANCZOS)
    dst = src.replace(".png", ".jpg")
    img.save(dst, "JPEG", quality=85, optimize=True, progressive=True)
    os.remove(src)
```

Final sizes: each wall ends up at 200–600 KB, total wall imagery ~2.7 MB. The full PDF drops from ~40 MB (PNG) to ~3 MB (JPEG) with no visible quality loss at print scale.

## Failure modes & how to detect them

| Symptom | Cause | Fix |
| --- | --- | --- |
| Route numbers missing at one edge | Crop box too tight, clipped before trim could save it | Widen the crop box on that side, re-run |
| Yellow/orange labels look mangled at the border | Trim threshold too aggressive | Lower threshold (e.g. 240) or check the `any` vs `all` logic |
| Visible text from another section bleeding in | Crop overshot into adjacent layout (caption, neighbouring photo) | Tighten the crop box on that side |
| Image looks soft when printed | Source rendered at < 300 DPI, or downscale target too small | Re-render at 300+ DPI; raise the 1600 px cap |
| Final PDF is huge | Forgot the JPEG step, or quality > 90 | Re-encode at q=85, ensure source is JPEG not PNG |

## Why not just patch the source PDF?

Two paths considered and rejected:

1. **Extract annotations as vector objects, re-overlay in Typst.** Doable in theory — `pypdf` can enumerate the annotation dict on each page — but the annotations here are drawn as primitive PDF operators (lines, filled rects, text), not as `/Annot` objects. Reconstructing them faithfully in Typst (yellow polylines with correct width, label boxes with correct rotation, etc.) is more work than re-cropping.
2. **Use `mutool` or `qpdf` to flatten annotations into the photo streams.** Neither tool offers a clean "merge annotations into embedded JPEG" operation. Flattening to a new PDF and re-extracting just produces the same problem.

Rasterising the page and cropping is the simplest path that produces faithful output. The tradeoff is that the wall photos are now raster, not the original embedded JPEGs — but they're already JPEG at the source, so quality is preserved as long as the render DPI is high enough.
