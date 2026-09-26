#let body-font = ("Times New Roman", "Tinos", "Liberation Serif")
#let code-font = ("Courier New", "Liberation Mono")

#let indent = 1.25cm
#let marker-width = 0.635cm
#let number-gap = 11pt

// The line box pinned in `conf` is tighter than the glyphs, so text sitting
// against a rule needs this much to clear it.
#let rule-clearance = 1pt
#let table-inset = (
  left: 0.08in,
  right: 0.08in,
  top: rule-clearance,
  bottom: rule-clearance,
)

// Word's "single" spacing is 1.15 of the font size; Typst's `leading` is the
// gap between lines, hence -1.0.
#let line-factor = 1.15
#let extra-lead(mult, size) = (line-factor * mult - 1.0) * size
#let leading-for(mult) = extra-lead(mult, 1em)

#let style-defaults = (
  size: 14pt,
  weight: "regular",
  shape: "normal",
  caps: false,
  align: "left", // "left", "center", "right" or "justify"
  line: 1.5, // line spacing multiplier, as in Word
  before: 0pt,
  after: 0pt,
  left: 0pt,
  first-line: 0pt,
  hanging: 0pt,
  page-break-before: false,
  keep-next: false,
  breakable: true,
)

#let para-style(..fields) = {
  let named = fields.named()
  for key in named.keys() {
    assert(key in style-defaults, message: "unknown style field: " + key)
  }
  style-defaults + named
}

#let heading-style(size, ..extra) = para-style(
  size: size,
  weight: "bold",
  after: 10pt,
  left: indent,
  keep-next: true,
  breakable: false,
  ..extra,
)

#let styles = (
  body: para-style(align: "justify", first-line: indent),
  heading1: heading-style(18pt, caps: true, page-break-before: true),
  heading2: heading-style(16pt, before: 15pt),
  heading3: heading-style(14pt, before: 15pt),
  figure-caption: para-style(
    size: 12pt,
    align: "center",
    line: 1.0,
    after: 6pt,
  ),
  table-caption: para-style(shape: "italic", line: 1.0, before: 0.0835in),
  table-cell: para-style(size: 12pt, line: 1.0),
  listing: para-style(size: 10pt, line: 1.0),
  listing-caption: para-style(shape: "italic", line: 1.0, before: 0.0835in),
  source-entry: para-style(
    align: "justify",
    before: 6pt,
    after: 6pt,
    first-line: marker-width,
    hanging: 1.27cm,
  ),
  toc-entry: para-style(line: 1.0, after: 5pt),
  list-item: para-style(align: "justify", first-line: indent),
)

#let lead-of(s) = extra-lead(s.line, s.size)

// Word states block spacing on top of the line spacing, so both are added.
#let space-above(s) = s.before + lead-of(s)
#let space-below(s, followed-by: styles.body) = s.after + lead-of(followed-by)
#let body-lead = lead-of(styles.body)

#let align-of(s) = (
  left: left,
  center: center,
  right: right,
  justify: left,
).at(s.align)

#let style-text(s, body) = text(
  size: s.size,
  weight: s.weight,
  style: s.shape,
  if s.caps { upper(body) } else { body },
)

#let style-par(s) = body => {
  set par(
    justify: s.align == "justify",
    first-line-indent: (amount: s.first-line, all: true),
    hanging-indent: s.hanging,
    leading: leading-for(s.line),
    spacing: leading-for(s.line),
  )
  body
}

#let styled(s, body, followed-by: styles.body) = block(
  above: space-above(s),
  below: space-below(s, followed-by: followed-by),
  breakable: s.breakable,
  sticky: s.keep-next,
  {
    show: style-par(s)
    pad(left: s.left, std.align(align-of(s), style-text(s, body)))
  },
)
