// Bullet and numbered lists, plus the reference list at the end of a report.

#import "styles.typ": (
  indent, lead-of, leading-for, marker-width, space-above, space-below,
  style-par, styles,
)

// One item: the marker in a fixed-width box, then the text. A plain
// paragraph, so wrapped lines return to the left margin as GOST expects.
#let marked-par(marker, body) = par(
  box(width: marker-width, std.align(left, marker)) + body,
)

// Typst folds a nested list into the body of the item above it, so an item
// arrives as inline content plus bare `list.item` / `enum.item` elements.
// Left there they land inside `marked-par`'s `par`, which cannot hold
// blocks — Typst then drops them without a word.
// Returns (inline content, nested items).
#let split-nested(body) = {
  if body.func() == [].func() {
    // A sequence: inline parts first, nested items after them.
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
    ([], (body,)) // item with no text of its own
  } else {
    (body, ()) // ordinary item, nothing nested
  }
}

// Flat marked paragraphs, one per child, with nested levels indented.
// `spacing` is the gap between entries; `auto` keeps the line spacing of `s`.
#let render-items(it, s, ordered: false, spacing: auto) = {
  show: style-par(s)
  set par(spacing: if spacing == auto { leading-for(s.line) } else { spacing })

  let n = 0
  for child in it.children {
    // Honour an explicit `7.`; items rebuilt from a nested level carry no
    // resolved number, so `at` with a default rather than `child.number`.
    n = if type(child.at("number", default: none)) == int {
      child.number
    } else {
      n + 1
    }

    let (inline, nested) = split-nested(child.body)
    marked-par(if ordered { numbering("1.", n) } else { [–] }, inline)

    // Re-wrapping makes the show rule recurse, so deeper levels get the
    // same treatment one indent further in.
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

// Hanging indent and wider spacing for entries. Deliberately imposes no
// bibliographic standard — the wording of each entry is the author's.
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
