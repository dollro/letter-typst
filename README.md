# letter-typst

A [Typst](https://typst.app) package for generating professional **DIN 5008** cover letters. All personal content is written directly in the `.typ` entry point using native Typst markup — the package itself contains no personal data.

## Features

- DIN 5008 compliant layout (Format A and B)
- Folding and hole marks for windowed envelopes
- EN/DE localization with extensible TOML-based strings
- Native Typst markup in letter body (bold, italics, links, lists, etc.)
- Optional signature image, enclosures line
- Configurable design tokens (fonts, spacing, margins, toggles)

## Fonts

The package uses two open-source font families, bundled as OTF files in `example/fonts/`:

| Font | Role |
|---|---|
| **Source Sans 3** | Headings, body text, UI elements |
| **Source Serif 4** | Narrative paragraphs |

## Quick start

The recommended way to build letters is via the Docker environment in `example/`. It compiles Typst from source, bundles the fonts, and mounts the package — no local Typst installation required.

### Prerequisites

- Docker with Compose V2 (`docker compose`)

### 1. Set up the example directory

```bash
cd example
cp .env.example .env
```

Edit `.env` if needed. The defaults work for local development — the package is mounted from the parent directory via the `docker-compose.yml` volume:

```yaml
- ..:/opt/typst-data/typst/packages/local/${LETTER_TYPST_NAME:-letter-typst}/${LETTER_TYPST_VERSION:-0.1.0}:ro
```

### 2. Write your letter

All content lives directly in `letter.typ`. Edit the author/recipient dictionaries and write your letter body as native Typst markup:

```typst
#import "@local/letter-typst:1.2.0": *

#let author = (
  title: "M.Sc.",
  firstname: "Jane",
  lastname: "Doe",
  phone: "+49 123 4567890",
  email: "jane.doe@example.com",
  address: "Musterstr. 42",
  city: "10115 Berlin, Germany",
)

#let recipient = (
  company: "Acme Technologies GmbH",
  name: "Human Resources",
  address: "Technikstr. 10",
  city: "80333 Munich",
)

#cover-letter-page(
  author,
  recipient,
  language: "en",
  date: "15.01.2026",
  get-string: get-string,
  signature-image: image("images/signature.png"),
)[
  First paragraph with *bold* and _italic_ support...

  Second paragraph...

  - Key strength 1
  - Key strength 2

  Closing paragraph...
]
```

The body content block `[...]` supports full Typst markup — bold, italics, links, lists, and more.

### 3. Mount additional local resources (optional)

The Docker container only sees what is mounted into it. To make local fonts, images, or other files available, add volume mounts to `docker-compose.yml`:

```yaml
volumes:
  - .:/work
  - ..:/opt/typst-data/typst/packages/local/${LETTER_TYPST_NAME:-letter-typst}/${LETTER_TYPST_VERSION:-0.1.0}:ro
  # Mount a local fonts directory so the container can use them:
  - /usr/share/fonts:/usr/share/fonts/host:ro
  # Or mount a specific folder of extra resources:
  - ~/my-resources:/work/resources:ro
```

Paths inside the container are then available to Typst as usual — e.g. `image("resources/logo.png")` or fonts discovered via `fontconfig`.

### 4. Build the PDF

```bash
bash build.sh
```

This runs `docker compose run --rm typst compile letter.typ` and produces `letter.pdf` in the example directory.

On the first run, Docker builds the image (compiles Typst from source, installs fonts). Subsequent runs reuse the cached image.

### 5. Customise further

Optional parameters:

- `subject: "Application for ..."` — adds a bold subject line
- `salutation: "Dear Hiring Manager,"` — overrides the localized default
- `closing: "Best regards,"` — overrides the localized default
- `enclosures: "Executive Summary, Profile"` — adds an enclosures line

The `start-page` and `total-pages` CLI inputs let you control page numbering when the letter is part of a larger document.

## Package structure

```
typst.toml                  # Package manifest (name, version, entrypoint)
lib.typ                     # Main library — re-exports public API
letter.typ                  # Layout function: cover-letter-page()
_letter-components.typ      # Internal components (marks, sender box, etc.)
styles-letter.typ           # Design tokens (DIN 5008 dimensions, fonts, spacing)
lang-letter.toml            # Localization strings (EN/DE)
example/
  letter.typ                # Entry point — imports package, defines content
  fonts/                    # Bundled open-source OTF fonts
  images/                   # Signature, photo, etc.
  build.sh                  # One-command PDF build
  Dockerfile                # Builds Typst from source, installs fonts
  docker-compose.yml        # Mounts package + working dir, runs Typst
  .env.example              # Build configuration template
```

## Public API

Exported from `lib.typ`:

| Function | Purpose |
|---|---|
| `cover-letter-page(author, recipient, body-content, language: "en", date: none, subject: none, salutation: auto, closing: auto, enclosures: none, start-page: 1, total-pages: none, get-string: none, signature-image: none)` | Render a DIN 5008 cover letter |
| `get-string(lang, key)` | Localization string lookup |

## Releases

Releases are created automatically via GitHub Actions when an annotated semver tag is pushed:

```bash
# After updating typst.toml version:
git tag -a 1.2.0 -m "Release v1.2.0"
git push origin 1.2.0
```

The workflow validates that the tag matches the version in `typst.toml`, builds a distribution archive (excluding `example/`, `.github/`, and dev files), and publishes it as a GitHub Release with the tarball attached.

Only annotated tags trigger a release — lightweight tags are ignored.

## Localization

`lang-letter.toml` provides EN and DE strings. Add a new language by adding a `[xx]` section to the TOML file.

## License

See individual font licenses in `example/fonts/`. The Typst source files in this repository are unlicensed — add a `LICENSE` file to specify terms for your use case.
