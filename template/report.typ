// ============================================================================
// report.typ — style engine reverse-engineered from Normal.dotm
// ============================================================================
// This is the ONLY file that should change when the visual STYLE of the
// report needs to change. Content (content/*.typ), structure (main.typ's
// include list) and media (assets/*) are all independent of this file.
//
// Requires Typst 0.12+ (uses `context` and the dictionary form of
// `first-line-indent`). Verified on 0.15.
//
// ---------------------------------------------------------------------------
// SOURCES AND WHICH ONE WINS
// ---------------------------------------------------------------------------
// Four files were inspected; they do NOT agree, so precedence is:
//
//   0. дока(1).odt        — LibreOffice's own reading of Реферат_2_2.docx,
//                           added later as a CROSS-CHECK. It resolves the
//                           w:basedOn chains for you and prints the result in
//                           inches, so it is the cheapest way to confirm a
//                           number; it agrees with Normal.dotm everywhere it
//                           was checked (see "MEASURED VALUES" below). It is
//                           not an independent authority — where ODF and OOXML
//                           disagree the .docx wins, because LibreOffice
//                           re-models some things (notably page margins: see
//                           "PAGE" below).
//
//   1. Normal.dotm        — the authority. Holds the named styles the
//                           assignments are actually written with
//                           ("текст", "1/2/3 Заголовок", "картинки",
//                           "подп.табл.", "текст.табл", "Источники").
//   2. Реферат_2_2.docx   — the authority for USAGE: it is the only file
//                           that actually contains figures and tables, so
//                           caption wording/placement comes from here. Its
//                           style definitions are byte-for-byte equivalent
//                           to Normal.dotm (different internal styleIds:
//                           текст=a3, 1 Заголовок=11, картинки=a5,
//                           подп.табл.=a7, текст.табл=a9, Источники=ac).
//   3. Template.docx      — OLDER, different lineage. Used ONLY for the list
//                           numbering definitions (it is the only file with a
//                           clean, hand-made numbering.xml). Its page margins
//                           and its "Таблицы"/"Подпись рисунков"/"Внутри
//                           таблицы"/"Картинки" styles are DIFFERENT from
//                           Normal.dotm and are deliberately NOT used here.
//
// Deltas worth knowing — these are the places where following Template.docx
// instead of Normal.dotm silently produces the wrong document:
//   margins        2/1/2/2.5 cm          ->  2/1.5/2/3 cm  (ГОСТ)
//   page number    header, centered      ->  footer, centered (Реферат)
//   table caption  12pt italic, centered ->  14pt italic, LEFT, indent 0
//   fig. caption   "Картинки" 12pt       ->  "картинки" 12pt centered (same)
//   cell padding   n/a                   ->  0.19 cm sides, 0 top/bottom
//
// ---------------------------------------------------------------------------
// MEASURED VALUES — the Paragraph dialog, style by style
// ---------------------------------------------------------------------------
// Taken from word/styles.xml, word/numbering.xml and word/document.xml inside
// the .docx/.dotm packages, NOT from the Styles pane: the XML is the same data
// the dialog displays, minus its rounding to 0.01 cm / 0.05 pt. Conversions:
//   567 twips = 1 cm    20 twips = 1 pt    w:sz = half-points
//   w:line / 240 = the "Multiple" factor   (360 = 1.5 lines, 240 = single)
//
// Every value below is the RESOLVED one — w:basedOn chains already flattened,
// which is what the dialog shows you and what a bare reading of one <w:style>
// block does not.
//
//                        Align    Left    Right  Special         Before After  Line
//  текст          (ad)   Justify  0       0      First line 1.25   0 pt   0 pt  1.5
//  1 Заголовок    (11)   Left     1.25cm  0      —                 0 pt  10 pt  1.5
//  2 Заголовок    (21)   Left     1.25cm  0      —                15 pt  10 pt  1.5
//  3 Заголовок    (31)   Left     1.25cm  0      —                15 pt  10 pt  1.5
//  Источники      (a7)   Center   1.25cm  0      —                 6 pt   6 pt  1.5
//  картинки       (a9)   Center   0       0      —                 0 pt   6 pt  single
//  подп.табл.     (ab)   Left     0       0      —                 6 pt   0 pt  single
//  текст.табл     (af)   Left     0       0      —                 0 pt   0 pt  single
//  toc 1/2        (13/23) Justify 0       0      —                 0 pt   5 pt  single
//  toc 3          (33)   Left     0       0      —                 0 pt   5 pt  single
//
// Right indent is 0 everywhere. The only <w:ind w:right> in any of the three
// packages belongs to "Intense Quote", a stock Word style the documents never
// apply — so nothing in this file sets a right indent either.
//
// 1 Заголовок additionally carries w:pageBreakBefore, and it plus Источники
// carry w:widowControl="0"; all four heading/caption styles carry w:keepNext
// except "картинки", which explicitly switches it back off (w:keepNext="0").
//
// CHARACTER FORMATTING (all Times New Roman; w:sz is half-points)
//  текст 14pt · 1 Заголовок 18pt bold ALL-CAPS (w:caps) · 2 Заголовок 16pt bold
//  3 Заголовок 14pt bold · Источники 14pt NOT bold · картинки 12pt
//  подп.табл. 14pt ITALIC · текст.табл 12pt · toc 1-3 14pt
//
// LIST NUMBERING — numPr REPLACES the style's own indent when applied, so
// these are the positions that actually take effect. The dialog reports a
// hanging indent as Left/By; the marker lands at Left - By:
//
//                                      Left     Hanging   -> marker at
//  bullet      numId 14 / absNum 7     2.52 cm  0.63 cm      1.89 cm
//              lvl0 char F02D in Symbol = EN DASH "–", not a round bullet
//  numbered    numId 11 / absNum 4     1.89 cm  0.63 cm      1.25 cm
//              lvl0 "%1."
//  sources     numId 30 / absNum 11    1.27 cm  0.63 cm      0.63 cm
//              lvl0 "%1." + a w:jc="both" override on every entry
//
// Only level 0 is ever used in the body text; multi-level numbering appears on
// HEADINGS only, where Normal.dotm and Реферат type the number into the
// heading text rather than attaching numPr (Template.docx does attach it).
//
// PAGE (sectPr)
// Реферат_2_2.docx has FOUR sections; only the last one is the report proper.
// The first three are the cover and two full-bleed image pages, and their
// margins (720 tw all round, then 120/0/280/0, then 460/0/0/0) describe those
// images, not the document — reading the FIRST sectPr instead of the last is
// the easy mistake here.
//
//  section 4 — the body, the only one this template reproduces:
//  pgSz  11906 x 16838 tw = A4 (210 x 297 mm)
//  pgMar top 1134 / right 850 / bottom 1134 / left 1701 tw
//        = 2 / 1.5 / 2 / 3 cm   -> text width 16.5 cm
//        w:header = w:footer = 708 tw (1.25 cm from the PAGE edge)
//  footer1.xml  centered PAGE field; w:titlePg = no number on the first page
//
// дока(1).odt's page-layout PL3 looks like it contradicts this — it says
// fo:margin-top / fo:margin-bottom = 0.4916in = 708 tw. It does not: ODF puts
// the header/footer OUTSIDE the page margin, so LibreOffice wrote w:header
// into fo:margin-top and parked the remainder in style:header-style's
// fo:min-height = 0.2958in = 426 tw. 708 + 426 = 1134 tw = 2 cm, which is what
// `set page` below uses. Typst measures like Word, not like ODF, hence
// header-ascent / footer-descent = 2 cm - 1.25 cm = 0.75 cm.
//
// TABLE ("Table Grid" + "Normal Table")
//  tblBorders  all six single, w:sz="4" eighth-points = 0.5 pt
//  tblCellMar  top 0 · left 108 tw (0.19 cm) · bottom 0 · right 108 tw
//  tblInd      0 · no w:jc, i.e. flush to the left text edge
// ============================================================================

