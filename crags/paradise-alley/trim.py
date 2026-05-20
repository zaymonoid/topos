from PIL import Image
import glob

def trim_whitespace(img, threshold=245):
    rgb = img.convert("RGB")
    w, h = rgb.size
    px = rgb.load()

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

for src in sorted(glob.glob("images/walls/wall*.png")):
    img = Image.open(src)
    trim_whitespace(img, threshold=245).save(src, optimize=True)
    print(f"trimmed {src}")
