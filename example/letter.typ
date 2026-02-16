#import "@local/letter-typst:0.1.0": *

// Read all content from YAML
#let data = yaml("letter-data.yaml")

// Pre-load images (paths resolve relative to this entry point file)
#let signature-img = if "signature" in data { image(data.signature) }

// Read CLI inputs
#let start-page = int(sys.inputs.at("start-page", default: "1"))
#let total-pages = sys.inputs.at("total-pages", default: none)
#let total-pages = if total-pages != none { int(total-pages) } else { none }

// Render the Cover Letter
#cover-letter-page(data, start-page: start-page, total-pages: total-pages, get-string: get-string, signature-image: signature-img)
