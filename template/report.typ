// Reusable report styles. Requires Typst 0.12 or newer.

#let body-font = ("Times New Roman", "Tinos", "Liberation Serif")
#let code-font = ("Courier New", "Liberation Mono")

#let word-single-factor = 1.15
#let word-single = word-single-factor * 1em
#let leading-for(mult) = word-single * mult - 1em
#let extra-lead(mult, size) = (word-single-factor * mult - 1.0) * size
#let body-size = 14pt
#let body-lead = extra-lead(1.5, body-size)

#let indent = 1.25cm
#let text-width = 16.5cm
#let table-compact-inset = (left: 0.08in, right: 0.08in, top: 0in, bottom: 0in)
#let table-padded-inset = (left: 0.16cm, right: 0.16cm, top: 0.12cm, bottom: 0.12cm)
#let table-cell-inset = table-compact-inset

#let para-style(
  size: 14pt,
  weight: "regular",
  shape: "normal",
  caps: false,
  align: "left",
  line: 1.5,
  before: 0pt,
  after: 0pt,
  left: 0pt,
  first-line: 0pt,
  hanging: none,
  page-break-before: false,
  keep-next: false,
  breakable: true,
) = (
  size: size,
  weight: weight,
  shape: shape,
  caps: caps,
  align: align,
  line: line,
  before: before,
  after: after,
  left: left,
  first-line: first-line,
  hanging: hanging,
  page-break-before: page-break-before,
  keep-next: keep-next,
  breakable: breakable,
)

#let word-styles = (
  body: para-style(
    size: 14pt,
    align: "justify",
    line: 1.5,
    first-line: indent,
  ),
  heading1: para-style(
    size: 18pt,
    weight: "bold",
    caps: true,
    line: 1.5,
    after: 10pt,
    left: indent,
    page-break-before: true,
    keep-next: true,
    breakable: false,
  ),
  structural-heading: para-style(
    size: 18pt,
    weight: "bold",
    caps: true,
    align: "center",
    line: 1.5,
    after: 10pt,
    page-break-before: true,
    keep-next: true,
    breakable: false,
  ),
  heading2: para-style(
    size: 16pt,
    weight: "bold",
    line: 1.5,
    before: 15pt,
    after: 10pt,
    left: indent,
    keep-next: true,
    breakable: false,
  ),
  heading3: para-style(
    size: 14pt,
    weight: "bold",
    line: 1.5,
    before: 15pt,
    after: 10pt,
    left: indent,
    keep-next: true,
    breakable: false,
  ),
  figure-caption: para-style(
    size: 12pt,
    align: "center",
    line: 1.0,
    after: 6pt,
  ),
  table-caption: para-style(
    size: 14pt,
    shape: "italic",
    align: "left",
    line: 1.0,
    before: 0.0835in,
  ),
  table-cell: para-style(
    size: 12pt,
    align: "left",
    line: 1.0,
  ),
  listing: para-style(
    size: 10pt,
    align: "left",
    line: 1.0,
  ),
  listing-caption: para-style(
    size: 14pt,
    shape: "italic",
    align: "left",
    line: 1.0,
    before: 0.0835in,
    after: 0pt,
  ),
  source-entry: para-style(
    size: 14pt,
    align: "justify",
    line: 1.5,
    before: 6pt,
    after: 6pt,
    first-line: 0.635cm,
    hanging: 1.27cm,
  ),
  toc-entry: para-style(
    size: 14pt,
    line: 1.0,
    after: 5pt,
  ),
  list-item: para-style(
    size: 14pt,
    align: "justify",
    line: 1.5,
    first-line: indent,
  ),
)

#let space-above(s) = s.before + extra-lead(s.line, s.size)

#let space-below(s, followed-by: none) = {
  let next = if followed-by == none { word-styles.body } else { followed-by }
  s.after + extra-lead(next.line, next.size)
}

#let align-of(s) = if s.align == "center" { center } else if s.align == "right" {
  right
} else { left }

#let style-text(s, body) = text(
  size: s.size,
  weight: s.weight,
  style: s.shape,
  if s.caps { upper(body) } else { body },
)

