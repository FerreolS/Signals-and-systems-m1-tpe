#import "CC-template.typ": *
#import "@preview/cetz:0.4.2": canvas, draw, matrix, vector
#import "@preview/cetz-plot:0.1.3": plot


// =====================================
// EXAMPLE USAGE - Delete or modify below
// =====================================

#show: exam.with(
  title: "Data Science",
  course: "Examen Final",
  date: "17 décembre 2025",
  duration: "45 minutes",
  instructions: (
    "Réponse en anglais ou en français",
    "Pas de calculatrice et autre dispositif électronique,",
    "Pas de documents",
  ),
  student-info: true,
  show-solutions: true, // Set to true to display solutions
)

= Question de cours

#question(points: 3)[
  #subquestion()[
    Si le système qui au signal $f$ associe $cal(S){f}$ est linéaire, alors le système $cal(S){cal(S){f}}$ est linéaire :
    #grid(
      columns: 2,
      gutter: 0.6em,
      choice("1", "Vrai"), choice("2", "Faux"),
    )#answer-space(lines: 0)
  ]

  #subquestion()[
    La moyenne d'un signal aléatoire est une opération linéaire:
    #grid(
      columns: 2,
      gutter: 0.6em,
      choice("1", "Vrai"), choice("2", "Faux"),
    )#answer-space(lines: 0)
  ]


  #subquestion()[
    La variance  d'un signal aléatoire est une opération linéaire:
    #grid(
      columns: 2,
      gutter: 0.6em,
      choice("1", "Vrai"), choice("2", "Faux"),
    )#answer-space(lines: 0)
  ]


  #subquestion()[
    La transformée de Fourier est une opération linéaire:
    #grid(
      columns: 2,
      gutter: 0.6em,
      choice("1", "Vrai"), choice("2", "Faux"),
    )#answer-space(lines: 0)
  ]

  #subquestion()[
    $∫_(-∞)^(∞) x(τ) δ(t+τ) dif τ =$
    #grid(
      columns: 2,
      gutter: 0.6em,
      choice("1", $x(t)$), choice("2", $x(0)$),
      choice("3", $x(-t)$), choice("4", $hat(x)(ν)$),
    )#answer-space(lines: 0)
  ]

]

#question(points: 1)[
  Quelle approximation fait-on lorsqu'on utilise la DFT pour calculer la convolution de signaux discrets ?
  #solution(lines: 0)[
    La DFT suppose que le signal d'entrée est périodique, ce qui peut introduire des artefacts aux bords si le signal n'est pas réellement périodique.
  ]
]

#question(points: 1)[
  Qu'est-ce qu'un signal aléatoire stationnaire ?
  #solution(lines: 0)[
    Un signal aléatoire stationnaire est un signal dont les propriétés statistiques, telles que la moyenne et la covariance, restent constantes dans le temps.
  ]
]


= Problème

On a un signal $x$ dont le spectre est
$
  hat(x) (ν) = "tri"(ν/B) thin ,
$
où la fonction $"tri"(ν)$ est la fonction triangle:
$
  "tri"(ν) = max(1 - abs(x), 0) = cases(
    0 & " si "≤ -1,
    ν + 1 & " si " -1 ≤ ν ≤ 0,
    -ν + 1 & " si " 0 ≤ ν ≤ 1,
    0 & " si " ν ≥ 1
  )
$

== Modulation

Pour le transmettre, on utilise une modulation d'amplitude qui consiste à le multiplier par une porteuse $p$ de fréquence $ν_p > B$ :
$
  p(t) = cos(2π ν_p t)
$
Cela donne le signal modulé $y$:
$
  y(t) = p(t) thin x(t)
$
#question(points: 2)[
  Tracez la fonction $"tri"$ et
  montrez que la transformée de Fourier de $y(t)$ (en se rappelant de la transformé de Fourier d'un produit de deux fonctions) est
  $
    hat(y)(ν) = 1/2("tri"((ν - ν_p)/B) + "tri"((ν + ν_p)/B))
  $
  Représentez son module.
  #solution(lines: 0)[
    En utilisant la formule d'Euler, on peut écrire:
    $
      p(t) & = (e^(j 2π ν_p t) + e^(-j 2π ν_p t))/2 \
      y(t) & = x(t) thin (e^(j 2π ν_p t) + e^(-j 2π ν_p t))/2
    $

    En utilisant la propriété de décalage en fréquence de la transformée de Fourier, on obtient:
    $
      hat(y)(ν) & = (hat(x)(ν - ν_p) + hat(x)(ν + ν_p))/2 \
                & = 1/2("tri"((ν - ν_p)/B) + "tri"((ν + ν_p)/B))
    $

  ]
]


