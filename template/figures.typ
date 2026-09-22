// Numbered images and tables. Captions follow "Рисунок N – …" / "Таблица N – …".

#import "styles.typ": (
  align-of, body-lead, lead-of, space-below, style-par, style-text, styles,
  table-inset,
)
#import "headings.typ": chapter-numbering

#let figure-rules(doc) = {
  set figure.caption(separator: [ – ])

  // Restart image and table numbering at each chapter (GOST 6.5.6, 6.6.4).
  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    it
  }

  // Images: caption centred underneath, in the caption's own size.
  let cap = styles.figure-caption
  let gap = cap.after + lead-of(cap) // picture-to-caption distance
  show figure.where(kind: image): set figure(gap: gap)
  show figure.where(kind: image): set block(above: gap, below: space-below(cap))
  show figure.where(kind: image): it => {
    set text(size: cap.size)
    show: style-par(cap)
    it
  }

  // Table body: thin grid, 12 pt single-spaced cells.
  let tcap = styles.table-caption
  set table(stroke: 0.5pt + black, inset: table-inset)
  show table: set text(size: styles.table-cell.size)
  show table: style-par(styles.table-cell)

  // Table caption: above the table and flush left, unlike a figure caption.
  show figure.where(kind: table): set figure(gap: tcap.after)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set align(left)
  show figure.where(kind: table): set block(
    above: body-lead + tcap.before,
    below: space-below(tcap),
  )
  show figure.where(kind: table): it => {
    // `sticky` keeps the caption on the page with the table it names.
    show figure.caption: c => block(
      width: 100%,
      sticky: true,
      std.align(align-of(tcap), style-text(tcap, c)),
    )
    show: style-par(tcap)
    it
  }

  doc
}

// Wraps ready-made content — an `image(...)` or a diagram built from Typst
// primitives — as a numbered figure.
// Call `image()` in your own document rather than passing a path here:
// `image()` resolves paths against the file holding the call, so a path
// string would be looked up inside this package, not the caller's project.
#let figure-image(body, caption: none) = figure(
  body,
  caption: caption,
  kind: image,
  supplement: [Рисунок],
  // A number only shows as part of a caption, so an uncaptioned figure must
  // not take one and leave a gap in the sequence.
  numbering: if caption == none { none } else { chapter-numbering },
)

// `header` is a tuple of cells, set bold and centred; `..cells` are the rest
// in row-major order. Long tables split across pages, repeating the header.
#let figure-table(
  columns: auto,
  caption: none,
  header: none,
  repeat-header: true,
  breakable: true,
  align: left,
  inset: table-inset,
  ..cells,
) = figure(
  // `breakable` wraps the table body itself, not the figure: a local
  // `show figure: set block(...)` would make this function return a styled
  // wrapper, and `#figure-table(...) <label>` would then fail with
  // "cannot reference styled" instead of labelling the table.
  block(
    breakable: breakable,
    table(
      columns: columns,
      align: align,
      inset: inset,
      // Spread nothing when the table has no header row.
      ..if header == none { () } else {
        (table.header(
          repeat: repeat-header,
          ..header.map(c => table.cell(
            inset: inset,
            std.align(center, strong(c)),
          )),
        ),)
      },
      ..cells.pos().flatten(),
    ),
  ),
  caption: caption,
  kind: table,
  supplement: [Таблица],
  numbering: if caption == none { none } else { chapter-numbering },
)