#let style-par(s) = body => {
  set par(
    justify: s.align == "justify",
    first-line-indent: (amount: s.first-line, all: true),
    hanging-indent: if s.hanging == none { 0pt } else { s.hanging },
    leading: leading-for(s.line),
    spacing: leading-for(s.line),
  )
  body
}

#let styled(s, body, followed-by: none) = block(
  above: space-above(s),
  below: space-below(s, followed-by: followed-by),
  breakable: s.breakable,
  sticky: s.keep-next,
  {
    show: style-par(s)
    let content = style-text(s, body)
    pad(
      left: s.left,
      if s.align == "center" { std.align(center, content) } else { content },
    )
  },
)

#let conf(
  title: "",
  author: none,
  page-number-position: "footer",
  // Page 1 is counted but its number is hidden, as required for a title page.
  show-page-number-on-first-page: false,
  doc,
) = {
  set document(title: title, author: if author != none { author } else { "" })

  let page-number = context {
    let n = counter(page).get().first()
    if n == 1 and not show-page-number-on-first-page {
      []
    } else {
      align(center, text(font: body-font, size: 11pt, str(n)))
    }
  }

  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1.5cm),
    header-ascent: 0cm,
    footer-descent: 0cm,
    header: if page-number-position == "header" { page-number } else { none },
    footer: if page-number-position == "footer" { page-number } else { none },
  )

  let body-style = word-styles.body
  set text(
    font: body-font,
    size: body-style.size,
    lang: "ru",
    region: "ru",
    top-edge: 0.8em,
    bottom-edge: -0.2em,
    hyphenate: false,
  )
  show: style-par(body-style)

  set heading(numbering: "1.1.1")
  let heading-styles = (
    word-styles.heading1,
    word-styles.heading2,
    word-styles.heading3,
  )

  show heading: it => {
    let s = if it.level == 1 and it.numbering == none {
      word-styles.structural-heading
    } else {
      heading-styles.at(it.level - 1, default: heading-styles.last())
    }
    let number = if it.numbering != none {
      counter(heading).display(it.numbering) + h(0.4em)
    } else {
      []
    }
    if s.page-break-before { pagebreak(weak: true) }
    styled(s, number + it.body)
  }

  let item-style = word-styles.list-item
  let flat-item(marker, body) = par(
    first-line-indent: (amount: item-style.first-line, all: true),
    box(width: 0.635cm, std.align(left, marker)) + body,
  )

  show list: it => {
    show: style-par(item-style)
    for child in it.children {
      flat-item([–], child.body)
    }
  }

  show enum: it => {
    show: style-par(item-style)
    let n = 0
    for child in it.children {
      n = if type(child.number) == int { child.number } else { n + 1 }
      flat-item(numbering("1.", n), child.body)
    }
  }

  set table(
    stroke: 0.5pt + black,
    inset: table-cell-inset,
  )
  let cell-style = word-styles.table-cell
  show table: set text(size: cell-style.size)
  show table: style-par(cell-style)

  set figure.caption(separator: [ – ])
  let fig-style = word-styles.figure-caption
  let fig-gap = fig-style.after + extra-lead(fig-style.line, fig-style.size)
  show figure.where(kind: image): set figure(gap: fig-gap)
  show figure.where(kind: image): set block(
    above: fig-gap,
    below: space-below(fig-style),
  )
  show figure.where(kind: image): it => {
    set text(size: fig-style.size)
    show: style-par(fig-style)
    it
  }

  let cap-style = word-styles.table-caption
  show figure.where(kind: table): set figure(gap: cap-style.after)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set std.align(left)
  show figure.where(kind: table): set block(
    above: body-lead + cap-style.before,
    below: space-below(cap-style),
  )
  show figure.where(kind: table): it => {
    show figure.caption: c => block(
      width: 100%,
      std.align(align-of(cap-style), style-text(cap-style, c)),
    )
    show: style-par(cap-style)
    it
  }

  doc
}

#let figure-image(src, caption: none, width: auto, alt: none) = figure(
  image(src, width: width, alt: alt),
  caption: caption,
  kind: image,
  supplement: [Рисунок],
  numbering: "1",
)

#let screenshot(src, caption: none, width: auto) = figure-image(
  src,
  caption: caption,
  width: width,
)

