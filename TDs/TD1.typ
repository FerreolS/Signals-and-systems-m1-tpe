#import "CC-template.typ": *
#import "@preview/cetz:0.4.2": canvas, draw

#show: exam.with(
  title: "Data Science",
  course: "TD 1",
  date: none,
  duration: none,
  student-info: none,
  show-solutions: sys.inputs.at("solutions", default: "true") == "true",
)

= Signals and systems

#question()[
  Consider the continuous-time signal
  $
    x(t) = 2 cos(3π t) + sin(4π t).
  $
  #subquestion(label: "a")[
    Determine its fundamental period and fundamental angular frequency.
    #solution(lines: 0)[
      The two component angular frequencies are $ω_1 = 3π$ and $ω_2 = 4π$.
      A common angular frequency must divide both, and their greatest common
      angular frequency is $ω_0 = π$, since $ω_1 = 3ω_0$ and $ω_2 = 4ω_0$.
      Equivalently, a common period $T$ must satisfy
      $
        3π T = 2π m quad and quad 4π T = 2π n
      $
      for integers $m$ and $n$. The smallest positive choice is $m = 3$ and
      $n = 4$, giving $T_0 = 2$. This also follows from
      $T_0 = 2π / ω_0 = 2$.
    ]
  ]
  #subquestion(label: "b")[
    Is $x(t)$ an energy signal or a power signal? Compute its average power.
    #solution(lines: 0)[
      Since $x(t)$ is periodic and nonzero, its energy is infinite. Its average
      power is computed over one fundamental period, $T_0 = 2$:
      $
        P & = 1/2 integral_(-1)^1 (2 cos(3π t) + sin(4π t))^2 dif t \
          & = 1/2 integral_(-1)^1 (4 cos^2(3π t) + sin^2(4π t) + 4 cos(3π t) sin(4π t)) dif t \
          & = 1/2 (4 + 1 + 0) \
          & = 5/2.
      $
      Over $[-1, 1]$, each squared sinusoid integrates to $1$, and the cross
      term integrates to zero because its integrand is odd.
    ]
  ]
  #subquestion(label: "c")[
    Is the discrete-time signal $z[n] = cos(π sqrt(2) n)$ periodic? Explain.
    #solution(lines: 0)[
      A discrete-time sinusoid is periodic only if its frequency divided by
      $2π$ is rational. Here this ratio is $sqrt(2)/2$, which is irrational;
      therefore $z[n]$ is not periodic.
    ]
  ]
]

#question()[
  For each system below, determine whether it is linear, time-invariant, causal,
  and BIBO stable:
  $
    H_1{x}(t) = x(t - 2), quad
    H_2{x}(t) = t x(t), quad
    H_3{x}(t) = x(-t).
  $
  #solution(lines: 0)[
    For a shifted input $x_τ(t) = x(t - τ)$, time invariance requires
    $H{x_τ}(t) = H{x}(t - τ)$. BIBO stability requires every bounded input
    ($|x(t)| <= M$) to produce a bounded output.

    - $H_1{x}(t) = x(t - 2)$
      - linear:
      $ H_1{a x_1 + b x_2}(t) = a x_1(t - 2) + b x_2(t - 2). $
      - time-invariant:
      $ H_1{x_τ}(t) = x(t - τ - 2) = H_1{x}(t - τ). $
      - causal since its output at $t$ depends only on the past input $x(t - 2)$.
      - BIBO stable:
      $ |x(t)| <= M ⇒ |H_1{x}(t)| = |x(t - 2)| <= M $.

    - $H_2{x}(t) = t x(t)$
      - linear:
      $
        H_2{a x_1 + b x_2}(t) = t (a x_1(t) + b x_2(t))
        = a H_2{x_1}(t) + b H_2{x_2}(t).
      $
      - causal because its output at $t$ uses only $x(t)$. It is
      - time-varying:
      $
        H_2{x_τ}(t) = t x(t - τ) != (t - τ) x(t - τ) = H_2{x}(t - τ)
      $
      - not BIBO stable: the bounded input $x(t) = 1$ produces $y(t) = t$, which is unbounded.

    - $H_3{x}(t) = x(-t)$
      - linear because
      $
        H_3{a x_1 + b x_2}(t) = a x_1(-t) + b x_2(-t).
      $
      - time-varying, since
      $
        H_3{x_τ}(t) = x(-t - τ)
        != x(-t + τ) = H_3{x}(t - τ)
      $
      - BIBO stable:
        $|x(t)| <= M ⇒ |H_3{x}(t)| = |x(-t)| <= M$.
      - noncausal:
        at $t = -1$, for example, the output is $y(-1) = x(1)$, which depends on a future input value.
  ]
]

