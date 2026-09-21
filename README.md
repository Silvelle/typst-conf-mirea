# Typst configuration

Reusable report styles are stored in `template/report.typ`.

Import the required functions into a Typst document, for example:

```typst
#import "template/report.typ": conf

#show: conf.with(
  title: "Document title",
  author: "Author",
)
```

The style engine includes formatting for body text, headings, lists, tables,
figures, captions, plain black numbered code listings, contents, sources, and
page numbering. The first page is counted but its number is hidden by default,
as required for a title page.

Requires Typst 0.12 or newer.

## Complete example

[`example-report.typ`](example-report.typ) explains the available settings and
demonstrates headings, lists, tables, code listings, figures, contents, source
lists, and page numbering. Its compiled output is
[`example-report.pdf`](example-report.pdf).

Rebuild the PDF from the project root:

```sh
typst compile example-report.typ example-report.pdf
```