#let diagram(src, caption: none, width: auto) = figure-image(
  src,
  caption: caption,
  width: width,
)

#let figure-table(
  columns: auto,
  caption: none,
  header: none,
  align: left,
  cell-inset: table-compact-inset,
  ..rows,
) = {
  let cell-align = align
  figure(
    table(
      columns: columns,
      align: cell-align,
      inset: cell-inset,
      ..if header != none {
        (table.header(
          ..header.map(c => table.cell(
            inset: cell-inset,
            std.align(center, strong(c)),
          )),
        ),)
      } else { () },
      ..rows.pos().flatten(),
    ),
    caption: caption,
    kind: table,
    supplement: [Таблица],
    numbering: "1",
  )
}

#let numbered-table(
  columns: auto,
  caption: none,
  header: none,
  repeat-header: false,
  align: left,
  cell-inset: table-compact-inset,
  ..cells,
) = {
  let cap-style = word-styles.table-caption
  let table-count = counter(figure.where(kind: table))

  table-count.step()
  block(
    above: body-lead + cap-style.before,
    below: space-below(cap-style),
    breakable: true,
    {
      if caption != none {
        block(
          width: 100%,
          below: cap-style.after,
          sticky: true,
          {
            show: style-par(cap-style)
            std.align(
              align-of(cap-style),
              style-text(
                cap-style,
                context [Таблица #table-count.display("1") – #caption],
              ),
            )
          },
        )
      }

      table(
        columns: columns,
        align: align,
        inset: cell-inset,
        ..if header != none {
          (table.header(
            repeat: repeat-header,
            ..header.map(cell => table.cell(
              inset: cell-inset,
              std.align(center, strong(cell)),
            )),
          ),)
        } else { () },
        ..cells.pos().flatten(),
      )
    },
  )
}

#let listing-counter = counter("code-listing")

#let code-listing(body, caption: none, lang: none) = {
  let code-style = word-styles.listing
  let caption-style = word-styles.listing-caption
  let code = if type(body) == str {
    raw(body, block: true)
  } else if type(body) == content and body.func() == raw {
    raw(body.text, block: true)
  } else {
    body
  }

  listing-counter.step()
  block(
    width: 100%,
    above: body-lead + caption-style.before,
    below: space-below(code-style),
    breakable: true,
    {
      if caption != none {
        block(
          width: 100%,
          below: caption-style.after,
          {
            show: style-par(caption-style)
            style-text(
              caption-style,
              [Листинг #context listing-counter.display("1") — #caption],
            )
          },
        )
      }
      block(
        width: 100%,
        breakable: true,
        fill: white,
        stroke: 0.5pt + black,
        inset: (top: 1pt, right: 0.075in, bottom: 0pt, left: 0.075in),
        {
          set text(font: code-font, size: code-style.size, fill: black)
          show raw: set text(font: code-font, size: code-style.size, fill: black)
          show: style-par(code-style)
          code
        },
      )
    },
  )
}

#let section(body, outlined: true) = heading(
  level: 1,
  numbering: none,
  outlined: outlined,
  body,
)

#let contents(title: [Содержание], depth: 3, level-indent: (0cm, 0cm, 0cm)) = {
  section(title, outlined: false)

  let entry-style = word-styles.toc-entry
  show outline.entry: it => {
    show: style-par(entry-style)
    set text(size: entry-style.size)
    block(
      above: 0pt,
      below: space-below(entry-style, followed-by: entry-style),
      pad(left: level-indent.at(it.level - 1, default: level-indent.last()), it),
    )
  }
  set outline.entry(fill: repeat[.])
  outline(title: none, depth: depth, indent: 0pt)
}

#let sources-list(body) = {
  let s = word-styles.source-entry
  show enum: it => {
    show: style-par(s)
    set par(spacing: s.before + s.after + extra-lead(s.line, s.size))
    let n = 0
    for child in it.children {
      n = if type(child.number) == int { child.number } else { n + 1 }
      par(
        box(width: s.first-line, std.align(left, numbering("1.", n)))
          + child.body,
      )
    }
  }
  block(above: space-above(s), below: space-below(s), body)
}
