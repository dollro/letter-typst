# letter-typst

A [Typst](https://typst.app) package for generating professional **DIN 5008** cover letters. All personal content is supplied via a YAML data dictionary — the package itself contains no personal data.

## Features

- DIN 5008 compliant layout (Format A and B)
- Folding and hole marks for windowed envelopes
- EN/DE localization with extensible TOML-based strings
- Optional signature image, enclosures line, and bullet-point highlights
- Configurable design tokens (fonts, spacing, margins, toggles)

## Fonts

The package uses two open-source font families, bundled as OTF files in `example/fonts/`:

| Font | Role |
|---|---|
| **Source Sans 3** | Headings, body text, UI elements |
| **Source Serif 4** | Narrative paragraphs |

## Package structure

```
typst.toml                  # Package manifest (name, version, entrypoint)
lib.typ                     # Main library — re-exports public API
letter.typ                  # Layout function: cover-letter-page()
_letter-components.typ      # Internal components (marks, sender box, etc.)
styles-letter.typ           # Design tokens (DIN 5008 dimensions, fonts, spacing)
lang-letter.toml            # Localization strings (EN/DE)
example/                    # Standalone build example with Docker
```

## Usage

### 1. Install as a local Typst package

Copy the package files into your local Typst packages directory:

```bash
VERSION=0.1.0  # must match typst.toml
DEST="$HOME/.local/share/typst/packages/local/letter-typst/$VERSION"
mkdir -p "$DEST"
cp typst.toml lib.typ letter.typ _letter-components.typ \
   styles-letter.typ lang-letter.toml "$DEST/"
```

### 2. Create your entry point

```typst
#import "@local/letter-typst:0.1.0": *

#let data = yaml("letter-data.yaml")
#let signature-img = if "signature" in data { image(data.signature) }

#cover-letter-page(data, get-string: get-string, signature-image: signature-img)
```

### 3. Supply your data

Create a `letter-data.yaml` following the schema in [`example/letter-data.yaml`](example/letter-data.yaml). The YAML file contains all personal content: author info, recipient, letter body paragraphs, closing, and optional enclosures.

### 4. Compile

```bash
typst compile letter.typ
```

Or use the Docker-based build in `example/`:

```bash
cd example
cp .env.example .env    # edit as needed
bash build.sh           # → letter.pdf
```

## Public API

Exported from `lib.typ`:

| Function | Purpose |
|---|---|
| `cover-letter-page(data, start-page: 1, total-pages: none, get-string: none, signature-image: none)` | Render a DIN 5008 cover letter |
| `get-string(lang, key)` | Localization string lookup |

## Localization

`lang-letter.toml` provides EN and DE strings. Add a new language by adding a `[xx]` section to the TOML file.

## License

See individual font licenses in `example/fonts/`. The Typst source files in this repository are unlicensed — add a `LICENSE` file to specify terms for your use case.
