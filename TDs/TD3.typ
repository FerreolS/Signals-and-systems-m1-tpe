#import "CC-template.typ": *
#import "@preview/cetz:0.4.2": canvas, draw, matrix, vector
#import "@preview/cetz-plot:0.1.3": plot


// =====================================
// EXAMPLE USAGE - Delete or modify below
// =====================================

#show: exam.with(
  title: "Data Science",
  course: "TD 3",
  date: "25 November 2025",
  duration: none,
  student-info: none,
  show-solutions: sys.inputs.at("solutions", default: "true") == "true", // Set to true to display solutions
)


#let dt = $dif t$
#let FT = $cal(F)$
#let comb = $\u{0428}$ //0448
#let opts = (
  x-tick-step: none,
  y-tick-step: none,
  x-format: plot.formats.multiple-of,
  y-min: -1,
  y-max: 1,
  legend: "inner-north",
  axis-style: "school-book",
)

= Sampling
#question()[
  Fourier transform of the Dirac comb:
  #subquestion(label: "a")[
    Use the properties of Fourier transform to compute the Fourier transform of
    $
      comb (t) = ∑_(n=-∞)^(+∞) delta(t - n)
    $
  ]
  #solution(lines: 0)[
    Using the property of the Fourier transform of a shifted delta function, we have:
    $
      FT{delta(t - n)}(ν) = e^(-j thin 2π thin ν thin n)
    $
    Therefore, the Fourier transform of the Dirac comb is:
    $
      hat(comb)(ν) = ∑_(n=-∞)^(+∞) e^(-j thin 2π thin ν thin n)
    $
    This sum is zero everywhere except at frequencies where $ν$ is an integer, due to the periodicity of the complex exponential function. Specifically, the sum converges to a series of delta functions located at integer frequencies.

    Thus, we can express the Fourier transform of the Dirac comb as:
    $
      hat(comb)(ν) & = ∑_(k=-∞)^(+∞) delta(ν - k) \
                   & = comb (ν)
    $
    This shows that the Fourier transform of a Dirac comb is itself. The Dirac comb is an eigenfunction of the Fourier transform with unit eigenvalue.
  ]
  #subquestion(label: "b")[
    Compute the Fourier transform the following Dirac comb (we define $ν_0 = 1/T$):
  ]
  $
    comb_T (t) = ∑_(n=-∞)^(+∞) delta(t - T thin n)
  $

  #solution(lines: 0)[
    Using the scaling property of the Fourier transform, we have:
    $
      hat(comb_T)(ν) & = 1/T ∑_(k=-∞)^(+∞) delta(ν - k/T) \
                     & = ν_0 ∑_(k=-∞)^(+∞) delta(ν - k ν_0) \
                     & = ν_0 comb_(ν_0) (ν)
    $
    This result indicates that the Fourier transform of a Dirac comb with period $T$ is another Dirac comb in the frequency domain, scaled by a factor of $1/T$ and with spikes located at integer multiples of $ν_0 = 1/T$.
  ]
]


