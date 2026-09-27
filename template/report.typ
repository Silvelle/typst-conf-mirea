#import "styles.typ": body-font, number-gap, style-par, styles
#import "headings.typ": (
  chapter-numbering, contents, heading-rules, restart-each-chapter, section,
)
#import "lists.typ": list-rules, sources-list
#import "figures.typ": (
  figure-image, figure-rules, figure-table, image-figure, table-figure,
)
#import "code.typ": code-listing, listing-counter

#let conf(
  title: "",
  author: "",
  title-page: none,
  page-number-position: "footer",
  page-number-start: 2,
  doc,
) = {
  set document(title: title, author: author)

  let page-number = context {
    let n = counter(page).get().first()
    if n >= page-number-start {
      align(center, text(
        font: body-font,
        size: 11pt,
        top-edge: "cap-height",
        bottom-edge: "baseline",
        str(n),
      ))
    }
  }

  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1.5cm),
    header-ascent: number-gap,
    footer-descent: number-gap,
    header: if page-number-position == "header" { page-number },
    footer: if page-number-position == "footer" { page-number },
  )

  set text(
    font: body-font,
    size: styles.body.size,
    lang: "ru",
    region: "ru",
    top-edge: 0.8em,
    bottom-edge: -0.2em,
    hyphenate: false,
  )

  let sheets = if title-page == none { () } else if (
    type(title-page) == array
  ) { title-page } else { (title-page,) }

  for sheet in sheets {
    assert(
      type(sheet) != str,
      message: "title-page takes content, not a path — write "
        + "image(\"/assets/title.png\", width: 100%, height: 100%) in your "
        + "own document, or the path resolves against this package",
    )
    page(
      margin: 0pt,
      header: none,
      footer: none,
      align(center + horizon, sheet),
    )
  }

  show: style-par(styles.body)
  show: heading-rules
  show: list-rules
  show: figure-rules
  show: restart-each-chapter(
    counter(image-figure),
    counter(table-figure),
    listing-counter,
  )

  doc
}
