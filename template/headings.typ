// Numbered headings, unnumbered structural sections and the table of contents.

#import "styles.typ": space-below, style-par, styled, styles

// Figures, tables and listings are numbered within a раздел (GOST 6.5.6,
// 6.6.4): "4.1" inside chapter 4, plain "1" outside one. Typst only ever
// steps the first level of such a counter, so the chapter is folded into
// that single number and unfolded again when it is printed. Holding the
// chapter in the counter, rather than reading the heading counter where the
// number appears, is what makes a reference show the chapter of the table it
// points at instead of the chapter it stands in.
#let chapter-scale = 1000

#let chapter-numbering(..nums) = {
  let n = nums.pos().first()
  if n < chapter-scale { numbering("1", n) } else {
    numbering(
      "1.1",
      calc.div-euclid(n, chapter-scale),
      calc.rem(n, chapter-scale),
    )
  }
}

// Restarts `counters` at every chapter, at that chapter's number.
#let restart-each-chapter(..counters) = doc => {
  show heading.where(level: 1): it => {
    // After `it`, so the heading counter has already taken its new value.
    it
    context {
      let chapter = if it.numbering == none { 0 } else {
        counter(heading).get().first()
      }
      for c in counters.pos() { c.update(chapter * chapter-scale) }
    }
  }
  doc
}

#let heading-rules(doc) = {
  set heading(numbering: "1.1.1")
  let by-level = (styles.heading1, styles.heading2, styles.heading3)

  show heading: it => {
    // Levels below 3 keep the level-3 style.
    let s = by-level.at(it.level - 1, default: by-level.last())
    let number = if it.numbering == none { [] } else {
      counter(heading).display(it.numbering) + h(0.4em)
    }
    // `weak` so an opening chapter does not leave a blank page behind it.
    if s.page-break-before { pagebreak(weak: true) }
    styled(s, number + it.body)
  }

  doc
}

// Unnumbered level-1 heading: Введение, Заключение, appendices.
#let section(body, outlined: true) = heading(
  level: 1,
  numbering: none,
  outlined: outlined,
  body,
)

#let contents(title: [Содержание], depth: 3) = {
  // The heading of the contents is not itself listed in them.
  section(title, outlined: false)

  let s = styles.toc-entry
  set outline.entry(fill: repeat[.]) // dot leaders
  show outline.entry: it => {
    show: style-par(s)
    set text(size: s.size)
    // The gap between entries comes from `below` alone.
    block(above: 0pt, below: space-below(s, followed-by: s), it)
  }
  // GOST asks for a flat list, so the levels are not indented.
  outline(title: none, depth: depth, indent: 0pt)
}
