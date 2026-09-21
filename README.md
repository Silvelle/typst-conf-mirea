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
figures, captions, contents, sources, and page numbering. The first page is
counted but its number is hidden by default, as required for a title page.

Requires Typst 0.12 or newer.
