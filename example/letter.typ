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

// Read CLI inputs
#let start-page = int(sys.inputs.at("start-page", default: "1"))
#let total-pages = sys.inputs.at("total-pages", default: none)
#let total-pages = if total-pages != none { int(total-pages) } else { none }

#cover-letter-page(
  author,
  recipient,
  language: "en",
  date: "15.01.2026",
  start-page: start-page,
  total-pages: total-pages,
  get-string: get-string,
  signature-image: image("images/signature.png"),
)[
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do
  eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
  minim veniam, quis nostrud exercitation ullamco laboris nisi ut
  aliquip ex ea commodo consequat.

  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum
  dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
  proident, sunt in culpa qui officia deserunt mollit anim id est
  laborum. Sed ut perspiciatis unde omnis iste natus error sit
  voluptatem accusantium doloremque laudantium.

  Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut
  fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem
  sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor
  sit amet, consectetur, adipisci velit.

  - Lorem ipsum dolor sit amet
  - Consectetur adipiscing elit

  Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis
  suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur. Quis
  autem vel eum iure reprehenderit qui in ea voluptate velit esse quam
  nihil molestiae consequatur.
]
