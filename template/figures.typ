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

  let cap = styles.figure-caption
  let gap = cap.after + lead-of(cap)
  show figure.where(kind: image): set figure(gap: gap)
  show figure.where(kind: image): set block(above: gap, below: space-below(cap))
  show figure.where(kind: image): it => {
    set text(size: cap.size)
    show: style-par(cap)
    it
  }

  let tcap = styles.table-caption
  set table(stroke: 0.5pt + black, inset: table-inset)
  show table: set text(size: styles.table-cell.size)
  show table: style-par(styles.table-cell)
  show figure.where(kind: table): set figure(gap: tcap.after)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set align(left)
  show figure.where(kind: table): set block(
    above: body-lead + tcap.before,
    below: space-below(tcap),
  )
  show figure.where(kind: table): it => {
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

// Wraps ready-made content — typically `image(...)`, but any diagram built
// from Typst primitives works too — as a figure captioned "Рисунок N" /
// "Рисунок N.M". Call `image()` yourself in the document that uses this
// function, with a path relative to that document's own project (a leading
// `/` resolves against its root). Passing a bare path string here would
// resolve it against this package's own files instead of the caller's,
// because `image()` always resolves paths relative to the file that
// contains the call — silently wrong once this module is used as a package.
#let figure-image(body, caption: none) = figure(
  body,
  caption: caption,
  kind: image,
  supplement: [Рисунок],
  // A number only ever shows as part of a caption, so an uncaptioned figure
  // must not take one and leave a gap in the sequence.
  numbering: if caption == none { none } else { chapter-numbering },
)

// `header` is a tuple of cells rendered bold and centred; `..cells` are the
// remaining cells in row-major order. Long tables split across pages and
// repeat their header unless told otherwise.
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
  // `breakable` wraps the table body itself, not the figure — a local
  // `show figure: set block(...)` here would turn this function's return
  // value into a styled wrapper, and `#figure-table(...) <label>` would then
  // fail with "cannot reference styled" instead of labelling the table.
  block(
    breakable: breakable,
    table(
      columns: columns,
      align: align,
      inset: inset,
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