#let body-font = ("Times New Roman", "Tinos", "Liberation Serif")

// --- Line-height helper -----------------------------------------------------
// Word's "single" line for Times New Roman is (hhea ascent + descent +
// lineGap) / upem = (1825 + 443 + 87) / 2048 = 1.15em. "Multiple 1.5"
// (w:line="360") is therefore 1.725em.
//
// Typst measures leading between the text EDGES, which vary per font — so we
// pin the edges to a flat 1em span and derive the leading from that. This
// makes the result identical whether the renderer finds real Times New Roman,
// Tinos or Liberation Serif.
#let word-single-factor = 1.15
#let word-single = word-single-factor * 1em
#let leading-for(mult) = word-single * mult - 1em // 1.5x -> 0.725em, 1.0x -> 0.15em

// --- Word's paragraph gap, and why `below` is never just w:after ------------
// дока(1).odt (LibreOffice's own reading of the same document, so the numbers
// below are ODF's, in inches) makes the rule explicit:
//
//   текст          line-height 150%   margin-bottom 0
//   1 Заголовок    margin-bottom 0.1388in = 10pt   (break-before page)
//   2 Заголовок    margin-top 0.2083in = 15pt · margin-bottom 0.1388in = 10pt
//   3 Заголовок    inherits 2 Заголовок
//
// Word's "Multiple 1.5" makes EVERY line box 1.725x tall and hangs the extra
// 0.725em ABOVE the line — including the first line of a paragraph. Typst
// applies `leading` only BETWEEN lines, so a block boundary loses that extra.
// The visible gap in Word is therefore
//
//   A.after + B.before + 0.725 * (B's font size)
//
// and the last term is what was missing: a 10pt w:after under an 18pt heading
// renders as 10 + 0.725*14 = 20.15pt of daylight before the body text, not
// 10pt. (style:contextual-spacing is "false" in the default style, so Word
// really does ADD before to after instead of collapsing them.)
//
// Typst resolves block spacing as max(A.below, B.above), so the sum is encoded
// by pushing the whole thing onto one side: every block's `below` carries
// w:after PLUS the extra leading of the "текст" paragraph that follows it, and
// its `above` carries w:before PLUS its own extra leading.
#let extra-lead(mult, size) = (word-single-factor * mult - 1.0) * size
#let body-size = 14pt
// The gap a "текст" paragraph opens above itself: 0.725 * 14pt = 10.15pt.
#let body-lead = extra-lead(1.5, body-size)