#question()[
  Evaluate
  $
    integral_(-infinity)^(+infinity) (t^2 + 1) delta(2t - 1) dif t.
  $
  #solution(lines: 0)[
    Using $delta(2t - 1) = 1/2 delta(t - 1/2)$ and the sifting property,
    $
      integral_RR (t^2 + 1) delta(2t - 1) dif t
      = 1/2 ((1/2)^2 + 1) = 5/8.
    $
  ]
]

= Linear time-invariant systems

#question()[
  A discrete-time LTI system has impulse response
  $h[n] = delta[n] + delta[n - 1] + delta[n - 2]$.
  Its input is $x[n] = delta[n] + 2 delta[n - 1]$.
  Find the output $y[n]$ and list its nonzero values.
  #solution(lines: 0)[
    By the convolution sum,
    $
      y[n] = (x * h)[n] = h[n] + 2h[n - 1].
    $
    Thus $y[0] = 1$, $y[1] = 3$, $y[2] = 3$, and $y[3] = 2$; it is zero
    elsewhere.

    The stem plots show the input, impulse response, and their convolution.
    Each output sample is the sum of the overlapping products $x[k] h[n-k]$.
    #canvas(length: 0.6cm, {
      import draw: *

      let scale = 0.4
      let base = 0
      let x-start = 0
      let h-start = 4
      let y-start2 = 9
      let y-start3 = 14
      let y-start = 20
      let y-text = 0.8

      content((x-start + 1, -1), $x[n]$)
      content((h-start + 1, -1), $h[n]$)
      content((y-start + 2, -1), $y[n]$)
      content((2.8, y-text), $∗$)
      content((8, y-text), $=$)
      content((13, y-text), $+$)
      content((19, y-text), $=$)

      line((x-start, base), (x-start + 2.4, base), mark: (end: ">"))
      line((h-start, base), (h-start + 3.4, base), mark: (end: ">"))
      line((y-start2, base), (y-start2 + 3.4, base), mark: (end: ">"))
      line((y-start3, base), (y-start3 + 4.4, base), mark: (end: ">"))
      line((y-start, base), (y-start + 4.4, base), mark: (end: ">"))

      for (n, value) in ((0, 1), (1, 2)) {
        let height = value * scale
        line((x-start + n, base), (x-start + n, base + height), stroke: blue + 1pt)
        content((x-start + n, base - 0.3), text(size: 8pt, $#n$))
        content((x-start + n, base + height + 0.3), text(size: 8pt, $#value$))
      }

      for (n, value) in ((0, 1), (1, 1), (2, 1)) {
        let height = value * scale
        line((h-start + n, base), (h-start + n, base + height), stroke: blue + 1pt)
        content((h-start + n, base - 0.3), text(size: 8pt, $#n$))
        content((h-start + n, base + height + 0.3), text(size: 8pt, $#value$))
      }

      for (n, value) in ((0, 1), (1, 1), (2, 1)) {
        let height = value * scale
        line((y-start2 + n, base), (y-start2 + n, base + height), stroke: blue + 1pt)
        content((y-start2 + n, base - 0.3), text(size: 8pt, $#n$))
        content((y-start2 + n, base + height + 0.3), text(size: 8pt, $#value$))
      }

      for (n, value) in ((1, 2), (2, 2), (3, 1)) {
        let height = value * scale
        line((y-start3 + n, base), (y-start3 + n, base + height), stroke: blue + 1pt)
        content((y-start3 + n, base - 0.3), text(size: 8pt, $#n$))
        content((y-start3 + n, base + height + 0.3), text(size: 8pt, $#value$))
      }

      for (n, value) in ((0, 1), (1, 3), (2, 3), (3, 2)) {
        let height = value * scale
        line((y-start + n, base), (y-start + n, base + height), stroke: blue + 1pt)
        content((y-start + n, base - 0.3), text(size: 8pt, $#n$))
        content((y-start + n, base + height + 0.3), text(size: 8pt, $#value$))
      }
    })
  ]
]

#question()[
  A continuous-time LTI system has impulse response
  $h(t) = e^(-t) u(t)$. The input is a rectangular pulse
  $x(t) = u(t) - u(t - 2)$.
  Compute the output $y(t)$.
  #solution(lines: 0)[
    The convolution integral is
    $
      y(t) = integral_RR x(τ) h(t - τ) dif τ.
    $
    The input is $1$ on $0 <= τ < 2$ and zero elsewhere. In the integrand,
    $h(t - τ) = e^(-(t - τ)) u(t - τ)$ is nonzero only when $τ <= t$.
    Thus, the integral is over the overlap of $[0, 2)$ and $(-∞, t]$:
    it is empty for $t < 0$, runs from $0$ to $t$ for $0 <= t < 2$, and
    runs from $0$ to $2$ for $t >= 2$.

    For $0 <= t < 2$,
    $
      integral_0^t e^(-(t - τ)) dif τ
      = e^(-t) integral_0^t e^τ dif τ
      = e^(-t) (e^t - 1)
      = 1 - e^(-t).
    $
    For $t >= 2$,
    $
      integral_0^2 e^(-(t - τ)) dif τ
      = e^(-t) integral_0^2 e^τ dif τ
      = e^(-t) (e^2 - 1)
      = e^(-(t - 2)) - e^(-t).
    $
    Therefore,
    $
      y(t) = cases(
        0, & t < 0,
        1 - e^(-t), & 0 <= t < 2,
        e^(-(t - 2)) - e^(-t), & t >= 2.
      )
    $
    The output rises from $0$ to $1 - e^(-2)$ while the input is on, then
    decays toward zero after the input ends.
  ]
]


#question()[
  Show the following properties of the convolution operation:
  #subquestion(label: "a")[
    Commutativity: $x(t) * h(t) = h(t) * x(t)$.
    #solution(lines: 0)[
      By definition,
      $
        x(t) * h(t) = integral_RR x(τ) h(t - τ) dif τ.
      $
      Let $τ' = t - τ$, so $dif τ' = - dif τ$.

      As $τ$ runs from
      $-∞$ to $∞$, $τ'$ runs from $∞$ to $-∞$, reversing these limits
      cancels the minus sign from the differential, leaving an integral over
      all of $RR$ with its usual orientation. Thus,
      $
        x(t) * h(t)
        = integral_RR x(t - τ') h(τ') dif τ' \
        = integral_RR h(τ') x(t - τ') dif τ' \
        = h(t) * x(t).
      $
      The second equality uses commutativity of multiplication, and the last
      equality is the convolution definition with $h$ as the first signal.
    ]
  ]
  #subquestion(label: "b")[
    Associativity: $x(t) * (h_1(t) * h_2(t)) = (x(t) * h_1(t)) * h_2(t)$.
    #solution(lines: 0)[
      Let $y_1(t) = x(t) * h_1(t)$ and $y_2(t) = h_1(t) * h_2(t)$.
      Then
      $
        y_1(t) * h_2(t) & = integral_RR y_1(τ) h_2(t - τ) dif τ \
                        & = integral_RR integral_RR x(λ) h_1(τ - λ) dif λ thin h_2(t - τ) dif τ.
      $
      Assuming the double integral is absolutely integrable, Fubini's theorem
      permits switching the order of integration. For each fixed $λ$, set
      $μ = τ - λ$.
      Then $dif μ = dif τ$ and $t - τ = (t - λ) - μ$, so the inner integral
      becomes
      $
        integral_RR h_1(τ - λ) h_2(t - τ) dif τ
        = integral_RR h_1(μ) h_2((t - λ) - μ) dif μ
        = (h_1 * h_2)(t - λ),
      $
      using the definition of convolution. Therefore,
      $
        y_1(t) * h_2(t) & = integral_RR x(λ) integral_RR h_1(τ - λ) h_2(t - τ) dif τ dif λ \
                        & = integral_RR x(λ) (h_1 * h_2)(t - λ) dif λ \
                        & = x(t) * (h_1 * h_2)(t).
      $
    ]
  ]
  #subquestion(label: "c")[
    Distributivity: $x(t) * (h_1(t) + h_2(t)) = x(t) * h_1(t) + x(t) * h_2(t)$.
    #solution(lines: 0)[
      By definition,
      $
        x(t) * (h_1(t) + h_2(t)) & = integral_RR x(τ) (h_1 + h_2)(t - τ) dif τ \
                                 & = integral_RR x(τ) h_1(t - τ) dif τ + integral_RR x(τ) h_2(t - τ) dif τ \
                                 & = x(t) * h_1(t) + x(t) * h_2(t).
      $
    ]
  ]
]

#question()[
  Show that $(x * h)' = (x' * h) = (x * h')$.
  #solution(lines: 0)[
    By definition,
    $
      dif/dt (x(t) * h(t)) & = dif/dt integral_RR x(τ) h(t - τ) dif τ \
                           & = integral_RR x(τ) dif/dt h(t - τ) dif τ \
                           & = integral_RR x(τ) dif /dt h(t - τ) dif τ \
                           & = integral_RR x(τ) h'(t - τ) dif τ \
                           & = (x * h')(t).
    $
    Similarly,
    $
      ((dif x(t)) / dt * h(t)) & = integral_RR dif/dt x(t) h(t - τ) dif τ \
                               & = integral_RR x(τ) dif/dt h(t - τ) dif τ \
                               & = integral_RR x(τ) h'(t - τ) dif τ \
                               & = (x * h')(t).
    $
  ]
]


#question()[
  Show the following functions converge to the Dirac delta function:
  #solution(lines: 0)[
    To show that a function $f_p (t)$ parameterized by $p$ converges to the Dirac delta function when $p → P$, we need to show that
    1. $integral_RR f(t) dif t = 1$ for all $t$.
    2. For any $t ≠ 0$, $lim_(p → P) f(t) = 0$.
  ]
  #subquestion(label: "a")[
    $
      lim_(L → 0) (1/(2L) u(t + L) - 1/(2L) u(t - L) ) = δ(t)
    $
    where $u(t)$ is the unit step function.
    #solution(lines: 0)[
      We have
      $
        integral_RR (1/(2L) u(t + L) - 1/(2L) u(t - L) ) dif t = 1/(2L) integral_(-L)^(+L) dif t = 1.
      $
      For any $t ≠ 0$, we have
      $
        lim_(L → 0) x(t) = lim_(L → 0) 1/(2L) (u(t + L) - u(t - L)) = 0.
      $
      Therefore, $x(t)$ converges to the Dirac delta function as $L → 0$.
    ]
  ]
  #subquestion(label: "b")[
    $ lim_(σ^2 → 0) 1 / sqrt(2 pi σ^2) e^(-t^2 / (2σ^2)) = δ(t) $
    (knowing  the Gaussian integral: $integral_RR e^(-x^2) dif x = √π$).
    #solution(lines: 0)[
      $
        1 / sqrt(2 pi σ^2) integral_RR e^(-t^2 / (2σ^2)) dif t = 1 / sqrt(2 pi σ^2) sqrt(2σ^2 pi) = 1.
      $
      For any $t ≠ 0$, we have
      $
        lim_(σ^2 → 0) f_σ (t) = lim_(σ^2 → 0) 1 / sqrt(2 pi σ^2) e^(-t^2 / (2σ^2)) = 0.
      $
      Therefore, $f_σ (t)$ converges to the Dirac delta function as $σ^2 → 0$.
    ]
  ]
  #subquestion(label: "c")[
    $ lim_(T → +∞) T sinc(T t) = δ(t) $
    #solution(lines: 0)[
      $
        integral_RR T sinc(T t) dif t = integral_RR sin(π T t) / (π t) dif t = 1.
      $
      For any $t ≠ 0$, we have
      $
        lim_(T → +∞) T sinc(T t) = lim_(T → +∞) sin(π T t) / (π t) = 0.
      $
      Therefore, $T sinc(T t)$ converges to the Dirac delta function as $T → +∞$.
    ]
  ]
]

