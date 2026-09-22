// Numbered headings, unnumbered structural sections and the table of contents.

#import "styles.typ": space-below, style-par, styled, styles

// Number of the currently open top-level heading (`= Тема`), or `none`
// before the first one and inside unnumbered top-level sections such as
// `section([Заключение])`. Only level-1 headings touch it — GOST 6.5.6 and
// 6.6.4 scope figure and table numbering to the top-level "раздел", not to
// subsections. Figures, tables and listings read it to compose "2.3"-style
// captions; see `chapter-label` and `chapter-numbering` below.
#let chapter-number = state("chapter-number", none)

// Prefixes a counter's current value with the chapter number: "2.3" inside
// chapter 2, plain "3" outside any numbered chapter. Call from a `context`.
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
    let s = by-level.at(it.level - 1, default: by-level.last())
    let number = if it.numbering == none { [] } else {
      counter(heading).display(it.numbering) + h(0.4em)
    }
    if it.level == 1 {
      chapter-number.update(if it.numbering == none { none } else {
        context counter(heading).get().first()
      })
    }
    if s.page-break-before { pagebreak(weak: true) }
    styled(s, number + it.body)
  }

  doc
}

// An unnumbered first-level heading: "Введение", "Заключение", appendices.
#let section(body, outlined: true) = heading(
  level: 1,
  numbering: none,
  outlined: outlined,
  body,
)

#let contents(title: [Содержание], depth: 3) = {
  section(title, outlined: false)

  let s = styles.toc-entry
  set outline.entry(fill: repeat[.])
  show outline.entry: it => {
    show: style-par(s)
    set text(size: s.size)
    block(above: 0pt, below: space-below(s, followed-by: s), it)
  }
  outline(title: none, depth: depth, indent: 0pt)
}