// --- Measured constants (exported so content/ never hard-codes a number) -----
#let indent = 1.25cm // 709 tw — first line of "текст", left edge of headings
#let text-width = 16.5cm // A4 minus the 3 cm / 1.5 cm side margins

// ---------------------------------------------------------------------------
// Document setup. Wrap the whole document with:
//   #show: conf.with(...)
// ---------------------------------------------------------------------------
#let conf(
  title: "",
  author: none,
  supervisor: none,
  city: none,
  year: none,
  // Реферат_2_2.docx puts the page number in a centered FOOTER (footer1.xml)
  // and Template.docx in a centered HEADER (header1.xml). Normal.dotm's
  // sectPr references neither, so the newer Реферат wins as the default.
  page-number-position: "footer", // "footer" | "header" | "none"
  // sectPr/titlePg — first page carries no number when a title page is used.
  show-page-number-on-first-page: true,
  doc,
) = {
  set document(title: title, author: if author != none { author } else { "" })

  // ---- Page: A4, margins from sectPr/pgMar (2 / 1.5 / 2 / 3 cm) ----
  let page-number = context {
    let n = counter(page).get().first()
    if n == 1 and not show-page-number-on-first-page {
      []
    } else {
      // 11pt, as Реферат_2_2.docx renders it: its "footer" style is the stock
      // one, never customised, so it falls through to docDefaults (11pt).
      // Only the family is ours — docDefaults says Calibri, which would be
      // the one sans-serif glyph in an otherwise Times New Roman document.
      align(center, text(font: body-font, size: 11pt, str(n)))
    }
  }

  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1.5cm),
    // sectPr/pgMar w:header="708" / w:footer="708" tw = 1.25 cm, measured
    // from the PAGE edge. Typst measures from the body edge, so the value is
    // the 2 cm margin minus that 1.25 cm.
    header-ascent: 0.75cm,
    footer-descent: 0.75cm,
    header: if page-number-position == "header" { page-number } else { none },
    footer: if page-number-position == "footer" { page-number } else { none },
  )

  // ---- Base text: style "текст" ----
  set text(
    font: body-font,
    size: 14pt,
    lang: "ru",
    region: "ru",
    // Pin the line box so `leading-for` is exact regardless of the font found.
    top-edge: 0.8em,
    bottom-edge: -0.2em,
  )
  set par(
    justify: true,
    first-line-indent: (amount: indent, all: true),
    leading: leading-for(1.5), // w:line="360" lineRule="auto"
    spacing: leading-for(1.5), // "текст" has w:after="0" — no extra gap
  )

  // ---- Headings: styles "1/2/3 Заголовок" ----
  // The number is inline (Normal.dotm/Реферат have no numPr on the headings),
  // the whole paragraph is flushed to ind left = 1.25 cm.
  set heading(numbering: "1.1.1")

  show heading: it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering) + h(0.4em)
    } else {
      []
    }
    // Headings keep the 1.5x line but drop justification and first-line indent.
    set par(first-line-indent: 0pt, justify: false, leading: leading-for(1.5))

    let head(size, above, below, body) = block(
      above: above,
      below: below,
      breakable: false,
      pad(left: indent, text(size: size, weight: "bold", body)),
    )

    // above = w:before + the heading's OWN extra 1.5x leading
    // below = w:after  + the extra 1.5x leading of the "текст" that follows
    if it.level == 1 {
      pagebreak(weak: true) // w:pageBreakBefore
      // w:caps. Nothing precedes it on a fresh page, so `above` is moot.
      head(18pt, 0pt, 10pt + body-lead, upper(number + it.body))
    } else if it.level == 2 {
      head(16pt, 15pt + extra-lead(1.5, 16pt), 10pt + body-lead, number + it.body)
    } else {
      head(14pt, 15pt + extra-lead(1.5, 14pt), 10pt + body-lead, number + it.body)
    }
  }

  // Figures and tables are numbered per chapter (Рисунок 1.1, Таблица 2.3),
  // so both counters restart at every level-1 heading.
  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    it
  }

  // ---- Lists ---------------------------------------------------------
  // The numbering definitions (abstractNumId 7 bullet / 4 decimal) describe a
  // HANGING indent: marker at 1069 tw, every line of the text at 1429 tw.
  // Реферат_2_2.docx does not use it. Its body lists carry a direct
  //
  //     <w:ind w:left="0" w:firstLine="1069"/>
  //
  // which cancels the hang: the marker sits 1069 tw (1.885 cm) in on the FIRST
  // line only, and every continuation line returns to the left text edge. Of
  // the 52 list paragraphs in that file, 18 carry exactly this override, 18
  // carry none, and the rest are hand-dragged variants of the same shape
  // (firstLine 1072 / 1133 / 1134). Confirmed against the rendered PDF:
  // markers at 1.89 cm, continuation lines at 0.00 cm.
  //
  // So the indent here is a FIRST-LINE indent, not a hanging one, and an item
  // has to be built as an ordinary paragraph — Typst's list/enum always hang.
  // The list of sources is the exception; `sources-list` overrides this rule
  // locally and keeps the genuine hanging indent.
  let flat-item(marker, body) = par(
    first-line-indent: (amount: 1.885cm, all: true), // w:firstLine="1069"
    // The marker is boxed to the 360 tw the numbering reserves for it, so the
    // first line's text starts at 1429 tw whatever the marker's own width.
    // align(left) is required: Typst right-aligns a marker inside its box.
    box(width: 0.635cm, std.align(left, marker)) + body,
  )

  show list: it => {
    set par(justify: true, leading: leading-for(1.5), spacing: leading-for(1.5))
    for child in it.children {
      flat-item([–], child.body) // F02D in Symbol is an en dash
    }
  }
  show enum: it => {
    set par(justify: true, leading: leading-for(1.5), spacing: leading-for(1.5))
    let n = 0
    for child in it.children {
      n = if type(child.number) == int { child.number } else { n + 1 }
      flat-item(numbering("1.", n), child.body) // "%1." — absNum 4 lvl0
    }
  }

  // ---- Tables: "Table Grid" borders + "Normal Table" cell margins ----
  set table(
    stroke: 0.5pt + black, // w:sz="4" eighth-points = 0.5pt
    inset: (left: 0.19cm, right: 0.19cm, top: 0pt, bottom: 0pt), // tblCellMar
  )
  // Cell paragraphs are "текст.табл": 12pt, left, no indent, line 1.0x.
  show table: set text(size: 12pt)
  show table: set par(
    leading: leading-for(1.0),
    spacing: leading-for(1.0),
    first-line-indent: 0pt,
    justify: false,
  )

  // ---- Captions: "Рисунок 1.1 Подпись" — a space, never a colon ----
  set figure.caption(separator: [ ])

  // Figure block, style "картинки": picture and caption are two centered
  // paragraphs, 12pt, line 1.0x, 6pt between them (w:after on the picture).
  // w:before on the picture paragraph is 0 and the preceding "текст" has
  // w:after=0, so there is genuinely NO space above a picture in Word.
  // Picture -> caption: 6pt w:after on the picture + the caption's own extra
  // leading (12pt at line 1.0x). Below the caption: its 6pt w:after + the
  // 10.15pt the next "текст" paragraph hangs above itself.
  show figure.where(kind: image): set figure(gap: 6pt + extra-lead(1.0, 12pt))
  show figure.where(kind: image): set block(above: 0pt, below: 6pt + body-lead)
  show figure.where(kind: image): it => {
    set text(size: 12pt)
    set par(
      leading: leading-for(1.0),
      spacing: leading-for(1.0),
      first-line-indent: 0pt,
      justify: false,
    )
    it
  }

  // Table block: the "подп.табл." caption sits above with w:before=120 tw
  // (6pt) and w:after=0, so gap = 0 and the block's space below is 0 too.
  //
  // Re-verified directly against word/styles.xml's style chain (the more
  // concrete source than either the Paragraph dialog or дока(1).odt, which
  // both only ever show the flattened RESULT, not which style in the chain
  // set it): a5 картинки (before=0 after=120) -> a7 подп.табл. (before=120
  // after=0, i.e. overrides both) -> a9 текст.табл (before=0, after
  // NOT overridden -> inherits a7's after=0). Table style "ab"/Table Grid
  // itself also carries spacing after=0 line=240 in its own pPr. Checked all
  // 119 текст.табл paragraphs in both document.xml (direct <w:spacing>) and
  // дока(1).odt's automatic styles for a per-cell override of that 0 — none
  // of the 119 carries one, in either file. So a cell paragraph's own
  // after-spacing is genuinely 0, not ~0.11in — that reading, if taken from
  // a Paragraph dialog, is most likely LibreOffice showing the RENDERED gap
  // (0.15 x 12pt = 1.8pt from the single-line metric hang, plus whatever the
  // dialog's own rounding/units did to it) rather than a settable property.
  show figure.where(kind: table): set figure(gap: 0pt)
  // The "подп.табл." paragraph is written BEFORE the <w:tbl> in document.xml.
  show figure.where(kind: table): set figure.caption(position: top)
  // tblPr carries no <w:jc>, i.e. Word's default: the table starts at the
  // left text edge rather than being centred in the column.
  show figure.where(kind: table): set std.align(left)
  // above = 6pt w:before on "подп.табл." + its own extra leading (14pt, 1.0x);
  // below = 0pt w:after on the table + the next "текст" paragraph's extra.
  show figure.where(kind: table): set block(
    above: 6pt + extra-lead(1.0, 14pt),
    below: body-lead,
  )
  show figure.where(kind: table): it => {
    // "подп.табл.": 14pt italic, LEFT-aligned, no indent, single-spaced.
    show figure.caption: c => block(
      width: 100%,
      std.align(left, text(size: 14pt, style: "italic", weight: "regular", c)),
    )
    set par(leading: leading-for(1.0), first-line-indent: 0pt, justify: false)
    it
  }

  doc
}

