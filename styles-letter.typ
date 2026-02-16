// ==========================================================
// styles-letter.typ — Cover Letter (DIN 5008) Design Tokens
// ==========================================================

// ----------------------------------------------------------
// DIN Format, Font Families, Page Margins
// ----------------------------------------------------------

// DIN 5008 format
#let letter-format = "DIN-5008-B"           // "DIN-5008-A" or "DIN-5008-B"

// Font Families (base)
#let letter-serif-font = ("Source Serif 4",)
#let letter-sans-font = ("Source Sans 3",)

// Font Families (derived)
#let letter-heading-font = letter-sans-font
#let letter-body-font = letter-sans-font
#let letter-narrative-font = letter-serif-font

// Page margins (DIN 5008 standard, independent of CV margins)
#let letter-margin-left = 25mm
#let letter-margin-right = 25mm
// #let letter-margin-right = 20mm              // DIN 5008 standard
#let letter-margin-top = 20mm
#let letter-margin-bottom = 20mm

// ----------------------------------------------------------
// Type Scale (Tailwind-style)
// ----------------------------------------------------------

#let letter-text-xs = 7pt       // footer, sender strip
#let letter-text-sm = 9pt       // recipient, header, info labels
#let letter-text-base = 11pt    // narrative body, subject line

// ----------------------------------------------------------
// Folding & Hole Marks
// ----------------------------------------------------------

#let letter-mark-stroke = 0.25pt            // stroke width for folding/hole marks
#let letter-mark-offset-x = 5mm             // horizontal offset from page edge
#let letter-folding-mark-length = 2.5mm
#let letter-hole-mark-length = 4mm

// ----------------------------------------------------------
// Address Zone (DIN 5008 Anschriftfeld)
// ----------------------------------------------------------

#let letter-address-width = 85mm            // address box width
#let letter-info-width = 75mm               // right-side information box width
#let letter-address-info-gutter = 20mm      // gap between address and info columns
#let letter-sender-box-height = 5mm         // sender return-address strip height
#let letter-sender-size = letter-text-xs
#let letter-recipient-size = letter-text-sm

// ----------------------------------------------------------
// Information Box
// ----------------------------------------------------------

#let letter-info-label-size = letter-text-sm

// ----------------------------------------------------------
// Body
// ----------------------------------------------------------

#let letter-body-bullet-indent = 2em      // ident for bullet points in letter body
#let letter-narrative-size = letter-text-base
#let letter-narrative-leading = 0.5em      // line spacing (~145% of font size)
#let letter-narrative-par-spacing = 1.05em  // inter-paragraph gap
#let letter-subject-size = letter-text-base
#let letter-date-gap = 0.65em               // space after date line
#let letter-subject-before = 5pt            // space before subject line
// #let letter-subject-before = 0pt             // DIN 5008 standard (no extra gap)
#let letter-subject-after = 16pt             // space after subject line
// #let letter-subject-after = 0.65em           // DIN 5008 standard
#let letter-closing-gap = 1.5em             // space between body and closing
#let letter-signature-gap = 0.5em           // space between closing and signature image
#let letter-enclosures-gap = 1.5em          // space before enclosures line
#let letter-body-gap = 8pt               // space between address zone and body content
// #let letter-body-gap = 12pt                  // DIN 5008 standard
#let letter-signature-width = 4cm           // signature image width (keep in sync with cv-signature-width)

// ----------------------------------------------------------
// Header & Footer
// ----------------------------------------------------------

#let letter-header-size = letter-text-sm
#let letter-header-bottom-pad = 5mm         // padding below header content

#let letter-footer-size = letter-text-xs
#let letter-footer-pad = 12pt              // vertical padding inside footer
#let letter-footer-color = rgb("#666666")   // footer text fill

// ----------------------------------------------------------
// Toggles
// ----------------------------------------------------------

#let letter-show-header-first-page = false     // no page header (DIN 5008 letters use inline sender area instead)
#let letter-show-header-remaining = false      // no page header on subsequent pages
#let letter-show-footer-first-page = false      // show/hide footer on the first page
#let letter-show-footer-remaining = true       // show/hide footer on pages 2+
#let letter-show-folding-marks = true      // show/hide folding marks
#let letter-show-hole-mark = true          // show/hide hole mark
#let letter-show-sender-strip = false      // show/hide sender return strip (DIN 5008 relic, off for digital)

// ----------------------------------------------------------
// Address Zone Inner Padding (DIN 5008 Anschriftfeld)
// ----------------------------------------------------------

#let letter-address-pad-left = 5mm         // left inset within sender & recipient boxes
#let letter-sender-underline-offset = 2pt  // underline offset in sender return strip
#let letter-address-zone-height = 45mm     // total height of address + info zone
#let letter-address-zone-pad-left = 20mm   // left padding of address zone from page edge
#let letter-address-zone-pad-right = 10mm  // right padding of address zone from page edge
#let letter-sender-zone-height = 17.7mm    // sender row in duobox (remaining = recipient)

// ----------------------------------------------------------
// Information Box (extra tokens)
// ----------------------------------------------------------

#let letter-info-pad-top = letter-sender-zone-height  // aligns info box with recipient address start
#let letter-info-inner-gap = 4pt           // gap between info items (phone, email, city)
#let letter-info-label-color = rgb("#666666") // color for info box labels