#question()[

  Consider the following signal:
  $
    x(t) = sin(2π thin ν_x thin t + ϕ)
  $

  Compute its Fourier transform $hat(x)$ and plot $abs(hat(x))$:
  #solution(lines: 0)[

    Using Euler's formula, we can express the sine function in terms of complex exponentials:
    $
      sin(2π thin ν_x t + ϕ) & = (e^(j(2π thin ν_x t + ϕ)) - e^(-j(2π thin ν_x t + ϕ))) / (2j) \
                             & = 1/2 e^(j π/2) ( e^(j ϕ)e^(j 2π thin ν_x t) - e^(-j ϕ)e^(-j 2π thin ν_x t))
    $
    The Fourier transform of $e^(j 2π thin ν_x t)$
    is given by:
    $
      FT{e^(j 2π thin ν_x t)}(ν) = delta(ν - ν_x)
    $
    Using linearity of the Fourier transform, we obtain
    $
      FT{x(t)}(ν) & = 1/2 e^(-j π/2) ( e^(j ϕ) delta(ν - ν_x) - e^(-j ϕ) delta(ν + ν_x)) \
                  & = (e^(j (ϕ - π/2)))/2 delta(ν - ν_x) - (e^(-j (ϕ - π/2)))/2 delta(ν + ν_x)
    $

    #canvas(
      length: 1cm,
      {
        import draw: *

        plot.plot(
          ..opts,

          size: (4, 2),
          x-format: plot.formats.multiple-of,
          y-min: -1,
          y-max: 1,
          legend: "inner-north",
          axis-style: "school-book",
          x-label: $ν$,
          y-label: $|hat(x)(ν)|$,
          name: "plot",
          {
            let domain = (-3., 3)

            plot.add(((1, 0), (1, 1)), domain: domain, style: (mark: (end: ">", fill: blue), stroke: blue))
            plot.add-anchor("dp", (1, 0))
            plot.add(((-1, 0), (-1, 1)), domain: domain, style: (mark: (end: ">", fill: blue), stroke: blue))
            plot.add-anchor("dm", (-1, 0))

            plot.add(((-2, 0), (2, 0)), domain: domain, style: (stroke: 0pt))


            //plot.add-vline(min: 0, max: 1, 1, style: (mark: (end: ">", fill: blue), stroke: blue))
            //plot.add-vline(min: -0.5, max: 0, 0.5, style: (mark: (start: ">", fill: blue), stroke: blue))

            //line((2.67, 0), (2.67, 4), mark: (end: ">", fill: black), stroke: 1.5pt)
          },
        )
        content("plot.dp", [$ν_x$], anchor: "north", padding: .1)
        content("plot.dm", [$-ν_x$], anchor: "north", padding: .1)
      },
    )
  ]
]



