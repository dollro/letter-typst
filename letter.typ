// ==========================================================
// letter.typ — DIN 5008 Cover Letter Layout
// ==========================================================

#import "styles-letter.typ": *
#import "_letter-components.typ": letter-formats, letter-marks, letter-sender-box, letter-header-simple

#let cover-letter-page(
  author,
  recipient,
  body-content,
  language: "en",
  date: none,
  subject: none,
  salutation: auto,
  closing: auto,
  enclosures: none,
  start-page: 1,
  total-pages: none,
  get-string: none,
  signature-image: none,
) = {
  let lang = language
  let fmt = letter-format  // from styles.typ

  // Build author full name
  let author-title = author.at("title", default: none)
  let author-name = {
    if author-title != none { author-title + " " }
    author.firstname + " " + author.lastname
  }

  // -- Page setup with DIN 5008 marks as background -----------
  set page(
    paper: "a4",
    margin: (
      left: letter-margin-left,
      right: letter-margin-right,
      top: letter-margin-top,
      bottom: letter-margin-bottom,
    ),
    background: letter-marks(fmt),
    footer-descent: 0%,
    footer: if letter-show-footer-first-page or letter-show-footer-remaining {
      context {
        let is-first = counter(page).get().first() == 1
        let show-it = (is-first and letter-show-footer-first-page) or (not is-first and letter-show-footer-remaining)
        if show-it {
          show: pad.with(top: letter-footer-pad, bottom: letter-footer-pad)

          let current = counter(page).get().first()
          let display-page = start-page + current - 1
          let page-count = counter(page).final().first()
          let total = if total-pages != none { total-pages } else { page-count }

          if total-pages != none or page-count > 1 {
            set text(size: letter-footer-size, font: letter-body-font, fill: letter-footer-color)
            line(length: 100%, stroke: 0.75pt + letter-footer-color)
            v(2pt)

            let left-parts = ()
            let name = ""
            if "title" in author { name += author.title + " " }
            name += author.at("firstname", default: "") + " " + author.at("lastname", default: "")
            if name.trim() != "" { left-parts.push(name.trim()) }
            let email = author.at("email", default: "")
            if email != "" { left-parts.push(email) }
            let left-text = left-parts.join([ #sym.bullet ])

            block(width: 100%)[
              #left-text
              #h(1fr)
              #get-string(lang, "letter-page-of") #display-page #get-string(lang, "letter-page-of-separator") #total
            ]
          }
        }
      }
    },
  )

  set text(font: letter-body-font, size: letter-narrative-size, hyphenate: false)

  // -- Reverse margins for header + address zone ---------------
  // When sender strip is hidden, collapse its row to avoid excess whitespace
  let effective-address-zone-height = if letter-show-sender-strip {
    letter-address-zone-height
  } else {
    letter-address-zone-height - letter-sender-zone-height
  }

  pad(top: -letter-margin-top, left: -letter-margin-left, right: -letter-margin-right, {
    grid(
      columns: 100%,
      rows: (letter-formats.at(fmt).header-size, effective-address-zone-height),

      // Header: sender info, right-aligned at bottom
      pad(
        left: letter-margin-left,
        right: letter-margin-right,
        top: letter-margin-top,
        bottom: letter-header-bottom-pad,
        align(bottom + right, letter-header-simple(
          author-name,
          { author.address; linebreak(); author.city },
          phone: author.at("phone", default: none),
          email: author.at("email", default: none),
          get-string: get-string,
          lang: lang,
        )),
      ),

      // Address zone (single-column recipient block)
      pad(left: letter-address-zone-pad-left, right: letter-address-zone-pad-right, {
        if letter-show-sender-strip {
          grid(
            columns: 1,
            rows: (letter-sender-zone-height, effective-address-zone-height - letter-sender-zone-height),

            // Sender return strip (for window envelopes)
            align(bottom, pad(bottom: 0.65em, letter-sender-box(author-name, author.address + ", " + author.city))),

            // Recipient
            {
              set text(size: letter-recipient-size, font: letter-body-font)
              set align(top)
              pad(left: letter-address-pad-left, {
                if "company" in recipient { strong(recipient.company); linebreak() }
                if "name" in recipient { recipient.name; linebreak() }
                if "address" in recipient { recipient.address; linebreak() }
                if "city" in recipient { recipient.city }
              })
            },
          )
        } else {
          // No sender strip — single recipient block fills the zone
          set text(size: letter-recipient-size, font: letter-body-font)
          set align(top)
          pad(left: letter-address-pad-left, {
            if "company" in recipient { strong(recipient.company); linebreak() }
            if "name" in recipient { recipient.name; linebreak() }
            if "address" in recipient { recipient.address; linebreak() }
            if "city" in recipient { recipient.city }
          })
        }
      }),
    )
  })

  v(letter-body-gap)

  // -- Body content -------------------------------------------

  // Date (right-aligned)
  if date != none {
    align(right, text(size: letter-recipient-size, date))
    v(letter-date-gap)
  }

  // Subject line (bold)
  if subject != none {
    v(letter-subject-before)
    text(weight: "bold", size: letter-subject-size, subject)
    v(letter-subject-after)
  }

  // Salutation + body paragraphs — narrative font
  {
    set text(font: letter-narrative-font, size: letter-narrative-size)
    set par(leading: letter-narrative-leading, spacing: letter-narrative-par-spacing)

    {
      let sal = if salutation == auto { get-string(lang, "letter-salutation-default") } else { salutation }
      sal
      v(letter-date-gap)
    }

    // Body — native Typst content
    body-content
  }

  // Closing + signature + author name
  {
    set text(font: letter-narrative-font, size: letter-narrative-size)

    v(letter-closing-gap)
    let cl = if closing == auto { get-string(lang, "letter-closing-default") } else { closing }
    cl
  }
  {
    set text(font: letter-body-font, size: letter-narrative-size)
    // Signature image
    if signature-image != none {
      v(letter-signature-gap)
      block(width: letter-signature-width)[#signature-image]
    }

    // Author name below signature
    v(letter-signature-gap)
    author-name
  }

  // Enclosures
  if enclosures != none {
    v(letter-enclosures-gap)
    text(weight: "bold", get-string(lang, "letter-enclosures-label") + ": ") + enclosures
  }
}
