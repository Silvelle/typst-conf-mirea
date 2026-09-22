// Bullet and numbered lists, plus the reference list at the end of a report.

#import "styles.typ": (
  indent, lead-of, leading-for, marker-width, space-above, space-below,
  style-par, styles,
)

// A paragraph whose first line starts with a marker in a fixed-width box.
#let marked-par(marker, body) = par(
  box(width: marker-width, std.align(left, marker)) + body,
)

// Typst folds a nested list into the body of the item above it, so an item
// arrives as inline content followed by bare `list.item` / `enum.item`
// elements. They have to be pulled back out: left where they are, they end
// up inside `marked-par`'s `par`, which cannot hold blocks, and Typst drops
// them without a word.
#let split-nested(body) = {
  if body.func() == [].func() {
    let inline = ()
    let nested = ()
    for part in body.children {
      if part.func() in (list.item, enum.item) {
        nested.push(part)
      } else if nested.len() == 0 {
        inline.push(part)
      }
    }
    (inline.join(), nested)
  } else if body.func() in (list.item, enum.item) {
    ([], (body,))
  } else {
    (body, ())
  }
}

// Lays the children of a list or enum out as flat paragraphs carrying a
// marker, indenting any nested level. `spacing` sets the gap between
// entries; `auto` keeps the plain line spacing of `s`.
#let render-items(it, s, ordered: false, spacing: auto) = {
  show: style-par(s)
  set par(spacing: if spacing == auto { leading-for(s.line) } else { spacing })

  let n = 0
  for child in it.children {
    // Items rebuilt from a nested level carry no resolved number.
    n = if type(child.at("number", default: none)) == int {
      child.number
    } else {
      n + 1
    }

    let (inline, nested) = split-nested(child.body)
    marked-par(if ordered { numbering("1.", n) } else { [–] }, inline)
    if nested.len() > 0 {
      pad(left: indent, if ordered { enum(..nested) } else { list(..nested) })
    }
  }
}

#let list-rules(doc) = {
  let s = styles.list-item
  show list: it => render-items(it, s)
  show enum: it => render-items(it, s, ordered: true)
  doc
}

// Wraps a numbered list so that entries get a hanging indent and extra
// spacing. The bibliographic format of each entry is left to the author.
#let sources-list(body) = {
  let s = styles.source-entry
  show enum: it => render-items(
    it,
    s,
    ordered: true,
    spacing: s.before + s.after + lead-of(s),
  )
  block(above: space-above(s), below: space-below(s), body)
}
