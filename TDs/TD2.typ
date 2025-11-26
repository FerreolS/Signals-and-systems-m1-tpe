#import "CC-template.typ": *
#import "@preview/cetz:0.4.2": canvas, draw, matrix, vector
#import "@preview/cetz-plot:0.1.3": plot


// =====================================
// EXAMPLE USAGE - Delete or modify below
// =====================================

#show: exam.with(
  title: "Data Science",
  course: "TD 2",
  date: "25 November 2025",
  duration: none,
  student-info: none,
  show-solutions: sys.inputs.at("solutions", default: "true") == "true", // Set to true to display solutions
)

#let dt = $dif t$

//#section("Part I: Short Answer")

#question()[
  Consider the following signal:
  $
    //   x(t) = 1 + sin(ω_0 t) + 2 cos(ω_0 t) +cos(2ω_0 t+ π/4)\
    x(t) = 1 + sin(4π t) + 2 cos(4π t) +cos(6π t+ π/4)
  $
]
#subquestion(label: "a")[
  What is the fundamental pulsation $ω_0$?
  #solution(lines: 0)[

    The fundamental pulsation is $ω_0 = 2π$.
  ]
]
#subquestion(label: "b")[
  Compute its Fourier series:
  #solution(lines: 0)[


    Expand $x(t)$ in term of complex exponentials using Euler
    $
      x(t) &= 1 + (e^(j 2ω_0 t) - e^(-j 2ω_0 t)) / (2j) + 2 (e^(j 2ω_0 t) + e^(-j 2ω_0 t)) / 2 + 1/2(e^(j(3 ω_0 t + π/4)) + e^(-j(3 ω_0 t + π/4)))\
      & = 1 + (1/(2j) + 1) e^(j 2ω_0 t) + (-1/(2j) + 1) e^(-j 2ω_0 t) + 1/2 e^(j π/4) e^(j 3 ω_0 t)+ 1/2 e^(-j π/4) e^(-j 3 ω_0 t) \
      & = 1 + (1/(2j) + 1) e^(j 2ω_0 t) + (-1/(2j) + 1) e^(-j 2ω_0 t) + sqrt(2)/4(1 - j) e^(j 3 ω_0 t) + sqrt(2)/4(1 + j) e^(-j 3 ω_0 t)
    $

    The Fourier series coefficients are:
    $
       hat(x)[0] & = 1 \
       hat(x)[2] & = 1 - j/2 \
      hat(x)[-2] & = 1 + j/2 \
       hat(x)[3] & = sqrt(2)/4 (1+ j) \
      hat(x)[-3] & = sqrt(2)/4(1 - j) \
       hat(x)[k] & = 0 text("for all other k")
    $
  ]
]

#question()[ Fourier Series of a  periodic square wave]
#subquestion(label: "a")[ Compute the Fourier series of the periodic signal of period $T$ (taking $ω_0= (2π)/T$):
  $
    x(t) = cases(
      1 quad text("if ") abs(t) <= L,
      0 quad text("otherwise")
    )
  $
  #solution(lines: 0)[
    $hat(x)[0] = 1/T ∫_(-L)^(+L) dt = (2L)/T$

    For $k ≠ 0$:
    $
      hat(x)[k] & = 1/T ∫_(-L)^(+L) e^(-j k ω_0 t)dt \
                & = 1/T [ -1/(j k ω_0)e^(-j k ω_0 t)]_(-L)^L \
                & = 1/(k ω_0 T) ( (e^(j k ω_0 L) - e^(-j k ω_0 L))/(j)) \
                & = 2 sin(k ω_0 L) / (k ω_0 T) \
                & = sin(k ω_0 L)/(k π)
    $

  ]
]

#subquestion(label: "b")[
  Compute the Fourier series of the Dirac comb of period $T$:
  $
    y(t) = ∑_(k=-∞)^(+∞) δ(t - k T)
  $
  #solution(lines: 0)[
    The Fourier series coefficients are given by:
    $
      hat(y)[k] = 1/T ∫_(-T/2)^(T/2) x(t) e^(-j k ω_0 t ) dif t
    $
    Evaluating the integral, we find that all coefficients are equal to $1/T$.
  ]
]
#subquestion(label: "c")[
  Compute the Fourier series of:
  $
    z(t) = y(t + T_1) - y(t - T_1)
  $
  #solution(lines: 0)[
    Using linearity and time-shifting properties of the Fourier series, we find that the coefficients are:
    $
      hat(z)[k] & = hat(y)[k] (e^(j k T_1 ω_0) - e^(-j k T_1 ω_0)) \
                & = hat(y)[k]thin (2j thin sin(k thin ω_0 thin T_1)) \
                & = (2j) / T thin sin(k thin ω_0 thin T_1) \
    $
  ]
]