#question(points: 1)[
  Quelle doit être la fréquence d'échantillonnage minimale pour échantillonner correctement le signal $y$ ?

  #solution(lines: 0)[
    La fréquence d'échantillonnage minimale doit être au moins le double de la fréquence maximale présente dans le signal modulé $y(t)$. La bande passante de $y(t)$ est centrée autour de $±ν_p$ et a une largeur de $2B$. La fréquence maximale est donc $ν_p + B$. Ainsi, la fréquence d'échantillonnage minimale $f_s$ doit satisfaire :
    $
      f_s ≥ 2(ν_p + B)
    $
  ]
]

== Démodulation

A la reception, on démodule $y$ en le remultipliant par la porteuse:
$
  z(t) = p(t) thin y(t)
$


#question(points: 3)[
  Donnez la transformée de Fourier de $z(t)$ et dessinez son module :

  #solution(lines: 0)[
    En utilisant la formule d'Euler, on peut écrire:
    $
      p(t) & = (e^(j 2π ν_p t) + e^(-j 2π ν_p t))/2 \
      z(t) & = y(t) thin (e^(j 2π ν_p t) + e^(-j 2π ν_p t))/2
    $

    En utilisant la propriété de décalage en fréquence de la transformée de Fourier, on obtient:
    $
      hat(z)(ν) & = (hat(y)(ν - ν_p) + hat(y)(ν + ν_p) )/2 \
      & = 1/4("tri"((ν - ν_p - ν_p)/B) + "tri"((ν - ν_p + ν_p)/B) ) + 1/4("tri"((ν + ν_p - ν_p)/B) + "tri"((ν + ν_p + ν_p)/B)) \
      & = 1/4"tri"((ν - 2ν_p)/B) + 1/4"tri"(ν/B) + 1/4"tri"(ν/B) + 1/4"tri"((ν + 2ν_p)/B) \
      & = 1/4"tri"((ν - 2ν_p)/B) + 1/2 "tri"(ν/B) + 1/4"tri"((ν + 2ν_p)/B)
    $

    Le module de $hat(z)(ν)$ montre trois composantes principales:
    - Une composante centrée à $0$ avec une amplitude maximale de 1/2
    - Deux composantes centrées à $±2ν_p$ avec une amplitude maximale de 1/4
    - La bande passante de chaque composante est de $2B$
  ]
]

== Filtrage

On filtre ce signal $z$ avec un filtre $H$  pour retrouver le signal d'origine.

#question()[
  #subquestion(
    points: 2,
  )[Déterminez $K$ tel que le filtre $H$ avec la fonction de transfert $h(ν) = 2 "rect"(ν/K)$ soit optimal pour retrouver exactement $x$. Avec la fonction rectangle donnée dans la table à la fin du sujet.
    /*
    $
      "rect"(ν) = cases(
        1 & " si " |ν| ≤ 1/2,
        0 & " sinon "
      )
    $
    On se souviendra si besoin que la transformé de Fourier d'un rectangle est un sinus cardinal. */

    #solution(lines: 0)[
      Après démodulation, la composante utile est $1/2 hat(x)(ν)$ centrée en 0 avec une largeur $2B$. Le filtre doit donc laisser passer toute cette bande et multiplier par 2 pour compenser le facteur $1/2$. Il faut alors :
      $
        K = 2B
      $
      Le filtre $H$ de fonction de transfert $h(ν) = 2 "rect"(ν/(2B))$ restitue $x(t)$ et supprime les composantes à $±2ν_p$.
    ]
  ]

  #subquestion(points: 1)[
    Quelles sont les raisons qui nous empêchent de l'utiliser en pratique ?

    #solution(lines: 0)[
      En pratique, plusieurs facteurs empêchent l'utilisation d'un filtre idéal "rect" :
      - *Non-causalité* : La réponse impulsionnelle d'un filtre idéal "rect" (un sinus cardinal) est non-causale, ce qui signifie qu'elle dépend de valeurs futures du signal d'entrée. Cela rend la mise en œuvre impossible dans les systèmes en temps réel.
      - *Décroissance très lente* : La réponse impulsionnelle décroît lentement (en $1/t$), ce qui nécessite de considérer un signal très long.

    ]
  ]

  #subquestion(points: 1)[
    Que se passe-t-il si $B > ν_p$ ?

    #solution(lines: 0)[
      Si $B > ν_p$, la bande passante du signal d'origine $x(t)$ est plus large que la fréquence de la porteuse $p(t)$. Dans ce cas, lors de la modulation, les spectres positif et négatif du signal modulé $y(t)$ se chevaucheront. Cela entraîne une interférence entre les différentes composantes fréquentielles, rendant impossible la récupération correcte du signal d'origine lors de la démodulation.
    ]
  ]
]