#question()[

  We defined:
  $
    y(t) = x(t) thin comb_T (t)
  $
  Compute the Fourier transform $hat(y)$ and plot $y$ and  $abs(hat(y))$.
  #solution(lines: 0)[
    Using the property of the Fourier transform of a product of two functions, we have:
    $
      FT{y(t)}(ν) & = FT{x(t) thin comb_T (t)}(ν) \
      & = (hat(x) * FT{comb_T (t)})(ν) \
      & = ((e^(j (ϕ - π/2)))/2 delta(ν - ν_x) - (e^(-j (ϕ - π/2)))/2 delta(ν + ν_x) )* (1/T ∑_(k=-∞)^(+∞) delta(ν - k ν_0)) \
      & = ν_0 ∑_(k=-∞)^(+∞) [ (e^(j (ϕ - π/2)))/2 delta(ν - ν_x - k ν_0) - (e^(-j (ϕ - π/2)))/2 delta(ν + ν_x - k ν_0) ]\
      & = comb_(ν_0)(ν - ν_s) + comb_(ν_0)(ν + ν_s)
    $
    This result indicates that the Fourier transform of the modulated signal $y(t)$ consists of shifted replicas of the original spectrum $hat(x)(ν)$, located at integer multiples of the sampling frequency $ν_0 = 1/T$.


    #let plotsampling(P, T) = {
      let wave(x) = calc.sin(2 * calc.pi * x / P)

      let domain = (-5, 5)


      canvas({
        import draw: *
        plot.plot(
          ..opts,
          size: (14, 2),
          y-min: -1,
          y-max: 1,
          legend: "inner-north",
          axis-style: "school-book",
          x-label: $t$,
          y-label: $y(t)$,
          name: "ploty",
          {
            // plot.sample-fn(calc.sin, (0, 10), 10))
            plot.add(
              wave,
              domain: domain,
              style: (stroke: silver),
              samples: 4
                * int(calc.round(
                  (domain.at(1) - domain.at(0)) * 10,
                )),
            )

            plot.add(
              wave,
              domain: domain,
              style: (stroke: 0pt),
              mark: "*",
              mark-style: (stroke: blue),
              samples: int(calc.round(
                (domain.at(1) - domain.at(0)) / T,
              )),
            )
          },
        )
      })

      canvas({
        import draw: *

        plot.plot(
          ..opts,
          size: (14, 2),
          y-min: -1,
          y-max: 1,
          legend: "inner-north",
          axis-style: "school-book",
          x-label: $ν$,
          y-label: $|hat(y)(ν)|$,
          name: "plot",
          {
            let domain = (-2, 2)
            plot.add(((domain.at(0), 0), (domain.at(1), 0)), domain: domain, style: (stroke: 0pt))


            plot.add(((1 / P, 0), (1 / P, 1)), domain: domain, style: (mark: (end: ">", fill: blue), stroke: blue))
            plot.add-anchor("dp", (1 / P, 0))
            plot.add(((-1 / P, 0), (-1 / P, 1)), domain: domain, style: (mark: (end: ">", fill: blue), stroke: blue))
            plot.add-anchor("dm", (-1 / P, 0))


            plot.add(((1 / T - 1 / P, 0), (1 / T - 1 / P, 1)), domain: domain, style: (
              mark: (end: ">", fill: blue),
              stroke: blue,
            ))
            plot.add-anchor("dp1", (1 / P + 1 / T, 0))
            plot.add(((1 / P + 1 / T, 0), (1 / P + 1 / T, 1)), domain: domain, style: (
              mark: (end: ">", fill: blue),
              stroke: blue,
            ))
            plot.add-anchor("dm1", (-1 / P + 1 / T, 0))

            plot.add(((-1 / T - 1 / P, 0), (-1 / T - 1 / P, 1)), domain: domain, style: (
              mark: (end: ">", fill: blue),
              stroke: blue,
            ))
            plot.add-anchor("dp2", (-1 / T - 1 / P, 0))
            plot.add(((-1 / T + 1 / P, 0), (-1 / T + 1 / P, 1)), domain: domain, style: (
              mark: (end: ">", fill: blue),
              stroke: blue,
            ))
            plot.add-anchor("dm2", (-1 / T + 1 / P, 0))


            plot.add(((-1 / T, 0), (-1 / T, 1)), domain: domain, style: (
              mark: (end: ">", fill: silver),
              stroke: silver,
            ))
            plot.add-anchor("tm", (-1 / T, 0))
            plot.add(((1 / T, 0), (1 / T, 1)), domain: domain, style: (mark: (end: ">", fill: silver), stroke: silver))
            plot.add-anchor("tp", (1 / T, 0))


            //plot.add-vline(min: 0, max: 1, 1, style: (mark: (end: ">", fill: blue), stroke: blue))
            //plot.add-vline(min: -0.5, max: 0, 0.5, style: (mark: (start: ">", fill: blue), stroke: blue))

            //line((2.67, 0), (2.67, 4), mark: (end: ">", fill: black), stroke: 1.5pt)
          },
        )
        content("plot.dp", [$ν_x$], anchor: "north", padding: .1)
        content("plot.dm", [$-ν_x$], anchor: "north", padding: .1)
        content("plot.dp1", [$ν_0 + ν_x$], anchor: "north", padding: .1)
        content("plot.dm1", [$ν_0 -ν_x$], anchor: "north", padding: .1)
        content("plot.dp2", [$-ν_0 + ν_x$], anchor: "north", padding: .1)
        content("plot.dm2", [$-ν_0-ν_x$], anchor: "north", padding: .1)
      })
    }

    #let T = 0.5
    #let P = 4
    #figure(
      plotsampling(P, T),
      caption: [Sampling a periodic signal of period #P with sampling period #T],
    )

    #let T = 1
    #let P = 4
    #figure(
      plotsampling(P, T),
      caption: [Sampling periodic signal with period #P with sampling period #T ],
    )

  ]
]

#question()[
  Redraw the plot when $x$ is a band-limited signal of spectral width $B_s$.
  (#ie  $hat(x)(ν) = 0 text(" if ") abs(ν) > (B_s)/2$)
]


