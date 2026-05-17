# Climbing topos

Climbing guidebook pages, redesigned and rendered with [Typst](https://typst.app/).

Each crag lives under `crags/<crag-name>/`, with its `topo.typ` source, the rendered `topo.pdf`, the original reference PDF (`source.pdf`), and an `images/` tree.

```
crags/
└── paradise-alley/
    ├── topo.typ              # Typst source
    ├── topo.pdf              # rendered guide
    ├── source.pdf            # original reference PDF
    └── images/
        ├── trail.jpg         # approach trail aerial
        ├── overview.jpg      # crag overview with wall numbers
        ├── walls/            # cropped, annotated wall photos
        └── annotated/        # 300 DPI page renders (gitignored, regenerable)
```

Process notes for extracting annotated images from a source PDF live in [`docs/extract-annotated-images.md`](docs/extract-annotated-images.md).

## Requirements

### Typst

The typesetter. Install via [typst.app](https://typst.app/) or one of:

```sh
brew install typst                                                # macOS
cargo install --locked typst-cli                                  # cross-platform
```

Tested with Typst `0.14.x`.

### Poppler (`pdftoppm`, `pdfimages`, `pdftotext`)

Used to rasterise pages of the source PDF at 300 DPI and inspect contents.

```sh
brew install poppler
```

### Python 3 + Pillow

Used to crop, trim whitespace from, and optimize wall photos. Invoked via [`uv`](https://docs.astral.sh/uv/) so no virtualenv setup is required:

```sh
brew install uv
uv run --with pillow python3 some_script.py
```

If you'd rather use a system Python:

```sh
pip install pillow
```

### Fonts (build-time only)

Typst embeds and subsets every used font into the output PDF, so **viewers don't need any of these installed** — `topo.pdf` is fully portable. You only need them on the machine that's running `typst compile`.

| Family | Used for | Where to get it |
| --- | --- | --- |
| **Futura** | Cover title, wall names | Bundled with macOS |
| **Iowan Old Style** | Body, wall headings | Bundled with macOS |
| **JetBrains Mono** | Grade pills, route numbers, all-caps badges, "WALL N" pills | [Download](https://www.jetbrains.com/lp/mono/) or `brew install --cask font-jetbrains-mono-nerd-font` |

Typst will print a "unknown font family" warning at compile time if a family is missing and fall back to a generic. The doc still builds, but the styling won't match.

Confirm what's embedded in a built PDF with:

```sh
pdffonts crags/paradise-alley/topo.pdf
```

## Build

From the repo root:

```sh
# One-shot build
typst compile crags/paradise-alley/topo.typ crags/paradise-alley/topo.pdf

# Watch + rebuild on save
typst watch crags/paradise-alley/topo.typ crags/paradise-alley/topo.pdf
```

`topo.pdf` is checked into git as the canonical artifact, so a fresh clone is viewable without a toolchain.

## Adding a new crag

1. `mkdir -p crags/<new-crag>/images`
2. Drop the source guidebook PDF into `crags/<new-crag>/source.pdf`
3. Follow [`docs/extract-annotated-images.md`](docs/extract-annotated-images.md) to render + crop + trim its annotated wall photos
4. Copy `crags/paradise-alley/topo.typ` as a starting template and adapt content
