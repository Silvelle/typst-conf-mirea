// config.typ — document metadata & structure toggles.
//
// Edit THIS file (and the include list in main.typ) to change WHAT the
// report contains for a given assignment — title, author, whether a teacher
// wants a "Содержание" or a "Заключение" this time, etc. None of this touches
// template/report.typ, so the visual style never drifts between assignments.

#let meta = (
  organization: "Название учебного заведения",
  department: "Кафедра информационных систем",
  work-type: "РЕФЕРАТ",
  title: "Хранение и обработка больших объёмов данных",
  subtitle: none,
  author: "Фамилия Имя Отчество",
  group: "ИС-21",
  supervisor: "Фамилия И. О.",
  city: "Москва",
  year: "2026",
)

// Toggle optional sections here. main.typ reads these to decide which files
// from content/ to include and in what order.
#let structure = (
  title-page: true,
  contents: true,
  intro: true,
  conclusion: true,
  sources: true,
)
