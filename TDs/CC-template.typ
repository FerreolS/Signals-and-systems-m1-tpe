// Exam Template for Typst
// Customize the parameters below to create your exam


#let VV(x) = { $bold(#x)$ }
#let MM(x) = { $bold(#x)$ }

#let Vx = VV([x])
#let Vy = VV([y])
#let MH = MM([H])
#let Id = MM([I])
#let diag = $op("diag")$

#let inner(a, b) = $lr(chevron.l #a, #b chevron.r)$
#let conj(a) = $overline(#a)$
#let dt = $dif t$
// Macros
#let eg = [_e.g._]
#let ie = [_i.e._]
#let etc = [_etc._]


#let dt = $dif t$
#let FT = $cal(F)$
#let comb = $\u{0428}$ //0448

#let exam(
  title: "Final Examination",
  course: "Course Name",
  parcours: "M1 Sciences de la terre et des planètes, environnement",
  date: datetime.today().display("[day] [month repr:long] [year]"),
  duration: "30 minutes",
  instructions: none,
  student-info: true,
  show-solutions: false,
  body,
) = {
  // Page setup
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    header: context {
      if counter(page).get().first() > 1 [
        #set text(9pt)
        #grid(
          columns: (1fr, 1fr),
          align: (left, right),
          [#course], [Page #counter(page).display()],
        )
        #line(length: 100%, stroke: 0.5pt)
      ]
    },
    footer: context {
      if counter(page).get().first() > 1 [
        #line(length: 100%, stroke: 0.5pt)
        #set text(8pt)
        #align(center)[#title]
      ]
    },
  )

  // Document settings
  set text(font: "New Computer Modern", size: 11pt)
  set par(justify: true, leading: 0.85em, spacing: 1em)
  set heading(numbering: "1.")

  // Store show-solutions state
  state("show-solutions").update(show-solutions)
  // Student information section
  if student-info != none [
    #block(
      width: 100%,
      inset: 0.8em,
      stroke: 0.5pt,
      [
        #grid(
          columns: auto,
          row-gutter: 0.8em,
          column-gutter: 1em,
          [*Name:*],
          //, line(length: 100%, stroke: (dash: "dotted")),
          //          [*Student ID:*], line(length: 100%, stroke: (dash: "dotted")),
        )
      ],
    )
    #v(1em)
  ]

  align(left)[
    #grid(
      columns: (1fr, auto),
      gutter: 1em,
      [#parcours], [#date],
    )
  ]
  // Title block
  align(center)[
    #block(
      width: 100%,
      inset: 0em,
      stroke: 0pt,
      [
        #line(length: 100%, stroke: 1pt)
        #v(0.5em)
        #text(size: 18pt, weight: "bold")[#title] \
        #v(0.3em)
        #text(size: 18pt)[#course] \
        #v(0.3em)
        #if duration != none { text(size: 11pt)[*Duration:*  #duration] }
      ],
    )
  ]

  v(1em)


  // Instructions section
  if instructions != none [
    #block(
      width: 100%,
      inset: 0.8em,
      fill: rgb("#f5f5f5"),
      stroke: 0pt,
      [
        #text(weight: "bold", size: 12pt)[Instructions] \
        #v(0.5em)
        #set enum(numbering: "1.")
        #for instruction in instructions [
          - #instruction
        ]
      ],
    )
    #v(1.5em)
  ]

  // Main content
  body
}

// Question counter and formatting
#let question(points: none, body) = {
  counter("question").step()
  counter("subquestion").update(0)
  block(
    width: 100%,
    breakable: true,
    [
      #context [
        #grid(
          columns: (auto, 1fr, auto),
          column-gutter: -2.2em,
          align: (right, left, right),
          move(
            [
              #block(
                inset: 0.2em,
                stroke: 1pt,
                [#text(weight: "bold")[Q. #counter("question").display()]],
              )
            ],
            dx: -3.5em,
          ),
          [#body],
          if points != none [
            #text(weight: "bold")[(#points #if points == 1 [pt] else [pts])]
          ],
        )
      ]
    ],
  )
}

// Subquestion formatting
#let subquestion(label: none, points: none, body) = {
  counter("subquestion").step()
  block(
    width: 100%,
    inset: (left: 0em),
    [
      #grid(
        columns: (auto, 1fr, auto),
        column-gutter: 0.5em,
        align: (left, left, right),
        [
          #if (
            label != none
          ) [*(#label)*] else [#context { counter("question").display() }-#context {
              counter("subquestion").display("a)")
            }]
        ],
        [#body],
        if points != none [
          (#points #if points == 1 [pt] else [pts])
        ],
      )
    ],
  )
}

// Answer space
#let answer-space(lines: 5) = {
  v(0.5em)
  for i in range(lines) {
    v(1.2em)
    line(length: 100%, stroke: (dash: "dotted", thickness: 0.5pt))
  }
  v(0.5em)
}

// Box for answer
#let answer-box(height: 5cm) = {
  v(0.5em)
  block(
    width: 100%,
    height: height,
    stroke: 1pt,
    inset: 0.5em,
    [],
  )
  v(0.5em)
}

// Multiple choice option
#let choice(label, body) = {
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.5em,
    [ □ #label)], body,
  )
  //v(0.3em)
}

// True/False question
#let true-false() = {
  grid(
    columns: (auto, auto),
    column-gutter: 2em,
    [ □	 True], [□  False],
  )
}

// Section divider
#let section(title) = {
  v(1em)
  block(
    width: 100%,
    inset: 0.5em,
    fill: rgb("#e0e0e0"),
    [
      #text(weight: "bold", size: 13pt)[#title]
    ],
  )
  v(1em)
}

// Grading table
#let grading-table(questions) = {
  pagebreak()
  align(center)[
    #text(size: 14pt, weight: "bold")[Grading Summary]
    #v(1em)
    #table(
      columns: (auto, 1fr, 1fr),
      align: (center, center, center),
      stroke: 1pt,
      [*Question*], [*Points*], [*Score*],
      ..questions
        .map(q => (
          [#q.number],
          [#q.points],
          [],
        ))
        .flatten(),
      table.hline(stroke: 2pt),
      [*Total*],
      [*#questions.map(q => q.points).sum()*],
      [],
    )
  ]
}

// Solution environment
#let solution(lines: 5, body) = {
  context {
    if state("show-solutions").get() [
      #v(0.5em)
      #block(
        width: 100%,
        inset: 0.8em,
        fill: rgb("#e8f4f8"),
        stroke: (left: 3pt + rgb("#2196F3")),
        [
          #text(weight: "bold", fill: rgb("#1976D2"))[Solution:] \
          #v(0.3em)
          #body
        ],
      )
      #v(0.5em)
    ] else [
      #answer-space(lines: lines)
    ]
  }
}



/*
#question()[
  You are tasked with classifying rock types based on spectral data. Design a complete machine learning pipeline including:
  - Data collection and preprocessing
  - Feature selection
  - Model selection and training
  - Evaluation metrics

  #answer-box(height: 12cm)
]

#question()[
  True or False: Indicate whether each statement is true or false.

  #subquestion(label: "a")[
    Decision trees are always better than neural networks for geological data.
    #v(0.3em)
    #true-false()
  ]

  #subquestion(label: "b")[
    Cross-validation helps prevent overfitting.
    #v(0.3em)
    #true-false()
  ]

  #subquestion(label: "c")[
    Feature scaling is not important for distance-based algorithms.
    #v(0.3em)
    #true-false()
  ]

  #subquestion(label: "d")[
    A confusion matrix can be used to evaluate classification models.
    #v(0.3em)
    #true-false()
  ]
]
 */
