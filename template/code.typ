#import "styles.typ": (
  body-lead, code-font, rule-clearance, space-below, style-par, style-text,
  styles,
)
#import "headings.typ": chapter-numbering

#let listing-counter = counter("code-listing")

#let code-listing(body, caption: none, highlight: false) = {
  let s = styles.listing
  let cap = styles.listing-caption
  let code = if type(body) == str { raw(body, block: true) } else { body }

  let frame = if highlight {
    (fill: rgb("#f2f2f2"), stroke: none, inset: (x: 0.1in, y: 6pt))
  } else {
    (
      fill: white,
      stroke: 0.5pt + black,
      inset: (top: 1pt, right: 0.075in, bottom: 0pt, left: 0.075in),
    )
  }

  let title = if caption != none {
    listing-counter.step()
    block(
      width: 100%,
      below: cap.after + rule-clearance,
      sticky: true,
      {
        show: style-par(cap)
        style-text(cap, [
          Листинг #context chapter-numbering(listing-counter.get().first())
          – #caption
        ])
      },
    )
  }

  block(
    width: 100%,
    above: body-lead + cap.before,
    below: space-below(s),
    breakable: true,
    {
      title
      block(
        width: 100%,
        breakable: true,
        ..frame,
        {
          set raw(theme: if highlight { auto } else { none })
          set text(font: code-font, size: s.size)
          show raw: set text(font: code-font, size: s.size)
          show: style-par(s)
          code
        },
      )
    },
  )
}