// ===========================================================================
// MINI TEMPLATE — PICTURES  (style "картинки")
// ===========================================================================
// Word layout, reproduced exactly:
//
//     ┌ paragraph 1, style "картинки" ──────────┐
//     │              <the image>                │  centered, ind left = 0
//     └─────────────────────────────────────────┘  w:after = 120 tw = 6pt
//                       ↕ 6 pt
//     ┌ paragraph 2, style "картинки" ──────────┐
//     │     Рисунок 1.1 Схема работы …          │  centered, TNR 12pt,
//     └─────────────────────────────────────────┘  line 1.0x, w:after = 6pt
//
// Caption text is "Рисунок <глава>.<N> <текст>" — no colon, no trailing dot.
// Numbering restarts in every chapter (handled by the show rule in `conf`).
//
//   #figure-image("../assets/figures/scheme.png", caption: [Схема работы])
//   #figure-image("...", caption: [...], width: 12cm)   // explicit size
//
// `width: auto` keeps the picture at its natural size, capped at the 16.5 cm
// text width — that is what Word does with an inline image.
// ---------------------------------------------------------------------------
#let figure-image(src, caption: none, width: auto, alt: none) = figure(
  image(src, width: width, alt: alt),
  caption: caption,
  kind: image,
  supplement: [Рисунок],
  // "<глава>.<N>" — the chapter number comes from the heading counter, which
  // `conf` resets at every level-1 heading.
  numbering: n => context numbering("1.1", counter(heading).get().first(), n),
)

