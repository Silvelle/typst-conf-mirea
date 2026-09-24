// Report styles for GOST-like Russian technical and academic documents.
// Requires Typst 0.14 or newer, where `image()` learned to read PDFs — the
// usual way a ready-made title sheet arrives.
//
// #import "@local/typst-conf-mirea:0.1.0": conf
// #show: conf.with(title: "Название отчёта", author: "Автор")

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
  // A ready-made title sheet, or an array of them when the title matter runs
  // over several pages, placed full-bleed and unnumbered before the body:
  //
  //   title-page: image("/assets/title.pdf", width: 100%, height: 100%)
  //   title-page: range(1, 3).map(i => image(
  //     "/assets/title.pdf", page: i, width: 100%, height: 100%))
  //
  // Add `fit: "contain"` if the sheet is not A4, or it is stretched to fit.
  // Pass the `image()` calls themselves, not paths: a path string would
  // resolve against this package rather than the caller's project.
  title-page: none,
  // Where the page number is printed: "footer" or "header".
  page-number-position: "footer",
  // First page whose number is printed; earlier pages are still counted.
  // Pages from `title-page` never show a number regardless of this value — it
  // only matters for unnumbered pages written directly into `doc`, e.g. a
  // hand-typed title page: set it to 3 if that occupies two pages.
  page-number-start: 2,
  doc,
) = {
  set document(title: title, author: author)

  // `context` so the counter is read at layout time, per page.
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
    // Keep the number clear of the text area: a block that fills the area
    // exactly — a framed listing above all — would otherwise touch it.
    header-ascent: number-gap,
    footer-descent: number-gap,
    header: if page-number-position == "header" { page-number },
    footer: if page-number-position == "footer" { page-number },
  )

  set text(
    font: body-font,
    size: styles.body.size,
    lang: "ru", // Russian hyphenation and quotation marks
    region: "ru",
    // Pin the line box to the metrics Word uses, so leading computed from the
    // line-spacing multiplier matches the reference documents.
    top-edge: 0.8em,
    bottom-edge: -0.2em,
    hyphenate: false, // GOST reports are set without word division
  )

  // Accept one sheet or several, and treat both the same way below.
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
    // `margin: 0pt` so the sheet is reproduced exactly; centred in case it
    // does not cover the whole page.
    page(margin: 0pt, header: none, footer: none, align(center + horizon, sheet))
  }

  // Body text rules, then one show rule per kind of element.
  show: style-par(styles.body)
  show: heading-rules
  show: list-rules
  show: figure-rules
  // Pictures, tables and listings are numbered within their chapter.
  show: restart-each-chapter(
    counter(figure.where(kind: image)),
    counter(figure.where(kind: table)),
    listing-counter,
  )

  doc
}
