// Numbered headings, unnumbered structural sections and the table of contents.

#import "styles.typ": space-below, style-par, styled, styles

// Number of the open top-level heading, or `none` before the first one and
// inside unnumbered ones like `section([Заключение])`. Only level 1 touches
// it: GOST 6.5.6 and 6.6.4 scope figure and table numbers to the раздел,
// not to subsections.
#let chapter-number = state("chapter-number", none)

// "2.3" inside chapter 2, plain "3" outside one. Needs a `context`.
#let chapter-label(n) = {
  let chapter = chapter-number.get()
  if chapter == none { [#n] } else { [#chapter.#n] }
}

// Adapts `chapter-label` to the signature `figure(numbering: ...)` expects.
#let chapter-numbering(..nums) = context chapter-label(nums.pos().first())

#let heading-rules(doc) = {
  set heading(numbering: "1.1.1")
  let by-level = (styles.heading1, styles.heading2, styles.heading3)

  show heading: it => {
    // Levels below 3 keep the level-3 style.
    let s = by-level.at(it.level - 1, default: by-level.last())

    let number = if it.numbering == none { [] } else {
      counter(heading).display(it.numbering) + h(0.4em)
    }

    // Publish the chapter number for figure, table and listing captions.
    if it.level == 1 {
      chapter-number.update(if it.numbering == none { none } else {
        context counter(heading).get().first()
      })
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
    // `above: 0pt` — the gap between entries comes from `below` alone.
    block(above: 0pt, below: space-below(s, followed-by: s), it)
  }
  // Levels are not indented: GOST asks for a flat list.
  outline(title: none, depth: depth, indent: 0pt)
}