// Same picture block, but the source directory is explicit at the call site so
// screenshots and drawn diagrams stay physically separated under assets/.
#let screenshot(src, caption: none, width: auto) = figure-image(
  src,
  caption: caption,
  width: width,
)
#let diagram(src, caption: none, width: auto) = figure-image(
  src,
  caption: caption,
  width: width,
)

// ===========================================================================
// MINI TEMPLATE — TABLES  (styles "подп.табл." + "текст.табл")
// ===========================================================================
// Word layout, reproduced exactly:
//
//     ┌ paragraph, style "подп.табл." ──────────┐  w:before = 120 tw = 6pt
//     │ Таблица 1.1 Сравнение подходов          │  LEFT, TNR 14pt ITALIC,
//     └─────────────────────────────────────────┘  ind left = 0, w:after = 0
//     ┌ table, style "Table Grid" ──────────────┐
//     │ Заголовок │ Заголовок │ Заголовок       │  bold + centered (direct
//     ├───────────┼───────────┼─────────────────┤  formatting on row 1)
//     │ ячейка    │ ячейка    │ ячейка          │  "текст.табл": 12pt, left,
//     └───────────┴───────────┴─────────────────┘  line 1.0x, spacing 0
//
// Borders 0.5pt everywhere including inside; cell padding 0.19 cm left/right
// and 0 top/bottom (tblCellMar). Caption sits ABOVE the table, numbered per
// chapter: "Таблица <глава>.<N> <текст>".
//
//   #figure-table(
//     columns: (2cm, 1fr, 1fr),
//     caption: [Сравнение подходов],
//     header: ([№], [Подход], [Результат]),
//     ([1], [Первый],  [Хорошо]),
//     ([2], [Второй],  [Лучше]),
//   )
//
// `header:` is optional — omit it for a table with no header row.
// `columns:` accepts anything `table` accepts: a count, or a width array
// (`auto` = fit content, like Word's tblW type="auto"; `1fr` = share the
// remaining width, like tblLayout="fixed").
// ---------------------------------------------------------------------------
#let figure-table(
  columns: auto,
  caption: none,
  header: none,
  align: left,
  ..rows,
) = {
  let cell-align = align
  figure(
    table(
      columns: columns,
      align: cell-align,
      // Header row = "текст.табл" + direct <w:b/> and jc=center.
      ..if header != none {
        (table.header(..header.map(c => std.align(center, strong(c)))),)
      } else { () },
      ..rows.pos().flatten(),
    ),
    caption: caption,
    kind: table,
    supplement: [Таблица],
    numbering: n => context numbering("1.1", counter(heading).get().first(), n),
  )
}

