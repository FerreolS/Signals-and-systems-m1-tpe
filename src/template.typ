// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
//
#import "@preview/ccicons:1.0.1": *
#import "@preview/octique:0.1.1": octique
#import "@preview/equate:0.3.2": equate



// Macros
#let eg = [_e.g._]
#let ie = [_i.e._]
#let etc = [_etc._]

#let project(
  title: "",
  subtitle: none,
  abstract: none,
  authors: (),
  date: none,
  logo: none,
  license: none,
  firstpage: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(
    margin: (left: 30mm, right: 30mm, top: 30mm, bottom: 30mm),
    numbering: none, // No numbering initially (title page)
    number-align: bottom + right, // Will be overridden contextually later
  )

  // Save heading and body font families in variables.
  let body-font = "New Computer Modern"
  let sans-font = "New Computer Modern Sans"
  //let sans-font = "Gill Sans"

  // Set body font family.
  set text(font: body-font, lang: "en")
  show math.equation: set text(weight: 400)
  show heading: set text(font: sans-font)
  set heading(numbering: "1.1")

  // Set figure numbering to include chapter number
  set figure(numbering: n => numbering("1.1", counter(heading).get().first(), n))
  show figure: set text(8pt)
  show figure.caption: set text(10pt)


  // Equate subnumbering does not work with chapter subnumbering)
  show: equate.with(breakable: false, sub-numbering: false)
  set math.equation(
    numbering: n => numbering("(1.1)", counter(heading).get().first(), n),
    supplement: none,
  )

  show ref: it => {
    // provide custom reference for equations
    if it.element != none and it.element.func() == math.equation {
      // optional: wrap inside link, so whole label is linked
      link(it.target)[Eq.~#it]
    } else {
      it
    }
  }
  // Set run-in subheadings, starting at level 3.
  show heading: it => {
    if it.level > 2 {
      parbreak()
      text(11pt, style: "normal", weight: "black", it.body + ":")
    } else {
      it
    }
  }


  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  v(0.6fr)
  if logo != none {
    align(right, image(logo, width: 26%))
  }
  v(9.6fr)

  text(1.5em, date)
  v(1.2em, weak: true)
  text(font: sans-font, 3em, weight: 700, title)
  // Optional subtitle
  if subtitle != none {
    v(1em, weak: true)
    text(font: sans-font, 2em, weight: 500, subtitle)
  }

  // Author information.
  pad(
    top: 0.7em,
    right: 20%,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(start)[
        *#author.name* \
        #author.email
      ]),
    ),
  )

  v(1.4fr)
  pagebreak()

  // Start Roman numeral numbering for front matter
  set page(
    numbering: "i",
    footer: context {
      let page-num = counter(page).display("i")
      if calc.odd(here().page()) {
        align(right, page-num)
      } else {
        align(left, page-num)
      }
    },
  )
  counter(page).update(1)

  if firstpage != none {
    firstpage
  }

  // License section.
  if license == "cc-by-nc-sa" {
    v(1fr)
    grid(
      columns: (1fr, auto),
      align: (left, right),
      gutter: 1em,
      [#set par(justify: true)
        Unless otherwise noted, this work is licensed under Creative Commons Attribution–NonCommercial–ShareAlike 4.0 International],
      ccicon("cc-by-nc-sa-badge", link: true, scale: 3),
    )
    v(0.5em)
    pagebreak()
  } else if license != none {
    license
    v(0.5em)
    pagebreak()
  }


  if abstract != none {
    // Abstract page.
    v(1fr)
    align(center)[
      #abstract
    ]
    v(1.618fr)
    pagebreak()
  }

  // Table of contents.
  outline(depth: 3)
  pagebreak()

  // Switch to Arabic numbering for main body
  set page(
    numbering: "1",
    margin: (
      // Inner margin: 25mm, Outer margin: 50mm (twice the inner)
      // Odd pages: left is inner, right is outer
      // Even pages: right is inner, left is outer
      inside: 30mm,
      outside: 60mm,
      top: 30mm,
      bottom: 30mm,
    ),
    footer: context {
      let page-num = counter(page).display("1")
      if calc.odd(here().page()) {
        align(right, page-num)
      } else {
        align(left, page-num)
      }
    },
  )
  counter(page).update(1)

  // Main body.
  set par(justify: true)

  body
}

// Margin note function that places notes on outer margin
// (right for odd pages, left for even pages)
// at the same height where it is called
#let margin-note(content) = {
  context {
    let side = if calc.odd(here().page()) { right } else { left }
    place(
      side,
      dx: if side == right { 50mm } else { -50mm },
      dy: -0.5em,
      float: false,
      box(
        width: 45mm,
        // text(size: 8pt, content),
        content,
      ),
    )
  }
}
