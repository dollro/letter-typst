// ==========================================================
// letter-typst -- Main Library
// ==========================================================

// Load localization data
#let letter-lang-data = toml("lang-letter.toml")

#let get-string(lang, key) = {
  let letter-strings = letter-lang-data.at(lang, default: letter-lang-data.at("en"))
  letter-strings.at(key)
}

// Components
#import "_letter-components.typ": letter-sender-box, letter-recipient-box, letter-address-box, letter-marks, letter-header-simple

// Layout functions
#import "letter.typ": cover-letter-page
