// Typographic tokens, named paragraph styles and the helpers that render them.

#let body-font = ("Times New Roman", "Tinos", "Liberation Serif")
#let code-font = ("Courier New", "Liberation Mono")

#let indent = 1.25cm
#let marker-width = 0.635cm
#let table-inset = (left: 0.08in, right: 0.08in, top: 0in, bottom: 0in)

// Distance the page number keeps from the text area. The reference document
// leaves the number similar slack inside its 0.75 cm footer band; without it
// a block that fills the text area to the very edge ends up touching it.
#let number-gap = 0.3cm

// Word calls 1.15 of the font size "single" spacing, so a multiplier of 1.5
// really means 1.15 * 1.5. Typst measures `leading` as the gap between lines,
// hence the font size has to be subtracted from that product.
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
  before: 0pt, // space above the block
  after: 0pt, // space below the block
  left: 0pt, // left padding of the block
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

#let styles = (
  body: para-style(align: "justify", first-line: indent),
  heading1: para-style(
    size: 18pt,
    weight: "bold",
    caps: true,
    after: 10pt,
    left: indent,
    page-break-before: true,
    keep-next: true,
    breakable: false,
  ),
  heading2: para-style(
    size: 16pt,
    weight: "bold",
    before: 15pt,
    after: 10pt,
    left: indent,
    keep-next: true,
    breakable: false,
  ),
  heading3: para-style(
    size: 14pt,
    weight: "bold",
    before: 15pt,
    after: 10pt,
    left: indent,
    keep-next: true,
    breakable: false,
  ),
  figure-caption: para-style(size: 12pt, align: "center", line: 1.0, after: 6pt),
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

// Part of the line spacing that sits above and below the text of a block.
#let lead-of(s) = extra-lead(s.line, s.size)
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

// A block of text laid out with `s`: spacing, padding, alignment and font.
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
