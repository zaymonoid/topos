from PIL import Image
import os, glob

for src in sorted(glob.glob("images/walls/wall*.png")):
    img = Image.open(src).convert("RGB")
    w, h = img.size
    if max(w, h) > 1600:
        scale = 1600 / max(w, h)
        img = img.resize((int(w * scale), int(h * scale)), Image.LANCZOS)
    dst = src.replace(".png", ".jpg")
    img.save(dst, "JPEG", quality=85, optimize=True, progressive=True)
    os.remove(src)
    print(f"wrote {dst}")