// ===========================================================================
// UNNUMBERED SECTIONS — "Содержание", "Введение", "Заключение", …
// ===========================================================================
// In Реферат_2_2.docx these are ordinary "1 Заголовок" paragraphs that simply
// carry no number, so they start a new page and are set in 18pt bold ALL CAPS
// like any chapter. Because they are unnumbered, Typst does NOT advance the
// heading counter — "Введение" does not steal the number 1 from chapter 1.
//
//   #section[Введение]
// ---------------------------------------------------------------------------
#let section(body, outlined: true) = heading(
  level: 1,
  numbering: none,
  outlined: outlined,
  body,
)

// ===========================================================================
// MINI TEMPLATE — CONTENTS  (styles "toc 1" / "toc 2" / "toc 3")
// ===========================================================================
// Word source: a TOC field, `TOC \h \z \t "1 Заголовок;1;2 Заголовок;2;3
// Заголовок;3"`, i.e. three levels taken from the three heading styles.
//
//   "toc 1/2/3"  basedOn "текст" -> TNR 14pt, but with w:ind firstLine="0"
//                and the line overridden to 240 (1.0x) on every paragraph
//                w:after="100" tw = 5pt between entries
//                right tab at 9345 tw (16.48 cm = the text width) with
//                w:leader="dot"  -> dotted leader out to the right margin
//
// Re-checked directly against word/styles.xml: "toc 1"/"toc 2"/"toc 3" (13/23/
// 33) carry NO <w:ind w:left> at any level — only vestigial tab stops at
// 880/993/1320 tw that a manually-numbered heading never reaches — and no
// document.xml TOC-field paragraph overrides one in either. So Word renders
// EVERY level flush left, level 1 and 2 (and 3) all sharing the same left
// edge. `level-indent` therefore defaults to (0cm, 0cm, 0cm) — pass your own
// tuple here if you want a ladder instead of the literal flush-left match.
// ---------------------------------------------------------------------------
#let contents(title: [Содержание], depth: 3, level-indent: (0cm, 0cm, 0cm)) = {
  // `outlined: false` keeps "Содержание" from listing itself. Реферат_2_2.docx
  // does list it (its TOC field has no \n switch) — pass `outlined: true`
  // here to reproduce that.
  section(title, outlined: false)

  show outline.entry: it => {
    set par(
      // "toc 1"/"toc 2" inherit Justify from "текст" ("toc 3" sets Left), but
      // justification is inert on an entry whose line is filled by the dot
      // leader — the fill absorbs every bit of slack there would be.
      first-line-indent: 0pt,
      justify: false,
      leading: leading-for(1.0),
      spacing: leading-for(1.0),
    )
    set text(size: 14pt)
    // pad() only moves the left edge; the page number stays on the right
    // margin, which is what the right-aligned dot-leader tab stop does.
    block(
      above: 0pt,
      // w:after="100" tw = 5pt, plus the next entry's own extra leading
      // (14pt at the line 1.0x every TOC paragraph overrides to).
      below: 5pt + extra-lead(1.0, 14pt),
      pad(left: level-indent.at(it.level - 1, default: level-indent.last()), it),
    )
  }
  // repeat[.] is the w:leader="dot" of the tab stop.
  set outline.entry(fill: repeat[.])

  // `outline()`'s own `indent` defaults to an auto per-level ladder — a SEPARATE
  // mechanism from the `pad()` above, and it stacked with it (both were adding
  // indent at once). Zero it here so `level-indent` is the only knob left.
  outline(title: none, depth: depth, indent: 0pt)
}

