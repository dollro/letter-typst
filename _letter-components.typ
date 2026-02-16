// ==========================================================
// _letter-components.typ — DIN 5008 Letter Helpers
// ==========================================================
// Adapted from typst-letter-pro. All hardcoded values replaced
// with design tokens from styles.typ.

#import "styles-letter.typ": *

// ----------------------------------------------------------
// DIN 5008 Format Constants
// ----------------------------------------------------------

#let letter-formats = (
  "DIN-5008-A": (
    folding-mark-1-pos: 87mm,
    folding-mark-2-pos: 87mm + 105mm,
    header-size: 27mm,
  ),
  "DIN-5008-B": (
    folding-mark-1-pos: 105mm,
    folding-mark-2-pos: 105mm + 105mm,
    header-size: 45mm,
  ),
)

// ----------------------------------------------------------
// Folding & Hole Marks
// ----------------------------------------------------------
// Returns content with place()'d marks for use as page background.

#let letter-marks(format) = {
  let fmt = letter-formats.at(format)

  if letter-show-folding-marks {
    // Folding mark 1
    place(top + left, dx: letter-mark-offset-x, dy: fmt.folding-mark-1-pos, line(
      length: letter-folding-mark-length,
      stroke: letter-mark-stroke + black,
    ))

    // Folding mark 2
    place(top + left, dx: letter-mark-offset-x, dy: fmt.folding-mark-2-pos, line(
      length: letter-folding-mark-length,
      stroke: letter-mark-stroke + black,
    ))
  }

  if letter-show-hole-mark {
    // Hole mark (always at 148.5mm — center of A4)
    place(left + top, dx: letter-mark-offset-x, dy: 148.5mm, line(
      length: letter-hole-mark-length,
      stroke: letter-mark-stroke + black,
    ))
  }
}

// ----------------------------------------------------------
// Sender Return-Address Strip
// ----------------------------------------------------------
// 85mm × 5mm underlined box with small sender text.

#let letter-sender-box(name, address) = rect(
  width: letter-address-width,
  height: letter-sender-box-height,
  stroke: none,
  inset: 0pt,
  {
    set text(size: letter-sender-size, font: letter-body-font)
    set align(horizon)

    pad(left: letter-address-pad-left, underline(offset: letter-sender-underline-offset, {
      if name != none { name }
      if name != none and address != none { ", " }
      if address != none { address }
    }))
  },
)

// ----------------------------------------------------------
// Recipient Address Box
// ----------------------------------------------------------

#let letter-recipient-box(content) = {
  set text(size: letter-recipient-size, font: letter-body-font)
  set align(top)

  pad(left: letter-address-pad-left, content)
}

// ----------------------------------------------------------
// Combined Address Box (Duobox — no annotations)
// ----------------------------------------------------------
// Two rows: sender zone + remaining recipient zone = address-zone-height total.

#let letter-address-box(sender-box, recipient-box) = {
  grid(
    columns: 1,
    rows: (letter-sender-zone-height, letter-address-zone-height - letter-sender-zone-height),
    align(bottom, pad(bottom: 0.65em, sender-box)),
    recipient-box,
  )
}

// ----------------------------------------------------------
// Simple Header (right-aligned sender info)
// ----------------------------------------------------------

#let letter-header-simple(name, address, phone: none, email: none, get-string: none, lang: "en") = {
  set text(size: letter-header-size, font: letter-body-font)

  if name != none {
    strong(text(font: letter-heading-font, name))
    linebreak()
  }

  if address != none {
    address
    linebreak()
  }

  if phone != none {
    text(size: letter-info-label-size, fill: letter-info-label-color, get-string(lang, "letter-info-phone") + " ")
    phone
    linebreak()
  }

  if email != none {
    text(size: letter-info-label-size, fill: letter-info-label-color, get-string(lang, "letter-info-email") + " ")
    email
  }
}
