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

#let figure-image(src, caption: none, width: auto, alt: none) = figure(
  image(src, width: width, alt: alt),
  caption: caption,
  kind: image,
  supplement: [Рисунок],
  numbering: chapter-numbering,
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
) = {
  show figure: set block(breakable: breakable)
  figure(
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
    caption: caption,
    kind: table,
    supplement: [Таблица],
    numbering: chapter-numbering,
  )
}
