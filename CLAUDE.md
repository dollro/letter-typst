# letter-typst — Typst Letter Package

## What this is
A local Typst package (`@local/letter-typst:<version>`) providing layout functions and components to generate professional DIN 5008 cover letters. All personal content is supplied via a YAML data dictionary — the package contains zero personal data.

**Version**: `typst.toml` is the single source of truth. Typst requires exact version numbers in imports — there is no "latest" tag.

## Package structure
```
typst.toml                        # Package manifest (name, version, entrypoint)
lib.typ                           # Main library — loads localization, re-exports all public API
letter.typ                        # Layout function: cover-letter-page()
_letter-components.typ            # Components: letter-marks, letter-sender-box, ...
styles-letter.typ                 # Design tokens for letter (DIN 5008 dimensions, fonts, spacing)
lang-letter.toml                  # Localization strings for letter (EN/DE)
```

## Public API
Exported from `lib.typ` via `#import "@local/letter-typst:<version>": *`:

| Function | Purpose |
|---|---|
| `cover-letter-page(data, start-page: 1, total-pages: none, get-string: none, signature-image: none)` | DIN 5008 cover letter |
| `get-string(lang, key)` | Localization lookup (letter TOML) |

All layout functions take a `data` dictionary with `author`, `language`, and `cover_letter` keys. See `example/letter-data.yaml` for the full schema.

## Consumer usage pattern
Entry point files in the application project (not in this package):
```typst
#import "@local/letter-typst:<version>": *  // version from typst.toml
#let data = yaml("letter-data.yaml")
#let signature-image = if "signature" in data { image(data.signature) }
#cover-letter-page(data, get-string: get-string, signature-image: signature-image)
```

## Architecture
```
lib.typ
├── lang-letter.toml  (localization data)
└── letter.typ → styles-letter.typ, _letter-components.typ → styles-letter.typ
```

## Design tokens
`styles-letter.typ` contains tokens for:
- **Fonts**: base stacks (`letter-serif-font`, `letter-sans-font`) with derived aliases (`heading`, `body`, `narrative`); Source Sans 3 (sans) + Source Serif 4 (serif)
- **Colors**: footer (#666666), info labels (#666666), body (#000000)
- **Typography**: type scale from 7pt (xs) to 11pt (base), paragraph leading, spacing
- **Page geometry**: margins, header/footer heights, section gaps
- **DIN 5008**: A/B format dimensions, folding/hole marks, address zone, sender strip toggle

## Localization
`lang-letter.toml` provides EN/DE strings. The `get-string(lang, key)` function looks up the requested key in the appropriate language section. Add new languages by adding a `[xx]` section to the TOML file.

## Key gotchas
- **Image paths**: `image()` resolves relative to this package dir, not the consumer project. Images must be pre-loaded in entry point files and passed as parameters (`signature-image`).
- **Font names**: Use `"Source Serif 4"` and `"Source Sans 3"` (with spaces and numbers). These must be installed in the build environment; OTF files are bundled in `example/fonts/`.
- **YAML to Typst naming**: YAML uses underscores (`cover_letter`), Typst parameters use hyphens (`cover-letter-page`). Mapping happens in layout functions.
- **Internal files**: Component files are prefixed with `_` (e.g. `_letter-components.typ`) to indicate they are internal.
- **DIN 5008 format**: Controlled by `letter-format` in `styles-letter.typ`. Supports `"DIN-5008-A"` (27mm header) and `"DIN-5008-B"` (45mm header).