// ===========================================================================
// MINI TEMPLATE — LIST OF SOURCES  (style "Источники")
// ===========================================================================
// Careful: "Источники" is NOT the heading of the bibliography. In
// Реферат_2_2.docx the heading is a plain unnumbered "1 Заголовок"
// ("Список используемых источников") and the "Источники" style is applied to
// the ENTRIES, every one of them carrying numId 30 and a jc="both" override:
//
//   "Источники" (a7)  TNR 14pt, before/after 120 tw (6pt), line 360 (1.5x),
//                     w:jc="both" in use -> justified
//   numId 30 (abstractNumId 11) lvl0  decimal "%1."
//                     ind left=720 hanging=360
//                     -> marker 360 tw (0.63 cm), text 720 tw (1.27 cm)
//
// Note those are NOT the body-text list positions (1.25 / 1.89 cm) — the
// bibliography sits noticeably further left.
//
//   #section[Список использованных источников]
//   #sources-list[
//     + Иванов, И. И. Название книги. — М. : Издательство, 2024. — 320 с.
//     + ГОСТ Р 7.0.100–2018. Библиографическая запись.
//   ]
// ---------------------------------------------------------------------------
#let sources-list(body) = {
  // Overrides the flat list rule from `conf` for this block only: the 34
  // entries in Реферат carry NO w:ind override, so numId 30's hanging indent
  // stands. Verified against the rendered PDF — numbers at 0.64 cm, entry text
  // at 1.27 cm on the first AND on every continuation line.
  show enum: it => {
    set par(
      justify: true, // the w:jc="both" override on every entry
      leading: leading-for(1.5),
      // Before=6pt AND After=6pt: style:contextual-spacing is "false", so Word
      // adds them rather than collapsing the pair — 12pt, plus the entry's own
      // extra 1.5x leading at 14pt.
      spacing: 12pt + extra-lead(1.5, 14pt),
    )
    let n = 0
    for child in it.children {
      n = if type(child.number) == int { child.number } else { n + 1 }
      par(
        first-line-indent: (amount: 0.635cm, all: true), // 360 tw
        hanging-indent: 1.27cm, // 720 tw — lines 2+ of the entry
        box(width: 0.635cm, std.align(left, numbering("1.", n))) + child.body,
      )
    }
  }
  block(above: 6pt + extra-lead(1.5, 14pt), below: 6pt + body-lead, body)
}