On utilise le filtre $H$ avec la réponse impulsionnelle suivante :
$
  g(t) = 1 / τ u(t) e^(-t / τ)
$
où $u(t)$ est la fonction de Heaviside et $τ$ est une constante de temps scalaire.


#question(points: 2)[
  Donnez la fonction de transfert  $hat(g)(ν)$  de ce filtre:
  #solution(lines: 0)[
    La transformée de Fourier de la réponse impulsionnelle $g(t)$ est donnée par:
    $
      hat(g)(ν) & = ∫_(-∞)^(∞) g(t) e^(-j 2π ν t) dif t \
                & = ∫_(0)^(∞) (1 / τ) e^(-t / τ) e^(-j 2π ν t) dif t \
                & = 1 / τ ∫_(0)^(∞) e^(-t (1 / τ + j 2π ν)) dif t \
                & = 1 / τ [ -1 / (1 / τ + j 2π ν) e^(-t (1 / τ + j 2π ν)) ]_(0)^(∞) \
                & = 1 / τ [ 0 - (-1 / (1 / τ + j 2π ν)) ] \
                & = 1 / (1 + j 2π ν τ)
    $
  ]

]

#question(points: 1)[
  Donnez sa fréquence de coupure $ν_c$, la fréquence au-dessus de laquelle l'énergie du signal en sortie est divisée par 2 par rapport à l'entrée.

  #solution(lines: 0)[
    On cherche $ν_c$ tel que:
    $
      |hat(g)(ν_c)|^2 = 1/2 \
      => 1 / (1 + (2π ν_c τ)^2) = 1/2 \
      => 1 + (2π ν_c τ)^2 = 2 \
      => (2π ν_c τ)^2 = 1 \
      => 2π ν_c τ = 1 \
      => ν_c = 1 / (2π τ)
    $
  ]

]

== Signal aléatoire

Si maintenant le signal à transmettre est un signal aléatoire $X(t)$ dont la fonction d'autocorrélation est
$
  γ_x (τ) = B sinc^2(B thin τ) thin ,
$
#question(points: 2)[
  Montrez que $S_X (ν)$, le spectre de puissance de $X$, est
  $
    S_X (ν) = "tri"(ν/B).
  $
  #solution(lines: 0)[
    On sait que la transformée de Fourier d'un sinus cardinal est une fonction rectangle. En utilisant le théorème de convolution, on a :
    $
      S_X (ν) & = FT{γ_x (τ)} \
              & = FT{B sinc^2(B thin τ)} \
              & = B (1/B) "rect"(ν/B) * (1/B) "rect"(ν/B) \
              & = 1/B ("rect"(ν/B) * "rect"(ν/B)) \
              & = "tri"(ν/B)
    $

  ]

]


= Quelques transformées de Fourier notables
#show table.cell: set text(size: 9pt)
#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    stroke: 0.5pt + silver,
    table.header([*Signal*], [*Time Domain*], [*Frequency Domain*]),
    [Rectangle],
    $"rect"(t) = cases(1 quad &"if" abs(t) < 1/2, 0 quad &"otherwise")$,
    $hat("rect")(ν) = "sinc"(ν) = (sin(π ν))/(π ν)$,

    [Sinc], $x(t) = "sinc"(t) = (sin(π t))/(π t)$, $hat(x)(ν) = "rect"(ν)$,

    [Gaussian], $x(t) = e^(-π t^2)$, $hat(x)(ν) = e^(-π ν^2)$,

    [Exponential decay], $x(t) = e^(-a t) u(t), quad a > 0$, $hat(x)(ν) = 1/(a + j 2π ν)$,

    [Two-sided exponential], $x(t) = e^(-a abs(t)), quad a > 0$, $hat(x)(ν) = (2a)/(a^2 + (2π ν)^2)$,

    [Complex exponential], $x(t) = e^(j 2π ν_0 t)$, $hat(x)(ν) = δ(ν - ν_0)$,

    [Sign], $x(t) = "sgn"(t) = cases(1 quad &t > 0, -1 quad &t < 0)$, $hat(x)(ν) = 1/(j π ν)$,

    [Unit step], $x(t) = u(t)$, $hat(x)(ν) = 1/(j 2π ν) + 1/2 δ(ν)$,
  ),
) <table-fourier-transforms>