#question()[

  What will happen if $ν_e < B_s$?


  #solution(lines: 0)[
    If the sampling frequency $ν_e$ is less than twice the highest frequency component $ν_x$ of the signal (i.e., $ν_e < 2 ν_x$), aliasing will occur. Aliasing is a phenomenon where higher frequency components of the signal are indistinguishably mapped to lower frequencies in the sampled signal.

    In the frequency domain, this means that the shifted replicas of the original spectrum $hat(x)(ν)$ will overlap. Specifically, the replicas located at $k ν_0 ± ν_x$ for different integer values of $k$ will interfere, causing distortion in the reconstructed signal.

    As a result, when attempting to reconstruct the original signal from its samples, it will not be possible to accurately recover the original frequencies, leading to a loss of information and potential distortion in the signal representation.
  ]

]

The sampling of the signal $y$  is performed by defining $y[k] = y(k thin T)$.

= Reconstructing sampled data

From the samples $y[k]$, we can reconstruct the continuous signal $y(t)$:
$
  y(t) = cases(
    y[t/T] quad & "if" t/T ∈ ZZ thin ",",
    0 quad & "otherwise."
  )
$

From $y(t)$, we obtain a reconstruction $z(t)$ of the original signal $x(t)$ by applying a filter with impulse response $h$:
$
  z(t) = (h * y)(t)
$

#question()[Knowing that $x$ is a band-limited signal of spectral width $B_s$, show that the optimal filter that minimizes the reconstruction error $E = ∫_(−∞)^(+∞) |x(t) − z(t)|^2 dt$ is a cardinal sine.


  #solution(lines: 0)[
    $
      E & = ∫_(−∞)^(+∞) |x(t) − z(t)|^2 dt \
        & = ∫_(−∞)^(+∞) |hat(x)(ν) − hat(h)(ν) thin hat(y)(ν)|^2 dif ν
    $
    The signal $hat(x)(ν)$ is non-zero only on the interval $[-B_s/2, +B_s/2]$.
    $
      E = ∫_(-∞)^(+B_s/2) | hat(h)(ν) thin hat(y)(ν)|^2 dif ν + ∫_(-B_s/2)^(+B_s/2) |hat(x)(ν) − hat(h)(ν) thin hat(y)(ν)|^2 dif ν + ∫_(+B_s/2)^(+∞) | hat(h)(ν) thin hat(y)(ν)|^2 dif ν
    $
    As consequence the error $E$ is minimized when $hat(h)(ν)$ is zero outside the interval $[-B_s/2, +B_s/2]$ and  $hat(x)(ν) = hat(h)(ν) thin hat(y)(ν)$ inside.


    If $ν_0 > B_s$, only a single replica of $hat(x)$ is present in the interval $[-B_s/2, +B_s/2]$ and  $hat(y)(ν)= ν_0 hat(x)(ν)$.

    $
      hat(h)(ν) & =cases(
                    1 quad & "if" abs(ν) ≤ B_s/2 thin ",",
                    0 quad & "otherwise."
                  ) \
                & = "rect"_(B_s)(ν)
    $

    The inverse Fourier transform of the rectangle function is the cardinal sine:
    $
      h(t) & = FT^(-1){hat(h)(ν)}(t) \
           & = B_s thin sinc(B_s thin t)
    $
  ]

  #subquestion(label: "a")[
    Is this filter causal? What are the issues with such filter?

    #solution(lines: 0)[
      This filter is not causal as its impulse response $h(t)$ is non-zero for negative $t$. A causal filter must have an impulse response that is zero for all negative time values, meaning it cannot respond to future inputs.

      The issues with this filter include:
      - Delay: The filter would require knowledge of future input values, preventing real-time processing.
      - Infinite length: The sinc function extends infinitely in both directions, making it impractical to implement in real-world systems where finite-length filters are required.
    ]
  ]
]