// ---------------------------------------------------------------------------
// Optional title page. No Word source: neither Normal.dotm nor Template.docx
// defines one, and Реферат_2_2.docx builds its cover from raster images.
// Included as a plain, ready-to-use component — it invents no new style rules
// beyond the document's own font and sizes.
// ---------------------------------------------------------------------------
#let title-page(
  organization: none,
  department: none,
  work-type: "ОТЧЁТ",
  title: "",
  subtitle: none,
  author: none,
  group: none,
  supervisor: none,
  city: none,
  year: none,
) = {
  set par(first-line-indent: 0pt, justify: false, leading: leading-for(1.0))

  std.align(center, {
    if organization != none {
      text(size: 14pt, organization)
      linebreak()
    }
    if department != none {
      text(size: 14pt, department)
    }
  })

  v(1fr)

  std.align(center, {
    text(size: 16pt, weight: "bold", work-type)
    linebreak()
    v(0.5cm)
    text(size: 18pt, weight: "bold", title)
    if subtitle != none {
      linebreak()
      v(0.3cm)
      text(size: 14pt, subtitle)
    }
  })

  v(1fr)

  // Right-hand credits block: the block is right-aligned on the page, the
  // lines inside it are left-aligned, so "Выполнил"/"Руководитель" line up.
  std.align(right, block(width: 55%, std.align(left, {
    if author != none {
      par("Выполнил: " + author)
      if group != none { par("Группа " + group) }
      v(0.3cm)
    }
    if supervisor != none {
      par("Руководитель: " + supervisor)
    }
  })))

  v(1fr)

  std.align(center, {
    if city != none { text(city) }
    if city != none and year != none { h(1cm) }
    if year != none { text(year) }
  })

  pagebreak(weak: true)
}
