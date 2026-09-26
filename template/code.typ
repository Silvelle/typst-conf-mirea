#import "styles.typ": (
  body-lead, code-font, rule-clearance, space-below, style-par, style-text,
  styles,
)
#import "headings.typ": chapter-numbering

// Listings are not figures, so they need a counter of their own; `conf`
// restarts it at each chapter alongside the figure and table counters.
#let listing-counter = counter("code-listing")

#let code-listing(body, caption: none, highlight: false) = {
  let s = styles.listing
  let cap = styles.listing-caption
  let code = if type(body) == str { raw(body, block: true) } else { body }

  block(
    width: 100%,
    above: body-lead + cap.before,
    below: space-below(s),
    breakable: true,
    {
      if caption != none {
        listing-counter.step()
        block(
          width: 100%,
          below: cap.after + rule-clearance,
          sticky: true, // keeps the caption with the code it names
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
        breakable: true,
        fill: if highlight { rgb("#f2f2f2") } else { white },
        stroke: if highlight { none } else { 0.5pt + black },
        inset: if highlight {
          (x: 0.1in, y: 6pt)
        } else {
          (top: 1pt, right: 0.075in, bottom: 0pt, left: 0.075in)
        },
        {
          // `theme: none` drops syntax colouring; plain `fill` would not,
          // since the highlighter sets its own colours per token.
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
