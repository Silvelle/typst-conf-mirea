#import "styles.typ": (
  align-of, body-lead, lead-of, rule-clearance, space-below, style-par,
  style-text, styles, table-inset,
)
#import "headings.typ": chapter-numbering

#let image-figure = figure.where(kind: image)
#let table-figure = figure.where(kind: table)

#let image-rules(doc) = {
  let cap = styles.figure-caption
  let gap = cap.after + lead-of(cap)

  show image-figure: set figure(gap: gap)
  show image-figure: set block(above: gap, below: space-below(cap))
  show image-figure: it => {
    set text(size: cap.size)
    show: style-par(cap)
    it
  }

  doc
}

#let table-rules(doc) = {
  let cell = styles.table-cell
  let cap = styles.table-caption

  set table(stroke: 0.5pt + black, inset: table-inset)
  set table.header(repeat: false)
  set table.cell(align: top)
  show table: set text(
    size: cell.size,
    hyphenate: true,
    costs: (orphan: 0%, widow: 0%, hyphenation: 200000%),
  )
  show table: set par(linebreaks: "optimized")
  show table: style-par(cell)
  show table: it => {
    show raw: set text(hyphenate: false)
    it
  }

  show table-figure: set figure(gap: cap.after + rule-clearance)
  show table-figure: set figure.caption(position: top)
  show table-figure: set align(left)
  show table-figure: set block(
    breakable: true,
    above: body-lead + cap.before,
    below: space-below(cap),
  )
  show table-figure: it => {
    show figure.caption: c => block(
      width: 100%,
      sticky: true,
      std.align(align-of(cap), style-text(cap, c)),
    )
    show: style-par(cap)
    it
  }

  doc
}

#let figure-rules(doc) = {
  set figure.caption(separator: [ – ])
  show: image-rules
  show: table-rules
  doc
}

#let figure-image(body, caption: none) = figure(
  body,
  caption: caption,
  kind: image,
  supplement: [Рисунок],
  numbering: if caption == none { none } else { chapter-numbering },
)

#let pin-cell-top(c) = {
  if type(c) != content or c.func() != table.cell { return c }
  let f = c.fields()
  if "align" not in f or type(f.align) != alignment { return c }
  let body = f.remove("body")
  f.align = if f.align.x == none { top } else { f.align.x + top }
  table.cell(..f, body)
}

#let header-row(cells, repeat: false, inset: table-inset) = table.header(
  repeat: repeat,
  ..cells.map(c => table.cell(
    inset: inset,
    align: center + horizon,
    strong(c),
  )),
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
  block(
    breakable: breakable,
    table(
      columns: if columns == auto and header != none {
        header.len()
      } else { columns },
      align: align,
      inset: inset,
      ..if header == none { () } else {
        (header-row(header, repeat: repeat-header, inset: inset),)
      },
      ..cells.pos().flatten().map(pin-cell-top),
    ),
  ),
  caption: caption,
  kind: table,
  supplement: [Таблица],
  numbering: if caption == none { none } else { chapter-numbering },
)
