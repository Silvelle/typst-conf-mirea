// Framed code listings, captioned "Листинг N – …" and never syntax-highlighted
// so that printed reports stay monochrome.

#import "styles.typ": (
  body-lead, code-font, space-below, style-par, style-text, styles,
)
#import "headings.typ": chapter-label

#let listing-counter = counter("code-listing")

// Restarts listing numbering at each chapter, matching figures and tables.
#let listing-rules(doc) = {
  show heading.where(level: 1): it => { listing-counter.update(0); it }
  doc
}

#let code-listing(body, caption: none) = {
  let s = styles.listing
  let cap = styles.listing-caption
  let code = if type(body) == str { raw(body, block: true) } else { body }

  listing-counter.step()
  block(
    width: 100%,
    above: body-lead + cap.before,
    below: space-below(s),
    breakable: true,
    {
      if caption != none {
        block(width: 100%, below: cap.after, sticky: true, {
          show: style-par(cap)
          style-text(
            cap,
            [Листинг #context chapter-label(listing-counter.get().first()) – #caption],
          )
        })
      }
      block(
        width: 100%,
        breakable: true,
        fill: white,
        stroke: 0.5pt + black,
        inset: (top: 1pt, right: 0.075in, bottom: 0pt, left: 0.075in),
        {
          set raw(theme: none)
          set text(font: code-font, size: s.size)
          show raw: set text(font: code-font, size: s.size)
          show: style-par(s)
          code
        },
      )
    },
  )
}
