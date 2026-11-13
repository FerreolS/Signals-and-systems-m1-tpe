#import "CC-template.typ": *

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
      The two angular frequencies are $3π$ and $4π$. Their common fundamental
      angular frequency is $ω_0 = π$, so the fundamental period is
      $T_0 = 2π / ω_0 = 2$.
    ]
  ]
  #subquestion(label: "b")[
    Is $x(t)$ an energy signal or a power signal? Compute its average power.
    #solution(lines: 0)[
      Since $x(t)$ is periodic and nonzero, its energy is infinite. Its average
      power is the sum of the powers of its two distinct harmonics:
      $
        P = 2^2 / 2 + 1^2 / 2 = 5/2.
      $
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
    $H_1$ is linear, time-invariant, causal, and BIBO stable: it delays the input
    by two time units.

    $H_2$ is linear, causal, and time-varying. It is not BIBO stable, since the
    bounded input $x(t) = 1$ produces the unbounded output $y(t) = t$.

    $H_3$ is linear, time-varying, and BIBO stable, but noncausal: for negative
    $t$, its output depends on the input at the future time $-t$.
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
    The input is nonzero for $0 <= τ < 2$, and the impulse response requires
    $τ <= t$. Therefore,
    $
      y(t) = cases(
        0, & t < 0,
        integral_0^t e^(-(t - τ)) dif τ = 1 - e^(-t), & 0 <= t < 2,
        integral_0^2 e^(-(t - τ)) dif τ = e^(-(t - 2)) - e^(-t), & t >= 2.
      )
    $
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
      Let $τ' = t - τ$, so $dif τ' = - dif τ$. Then
      $
        x(t) * h(t) = integral_RR x(t - τ') h(τ') dif τ' = h(t) * x(t).
      $
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
      We can switch the order of integration for Lesbesgue integrable functions, so (Fubini's theorem):
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
        lim_(σ^2 → 0) f_σ(t) = lim_(σ^2 → 0) 1 / sqrt(2 pi σ^2) e^(-t^2 / (2σ^2)) = 0.
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
