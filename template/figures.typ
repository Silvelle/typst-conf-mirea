#import "styles.typ": (
  align-of, body-lead, lead-of, rule-clearance, space-below, style-par,
  style-text, styles, table-inset,
)
#import "headings.typ": chapter-numbering

#let figure-rules(doc) = {
  set figure.caption(separator: [ – ])

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
  // GOST wants "Продолжение таблицы" on a continued page rather than a second
  // header row; an explicit `table.header(repeat: true)` still wins.
  set table.header(repeat: false)
  show table: set text(size: styles.table-cell.size)
  show table: style-par(styles.table-cell)

  show figure.where(kind: table): set figure(
    gap: tcap.after + rule-clearance,
  )
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set align(left)
  // Without `breakable` a table taller than the space left on the page moves
  // to the next one whole; the inner block of `figure-table` keeps its own
  // value, so `breakable: false` there still holds the table together.
  show figure.where(kind: table): set block(
    breakable: true,
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

// Call `image()` in your own document rather than passing a path: `image()`
// resolves paths against the file holding the call.
#let figure-image(body, caption: none) = figure(
  body,
  caption: caption,
  kind: image,
  supplement: [Рисунок],
  numbering: if caption == none { none } else { chapter-numbering },
)

#let figure-table(
  columns: auto,
  caption: none,
  header: none,
  repeat-header: false,
  breakable: true,
  align: left,
  inset: table-inset,
  ..cells,
) = figure(
  // `breakable` wraps the table body, not the figure: a local
  // `show figure: set block(...)` would return a styled wrapper and
  // `#figure-table(...) <label>` would fail with "cannot reference styled".
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
