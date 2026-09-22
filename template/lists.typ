// Bullet and numbered lists, plus the reference list at the end of a report.

#import "styles.typ": (
  enum-items, lead-of, marked-par, space-above, space-below, style-par, styles,
)

#let list-rules(doc) = {
  let s = styles.list-item

  show list: it => {
    show: style-par(s)
    for child in it.children { marked-par([–], child.body) }
  }

  show enum: it => {
    show: style-par(s)
    for (marker, body) in enum-items(it) { marked-par(marker, body) }
  }

  doc
}

// Wraps a numbered list so that entries get a hanging indent and extra spacing.
// The bibliographic format of each entry is left to the author.
#let sources-list(body) = {
  let s = styles.source-entry

  show enum: it => {
    show: style-par(s)
    set par(spacing: s.before + s.after + lead-of(s))
    for (marker, entry) in enum-items(it) { marked-par(marker, entry) }
  }

  block(above: space-above(s), below: space-below(s), body)
}