#subquestion(label: "d")[
  Derive the solution of question (a) from the answer of question (c)
  #solution(lines: 0)[
    We can notice $z(t)$ is the derivative of $x(t)$, we can use the differentiation property
    $
      hat(z)[k] = j k ω_0 hat(x)[k]
    $
    Thus,
    $
      hat(x)[k] & = (hat(z)[k]) / (j k ω_0) quad ∀ k ≠ 0 \
                & = (2 thin sin(k thin ω_0 thin T_1)) / (T thin k thin ω_0)
    $
    When $T_1 = L$, it is the same result as in question (a) if we take the mean $hat(x)[0] = 2 T_1/T$.


  ]
]


#subquestion(label: "e")[

  #let ratio = 0.95
  #let percent = ratio * 100

  How many terms are needed to capture $#percent$ % of the signal $x(t)$ power as a function of $α = 2 L/T$?
  #solution(lines: 0)[
    The power of the signal is :
    $
      P & = 1/T ∫_T abs(x(t))^2 dt \
        & = 1/T ∫_(-L)^(+L) 1^2 dt \
        & = (2L)/T \
        & = α
    $
    The power of the signal is also given by Parseval's theorem:
    $
      P = ∑_(k=-∞)^(+∞) |hat(x)[k]|^2
    $
    The power $P_K$ of signal approximated by the $2K+1$ first terms:
    $
      P_K & =|hat(x)[0]|^2 + ∑_(k=1)^(K) |hat(x)[k]|^2 + |hat(x)[-k]|^2 \
      // & = ((2L)/T)^2 + ∑_(k=1)^(K) (2 sin(k ω_0 L) / (k ω_0 T))^2 + (2 sin(-k ω_0 L) / (-k ω_0 T))^2 \
          & = ((2L)/T)^2 + ∑_(k=1)^(K) (sin(k ω_0 L)/(k π))^2 + (sin(-k ω_0 L)/(-k π))^2 \
          & = α^2 + ∑_(k=1)^(K) (sin(π k α)/(k π))^2 + (sin(-π k α)/(-k π))^2 \
          & = α^2 + ∑_(k=1)^(K) 2(sin^2(π k α)) / (k^2 π^2)
    $
    We need to find the smallest integer $K$ such that:
    $
                                              P_K / P & >= #ratio \
      α + 2 ∑_(k=1)^(K) (sin^2(π k α)) / ( α k^2 π^2) & >= #ratio \
    $

    #let α = 0.15
    #let Nk = none
    For $α=#α$
    #canvas(length: 0.9cm, {
      import draw: *

      let K = 15

      // Draw axes
      line((0, 0), (K, 0), mark: (end: ">"))
      content((K + 0.1, -0.3), $K$)

      line((0, 0), (0, 1 + 0.5), mark: (end: ">"))
      content((-0.3, 1 + 0.5), $P_k/P$)

      line((0, ratio), (K - 0.5, ratio), stroke: silver)
      content((K, 1), $#ratio$)

      // Draw the periodic sinusoidal curve
      let sk = α
      let prev-point = (0, sk)
      line((0, 0), (0, sk), stroke: blue + 1.5pt)
      content((-0.3, sk + 0.2), text(size: 9pt, $#calc.round(sk, digits: 3)$))
      content((0, 0 - 0.2), text(size: 9pt, $0$))

      for k in range(1, K, step: 1) {
        sk = sk + 2 * calc.pow(calc.sin(calc.pi * k * α), 2) / (α * k * k * calc.pi * calc.pi)
        let curr-point = (k, sk)
        line((k, 0), curr-point, stroke: blue + 1.5pt)
        content((k, sk + 0.2), text(size: 9pt, $#calc.round(sk, digits: 3)$))
        content((k, 0 - 0.2), text(size: 9pt, $#k$))
        if Nk == none { if sk > ratio { Nk = k } }
        //if prev-point != none { line(prev-point, curr-point, stroke: blue + 1.5pt) }
        //prev-point = curr-point
        //
      }
    })

    #let NN = 2 * Nk + 1
    By calculating the terms, we find that $N = 2 thin K + 1 = #NN$ terms are needed to capture at least 95% of the signal's power.
  ]
]