#question()[
  Show that the convolution of two Gaussian (centered) function of variance $σ^2$ is
  a Gaussian function of variance $2σ^2$.
  #solution(lines: 0)[
    Let $f(t) = 1 / sqrt(2 pi sigma^2) e^(-t^2 / (2σ^2))$

    $
      (f * f)(t) &= integral_RR 1 / sqrt(2 pi sigma^2) exp(-(t - τ)^2 / (2 sigma^2)) dot 1 / sqrt(2 pi sigma^2) exp(-τ^2 / (2 sigma^2)) thin dif τ \
      &= 1 / (2 pi sigma^2) integral_RR exp(-((t - τ)^2 + τ^2) / (2 sigma^2)) thin dif τ \
      & = 1 / (2 pi sigma^2) integral_RR exp(-(t^2 - 2 t τ + 2τ^2) / (2 sigma^2)) thin dif τ \
      & = 1 / (2 pi sigma^2) integral_RR exp(-(2(τ - t / 2)^2 - t^2 / 2 + t^2)/ (2 sigma^2)) thin dif τ \
      &= 1 / (2 pi sigma^2) exp(-t^2 / (4 sigma^2)) integral_RR exp(-(τ - t / 2)^2 / sigma^2) thin dif τ \
      &= 1 / (2 pi sigma^2) exp(-t^2 / (4 sigma^2)) integral_RR exp(-u^2 / sigma^2) thin dif u \
      &= 1 / (2 pi sigma^2) exp(-t^2 / (4 sigma^2)) (sigma sqrt(pi)) \
      &= 1 / sqrt(2 pi (2 sigma^2)) exp(-t^2 / (2 (2 sigma^2)))
    $

  ]
]
