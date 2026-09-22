// Typographic tokens and the named paragraph styles built from them.

// Fallbacks let the document build on machines without the Microsoft fonts.
#let body-font = ("Times New Roman", "Tinos", "Liberation Serif")
#let code-font = ("Courier New", "Liberation Mono")

#let indent = 1.25cm // GOST first-line indent
#let marker-width = 0.635cm // width reserved for a list marker
#let table-inset = (left: 0.08in, right: 0.08in, top: 0in, bottom: 0in)

// Slack between the text area and the page number, mirroring the 0.75 cm
// footer band of the reference document. At 0 a framed listing that fills
// the text area to its edge ends up touching the number.
#let number-gap = 0.3cm

// Word's "single" spacing is 1.15 of the font size, so a 1.5 multiplier
// means 1.15 * 1.5; Typst's `leading` is the gap between lines, hence -1.0.
#let line-factor = 1.15
#let extra-lead(mult, size) = (line-factor * mult - 1.0) * size
#let leading-for(mult) = extra-lead(mult, 1em) // same, relative to font size

// Every named style is this dictionary with a few fields overridden.
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
  first-line: 0pt, // first-line indent
  hanging: 0pt, // indent of every line but the first
  page-break-before: false,
  keep-next: false, // stay on the page with the block that follows
  breakable: true, // may split across pages
)

// Builds one style; the assert turns a mistyped field into a clear error
// instead of a silently ignored setting.
#let para-style(..fields) = {
  let named = fields.named()
  for key in named.keys() {
    assert(key in style-defaults, message: "unknown style field: " + key)
  }
  style-defaults + named
}

// The styles the rest of the package refers to by name.
#let styles = (
  body: para-style(align: "justify", first-line: indent),
  // Level 1 opens a new page and is set in capitals.
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
  // Bibliography entries: number in the first line, the rest indented under it.
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

// The share of the line spacing that falls outside the text itself.
#let lead-of(s) = extra-lead(s.line, s.size)

// Word states block spacing on top of the line spacing, so both are added.
#let space-above(s) = s.before + lead-of(s)
// The gap below belongs to whatever follows, hence `followed-by`.
#let space-below(s, followed-by: styles.body) = s.after + lead-of(followed-by)
#let body-lead = lead-of(styles.body)

// "justify" is a paragraph setting, so it maps to plain left alignment here.
#let align-of(s) = (
  left: left,
  center: center,
  right: right,
  justify: left,
).at(s.align)

// Font side of a style.
#let style-text(s, body) = text(
  size: s.size,
  weight: s.weight,
  style: s.shape,
  if s.caps { upper(body) } else { body },
)

// Paragraph side of a style, shaped to be applied with `show: style-par(s)`.
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

// Both sides at once, wrapped in a block that carries the spacing rules.
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
