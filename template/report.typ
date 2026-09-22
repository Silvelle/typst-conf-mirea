// Report styles for GOST-like Russian technical and academic documents.
// Requires Typst 0.13 or newer.
//
// #import "template/report.typ": conf
// #show: conf.with(title: "Название отчёта", author: "Автор")

#import "styles.typ": body-font, style-par, styles
#import "headings.typ": chapter-numbering, contents, heading-rules, section
#import "lists.typ": list-rules, sources-list
#import "figures.typ": figure-image, figure-rules, figure-table
#import "code.typ": code-listing, listing-rules

#let conf(
  title: "",
  author: "",
  // Where the page number is printed: "footer" or "header".
  page-number-position: "footer",
  // First page whose number is printed. Earlier pages are still counted, so
  // set it to 3 when the title matter occupies two pages.
  page-number-start: 2,
  doc,
) = {
  set document(title: title, author: author)

  let page-number = context {
    let n = counter(page).get().first()
    if n >= page-number-start {
      align(center, text(font: body-font, size: 11pt, str(n)))
    }
  }

  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1.5cm),
    header-ascent: 0cm,
    footer-descent: 0cm,
    header: if page-number-position == "header" { page-number },
    footer: if page-number-position == "footer" { page-number },
  )

  set text(
    font: body-font,
    size: styles.body.size,
    lang: "ru",
    region: "ru",
    // Fix the line box to the font metrics Word uses, so that leading computed
    // from the line-spacing multiplier matches the reference documents.
    top-edge: 0.8em,
    bottom-edge: -0.2em,
    hyphenate: false,
  )

  show: style-par(styles.body)
  show: heading-rules
  show: list-rules
  show: figure-rules
  show: listing-rules

  doc
}
