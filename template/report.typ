// Report styles for GOST-like Russian technical and academic documents.
// Requires Typst 0.14 or newer, which is where `image()` learned to read
// PDFs — the usual way a ready-made title sheet arrives.
//
// #import "@local/gostovka:0.1.0": conf
// #show: conf.with(title: "Название отчёта", author: "Автор")

#import "styles.typ": body-font, number-gap, style-par, styles
#import "headings.typ": chapter-numbering, contents, heading-rules, section
#import "lists.typ": list-rules, sources-list
#import "figures.typ": figure-image, figure-rules, figure-table
#import "code.typ": code-listing, listing-rules

#let conf(
  title: "",
  author: "",
  // A ready-made title sheet, or an array of them when the title matter
  // runs over several pages, placed full-bleed and unnumbered before the
  // body. A PDF goes in as it is — no conversion to images needed:
  //
  //   title-page: image("/assets/title.pdf", width: 100%, height: 100%)
  //   title-page: range(1, 3).map(i => image(
  //     "/assets/title.pdf", page: i, width: 100%, height: 100%))
  //
  // Add `fit: "contain"` if the sheet is not A4, or it is stretched to fit.
  // Pass the `image()` calls themselves, not paths: a path string would
  // resolve against this package rather than the caller's project. Leave as
  // `none` (default) to skip — or author the title page in the document, as
  // the demo in `example-report.typ` does for illustration.
  title-page: none,
  // Where the page number is printed: "footer" or "header".
  page-number-position: "footer",
  // First page whose number is printed. Earlier pages are still counted.
  // Pages from `title-page` never show a number regardless of this value —
  // only relevant for unnumbered pages you write directly into `doc`, e.g.
  // a hand-typed title page: set it to 3 if that occupies two pages.
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
    // The 2 cm margin is measured to the text area, as GOST specifies; the
    // page number then sits inside that margin, the way Word places a footer.
    margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1.5cm),
    // Keep the number clear of the text area. Ordinary paragraphs leave
    // descender slack at the boundary, but a block that fills it exactly —
    // a framed listing continued onto the next page, above all — would
    // otherwise all but touch the number.
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
    // Fix the line box to the font metrics Word uses, so that leading computed
    // from the line-spacing multiplier matches the reference documents.
    top-edge: 0.8em,
    bottom-edge: -0.2em,
    hyphenate: false,
  )

  let title-pages = if title-page == none {
    ()
  } else if type(title-page) == array {
    title-page
  } else {
    (title-page,)
  }
  for sheet in title-pages {
    assert(
      type(sheet) != str,
      message: "title-page takes content, not a path — write "
        + "image(\"/assets/title.png\", width: 100%, height: 100%) in your "
        + "own document, or the path resolves against this package",
    )
    // Centred so a sheet that does not fill the page — an image scanned at
    // another aspect ratio, say — sits in the middle rather than top left.
    page(margin: 0pt, header: none, footer: none, align(center + horizon, sheet))
  }

  show: style-par(styles.body)
  show: heading-rules
  show: list-rules
  show: figure-rules
  show: listing-rules

  doc
}
