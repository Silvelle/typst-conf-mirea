#import "styles.typ": body-font, number-gap, style-par, styles
#import "headings.typ": (
  chapter-numbering, contents, heading-rules, restart-each-chapter, section,
)
#import "lists.typ": list-rules, sources-list
#import "figures.typ": figure-image, figure-rules, figure-table
#import "code.typ": code-listing, listing-counter

#let conf(
  title: "", // PDF metadata only; does not print anywhere
  author: "",
  // One ready-made title sheet or an array of them, placed full-bleed and
  // unnumbered before the body. Pass the `image()` calls themselves, not
  // paths: a path would resolve against this package.
  title-page: none,
  page-number-position: "footer", // or "header"
  // First page whose number is printed; earlier pages are still counted.
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
    // GOST measures the margin to the text area; the page number then sits
    // inside it, the way Word places a footer.
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
    // Pinned to the metrics Word uses, so leading computed from the
    // line-spacing multiplier matches the reference documents.
    top-edge: 0.8em,
    bottom-edge: -0.2em,
    hyphenate: false,
  )

  let title-pages = if title-page == none { () } else if (
    type(title-page) == array
  ) { title-page } else { (title-page,) }
  for sheet in title-pages {
    assert(
      type(sheet) != str,
      message: "title-page takes content, not a path — write "
        + "image(\"/assets/title.png\", width: 100%, height: 100%) in your "
        + "own document, or the path resolves against this package",
    )
    // `margin: 0pt` so the sheet is reproduced exactly.
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
    counter(figure.where(kind: image)),
    counter(figure.where(kind: table)),
    listing-counter,
  )

  doc
}
