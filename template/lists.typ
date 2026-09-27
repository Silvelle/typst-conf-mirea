#import "styles.typ": (
  indent, lead-of, leading-for, marker-width, space-above, space-below,
  style-par, styles,
)

#let marked-par(marker, body) = par(
  box(width: marker-width, std.align(left, marker)) + body,
)

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

#let render-items(it, s, ordered: false, spacing: auto) = {
  show: style-par(s)
  set par(spacing: if spacing == auto { leading-for(s.line) } else { spacing })

  let n = 0
  for child in it.children {
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
