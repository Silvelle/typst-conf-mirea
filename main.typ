// main.typ — entry point. Assembles STYLE (template/report.typ) + STRUCTURE
// (this include list) + CONTENT (content/*.typ). This is the file to edit
// when the order of chapters changes, or a chapter is added/removed — never
// template/report.typ.

#import "template/report.typ": conf, title-page
#import "config.typ": meta, structure

#show: conf.with(
  title: meta.title,
  author: meta.author,
  supervisor: meta.supervisor,
  city: meta.city,
  year: meta.year,
  // sectPr/titlePg — the cover carries no page number.
  show-page-number-on-first-page: not structure.title-page,
)

#if structure.title-page {
  title-page(
    organization: meta.organization,
    department: meta.department,
    work-type: meta.work-type,
    title: meta.title,
    subtitle: meta.subtitle,
    author: meta.author,
    group: meta.group,
    supervisor: meta.supervisor,
    city: meta.city,
    year: meta.year,
  )
}

// --- Front matter: unnumbered, but paginated ------------------------------
#if structure.contents { include "content/00-contents.typ" }
#if structure.intro { include "content/01-intro.typ" }

// --- Chapters: add, remove or reorder freely ------------------------------
#include "content/02-storage.typ"
#include "content/03-processing.typ"

// --- Back matter ----------------------------------------------------------
#if structure.conclusion { include "content/04-conclusion.typ" }
#if structure.sources { include "content/05-sources.typ" }