#question()[
  We design a filter with the following impulse response:
  $
    g(t) = 1/τ u(t)e^(-t/τ)
  $
  #subquestion(label: "a")[
    Compute the transfer function of this filter $g$.

    #solution(lines: 0)[
      The transfer function $hat(g)(ν)$ of the filter can be computed using the Fourier transform of its impulse response $g(t)$:
      $
        hat(g)(ν) & = ∫_0^(+∞) 1/τ e^(-t/τ) e^(-j thin 2π thin ν thin t) dif t \
                  & = 1/τ ∫_0^(+∞) e^(-t(1/τ + j thin 2π thin ν)) dif t \
                  & = 1/τ [ -1/(1/τ + j thin 2π thin ν) e^(-t(1/τ + j thin 2π thin ν)) ]_0^(+∞) \
                  & = 1/(1 + j thin 2π thin ν thin τ)
      $
    ]
  ]

  #subquestion(label: "b")[
    Compute its squared modulus $abs(hat(g))^2$ and its phase $angle(hat(g))$; plot both quantities:

    #solution(lines: 0)[
      The square modulus of the transfer function $hat(g)(ν)$ is given by:
      $
        |hat(g)(ν)|^2 & = 1/abs(1 + j thin 2π thin ν thin τ)^2 \
                      & = 1/(1 + (2π thin ν thin τ)^2)
      $

      #let τ = 0.2
      #canvas(
        length: 1cm,
        {
          import draw: *

          plot.plot(
            ..opts,
            size: (8, 3),
            x-label: $ν$,
            y-label: $|hat(g)(ν)|^2$,
            x-tick-step: none,
            y-tick-step: none,
            x-min: -3,
            x-max: 3,
            y-min: -0,
            y-max: 1.2,
            mode: "log",
            name: "plot",
            {
              let domain = (-3, 3)

              plot.add(
                ν => 1 / (1 + calc.pow(2 * calc.pi * ν * τ, 2)),
                domain: domain,
                style: (stroke: blue),
              )
            },
          )
        },
      )
      /*
      #canvas(
        length: 1cm,
        {
          import draw: *

          plot.plot(
            ..opts,
            size: (8, 4),
            x-label: $ν$,
            y-label: $angle(hat(g)(ν))$,
            x-tick-step: none,
            y-tick-step: none,
            x-min: -3,
            x-max: 3,
            y-min: -2,
            y-max: 2,

            {
              let domain = (0.001, 3)

              plot.add(
                ν => if (ν > 0) { calc.atan2(1.0, 2 * calc.pi * ν * τ) } else { 0 },
                domain: domain,
                style: (stroke: blue),
              )
            },
          )
        },
      ) */
    ]

    #subquestion(label: "c")[
      What is the cut-off frequency $ν_c$ of $g$:
      $
        |hat(g)(ν_c)|^2 = 1/2
      $

      #solution(lines: 0)[
        The cut-off frequency $ν_c$ of the filter is defined as the frequency at which the square modulus of the transfer function drops to half its maximum value.

        Solving for $ν_c$, we get:
        $
          1/(1 + (2π thin ν_c thin τ)^2) = 1/2 \
          => (2π thin ν_c thin τ)^2 = 1 \
          => ν_c = 1/(2π thin τ)
        $
        Therefore, the cut-off frequency of the filter is $ν_c = 1/(2π thin τ)$.
      ]
    ]

    #subquestion(label: "d")[
      What could be the time constant $τ$ of this filter to reconstruct $x$ from $y$?
      #solution(lines: 0)[
        To effectively reconstruct the original signal $x$ from the sampled signal $y$, the time constant $τ$ of the filter should be chosen such that the cut-off frequency $ν_c$ is greater than or equal to half the bandwidth of the original signal $x$ but smaller than the sampling frequency $ν_e$ to avoid aliasing.

        Given that $x$ is band-limited with spectral width $B_s$, we require:
        $
          B_s/2 < ν_c < ν_e \
          => B_s/2 < 1/(2π thin τ) < ν_e \
          => 1/(2π thin ν_e) < τ < 1/(π thin B_s)
        $
      ]
    ]

  ]
]
