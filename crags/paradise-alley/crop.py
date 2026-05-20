from PIL import Image
import os

SRC = "images/annotated"
OUT = "images/walls"
os.makedirs(OUT, exist_ok=True)

# (page, name, x, y, w, h)  — coords in pixels at 300 DPI (page is 2550x3300)
crops = [
    # Page 3: Wall 1 (top-left, beside route descriptions), Wall 2 (bottom-right)
    (3, "wall1",   60, 1000, 1240, 1180),
    (3, "wall2", 1280, 2070, 1180, 1080),
    # Page 4: Wall 3 (full-width top), Wall 4 (mid-right, beside descriptions)
    (4, "wall3",   60,   20, 2440, 1330),
    (4, "wall4", 1280, 1400, 1080, 1180),
    # Page 5: Wall 5 (full page, ~top 60%)
    (5, "wall5",   60,   20, 2440, 1880),
    # Page 6: Wall 6 (below routes 26-29 callouts at top)
    (6, "wall6",   60,  620, 2440, 1560),
    # Page 7: Wall 7 (full-width top)
    (7, "wall7",   60,   20, 2440, 1860),
]

for pg, name, x, y, w, h in crops:
    img = Image.open(f"{SRC}/page-{pg}.png")
    img.crop((x, y, x + w, y + h)).save(f"{OUT}/{name}.png", optimize=True)
    print(f"wrote {OUT}/{name}.png")
