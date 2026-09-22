// Framed code listings, captioned "Листинг N – …" and never syntax-highlighted
// so that printed reports stay monochrome.

#import "styles.typ": (
  body-lead, code-font, space-below, style-par, style-text, styles,
)
#import "headings.typ": chapter-label

// Listings are not figures, so they need a counter of their own.
#let listing-counter = counter("code-listing")

// Restarts listing numbering at each chapter, matching figures and tables.
#let listing-rules(doc) = {
  show heading.where(level: 1): it => { listing-counter.update(0); it }
  doc
}

#let code-listing(body, caption: none) = {
  let s = styles.listing
  let cap = styles.listing-caption
  // Accept a plain string as well as a ```…``` block.
  let code = if type(body) == str { raw(body, block: true) } else { body }

  block(
    width: 100%,
    above: body-lead + cap.before,
    below: space-below(s),
    breakable: true, // long listings may run onto the next page
    {
      if caption != none {
        // Only a captioned listing takes a number: an unnumbered snippet
        // must not consume one and leave a gap in the sequence.
        listing-counter.step()
        // `sticky` keeps the caption with the code it names.
        block(width: 100%, below: cap.after, sticky: true, {
          show: style-par(cap)
          style-text(
            cap,
            [Листинг #context chapter-label(listing-counter.get().first()) – #caption],
          )
        })
      }
      // The frame around the code.
      block(
        width: 100%,
        breakable: true,
        fill: white,
        stroke: 0.5pt + black,
        inset: (top: 1pt, right: 0.075in, bottom: 0pt, left: 0.075in),
        {
          // `theme: none` drops syntax colouring; plain `fill` would not,
          // since the highlighter sets its own colours per token.
          set raw(theme: none)
          set text(font: code-font, size: s.size)
          // `raw` carries its own font, so it has to be set again here.
          show raw: set text(font: code-font, size: s.size)
          show: style-par(s)
          code
        },
      )
    },
  )
}
