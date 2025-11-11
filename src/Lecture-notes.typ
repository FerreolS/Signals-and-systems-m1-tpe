#import "template.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2": canvas, draw, matrix, vector
#import "@preview/suiji:0.4.0": *
#let rng = gen-rng(42)


#let firstpage = [
  #set par(justify: true)
  This document is written in #link("https://typst.app/docs/", "Typst"). The source files are available on GitHub:
  #link("https://github.com/FerreolS/Signals-and-systems-m1-tpe", "FerreolS/Signals-and-systems-m1-tpe"). Please file an issue or submit a pull request for any typos or misunderstandings.

  //#octique("mark-github")
]

#let abstract = [
  #align(center)[
    #heading(
      outlined: false,
      numbering: none,
      text(0.85em, smallcaps[Avant propos]),
    )
  ]
  #v(0.8em)
  #pad(left: 10%, right: 10%)[
    #set par(justify: true)
    This lecture was initially supposed to be about Data Science. Data science is "a concept to unify statistics, data analysis, informatics, and their related methods" to "understand and analyze actual phenomena with data" #cite(<hayashi1998>). To learn about "data science", it became clear to me that knowledge of basic signal processing concepts is essential. This is why, ultimately, instead of a Data Science course as indicated in your schedule, I propose you an introductory course on signals and systems that will present the essential concepts for any physicist who works with data. Compared to signals and systems courses in engineering curricula, this course will skip some traditionally taught concepts (z-transform, Laplace transform, feedback and control...). To go further, there are many resources such as #cite(<oppenheim1997>) or MIT video lectures #cite(<FreemanLecture>).
  ]
  #v(1.618fr)
]


// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Data Science",
  subtitle: "or rather introduction to signals and systems",
  authors: (
    (name: "Ferréol Soulez", email: "ferreol.soulez@univ-lyon1.fr"),
  ),
  // Insert your abstract after the colon, wrapped in brackets.
  // Example: `abstract: [This is my abstract...]`
  firstpage: firstpage,
  abstract: abstract,
  license: "cc-by-nc-sa",
  date: "Fall 2025",
)


//= Introduction

= Signals & systems


== Signals

A signal represents the variation of a quantity with time or another independent variable, such as space. Signals may describe a wide variety of physical phenomena: #eg, an electrical voltage across a circuit as a function of time $v(t)$, or the light intensity in the plane of a detector $I(x,y)$. Signals are represented mathematically as functions of one or more independent variables.

In this course, for simplicity, we will generally represent a signal as a function of a single variable: time. However, this can easily be generalized to functions of several variables of any physical dimension. For example, in geophysics, a signal can represent variations with latitude, longitude, and depth of quantities such as density, resistivity, #etc


=== Continuous signals
A continuous signal written $x(t)$ also called an analog signal is a function defined for all values of time (possibly in an interval). For example, the fluctuations in the current produced by a coil in an electromagnetic microphone is an continuous signal. Such signals can take any value in a continuous range. #ref(<fig-continuous-signal-a>) shows an example of a continuous signal.

#margin-note[
  //#figure(

  #grid(columns: 2, gutter: 0.6em)[
    #figure(
      canvas(length: 1cm, {
        import draw: *

        let f = 1
        let A = 1
        let samples = 100
        let t-max = 2

        // Draw axes
        line((-t-max - 0.1, 0), (t-max + 0.5, 0), mark: (end: ">"))
        content((t-max + 0.5, -0.3), $t$)

        line((0, -A - 0.5), (0, A + 0.5), mark: (end: ">"))
        content((-0.3, A + 0.5), $x(t)$)

        // Draw the sinusoidal curve
        let prev-point = none
        for i in range(-samples, samples + 1) {
          let t = i / samples * t-max
          //let noise-amp = 0.2 * A
          //let noise = noise-amp * (calc.sin(40 * t) + calc.sin(67 * t + 0.7) + calc.sin(103 * t + 1.9)) / 3
          let x = A * calc.sin(2 * calc.pi * f * t) * calc.exp(-calc.abs(t)) // + noise
          let curr-point = (t, x)

          if prev-point != none {
            line(prev-point, curr-point, stroke: blue + 1.5pt)
          }
          prev-point = curr-point
        }
      }),
      caption: [Continuous signal],
    ) <fig-continuous-signal-a>

    #figure(
      canvas(length: 1cm, {
        import draw: *

        let f = 1
        let A = 1
        let samples = 100
        let t-max = 2

        // Draw axes
        line((-t-max - 0.1, 0), (t-max + 0.5, 0), mark: (end: ">"))
        content((t-max + 0.5, -0.3), $t$)

        line((0, -A - 0.5), (0, A + 0.5), mark: (end: ">"))
        content((-0.3, A + 0.5), $x[t]$)

        // Draw the sinusoidal curve
        let prev-point = none
        for i in range(-samples, samples) {
          let t = i / samples * t-max
          let tr = calc.round(t * 10) / 10
          // let noise-amp = 0.2 * A
          //let noise = noise-amp * (calc.sin(40 * tr) + calc.sin(67 * tr + 0.7) + calc.sin(103 * tr + 1.9)) / 3
          let x = A * calc.sin(2 * calc.pi * f * tr) * calc.exp(-calc.abs(tr)) //+ noise
          let curr-point = (tr, x)
          if prev-point != none {
            if tr == t {
              line((tr, 0), curr-point, stroke: blue + 1.5pt)
            }
          }
          prev-point = curr-point
        }
      }),
      caption: [Discrete signal],
    ) <fig-discrete-signal>
  ]
  #figure(
    canvas(length: 1cm, {
      import draw: *

      let f = 1
      let A = 1
      let samples = 50
      let t-max = 1.5
      let T = 1

      // Draw axes
      line((-t-max - 0.1, 0), (t-max + 0.5, 0), mark: (end: ">"))
      content((t-max + 0.5, -0.3), $t$)

      line((0, -A - 0.5), (0, A + 0.5), mark: (end: ">"))
      content((-0.3, A + 0.5), $x(t)$)

      // Draw the periodic sinusoidal curve
      let prev-point = none
      for i in range(-samples, samples + 1) {
        let t = i / samples * t-max
        let x = A * calc.sin(2 * calc.pi * f * t)
        let curr-point = (t, x)

        if prev-point != none {
          line(prev-point, curr-point, stroke: blue + 1.5pt)
        }
        prev-point = curr-point
      }

      // Draw period indicator
      let y-pos = -A - 0.2
      line((0, y-pos), (T, y-pos), stroke: black + 1pt)
      line((0, y-pos - 0.1), (0, y-pos + 0.1), stroke: black + 1pt)
      line((T, y-pos - 0.1), (T, y-pos + 0.1), stroke: black + 1pt)
      content((T / 2, y-pos - 0.35), $T$)
    }),
    caption: [Periodic signal with period $T$],
  ) <fig-periodic-signal>

  // caption: [Examples of continuous signals],
  //) <fig-continuous-signal>
]



=== Discrete signals
A discrete signal written $x[n]$ is defined only at discrete time intervals $n$.
$x[n]$ is defined only for integer values $n$. It is sometimes refered as a discrete-time sequence.
For example, the daily average temperature measured at a weather station is a discrete signal, as it is only known at specific times (once per day in this case). Discrete signals often also arise from sampling continuous signals at regular intervals.  #ref(<fig-discrete-signal>) shows an example of a discrete signal obtained by sampling the continuous signal presentd #ref(<fig-continuous-signal-a>).

A discrete signal (or discrete time signal) should not be confused with discrete valued signal (which can be either continuous or discrete time). A discrete valued signal also called quantized signal can take only a finite or countable number of values. An example of a discrete valued signal is a digital signal used in digital electronics, which can take only two values (0 and 1).

=== Periodic signals
A periodic signal is a signal that repeats itself at regular intervals over time. A continuous signal $x(t)$ is periodic if there exists a positive $T$ (the period) that satisfies the condition:
#math.equation(
  block: true,
  $x(t) = x(t + T), quad forall t in RR$,
) <eq-continuous-periodic>
In other words, a periodic signal is unchanged by a time shift of $T$. In this case, we say that $x(t)$ is periodic with period $T$. If a signal is periodic of period $T$, any integer multiple $n T$ (for a positive integer $n$) is also a period. The least positive period is called the fundamental period. Often, "the" period of a signal is used to refer to its fundamental period.

Discrete periodic signals are defined analogously. A discrete signal $x[n]$ is periodic if there exists a positive period $N$ where:
#math.equation(
  block: true,
  $x[n] = x[n + N], quad forall n in NN$,
) <eq-discrete-periodic>

#margin-note[
  #figure(
    canvas(length: 1cm, {
      import draw: *

      let f = 1
      let A = 1
      let samples = 50
      let t-max = 2

      // Draw axes
      line((-t-max - 0.1, 0), (t-max + 0.5, 0), mark: (end: ">"))
      content((t-max + 0.5, -0.3), $t$)

      line((0, -A - 0.5), (0, A + 0.5), mark: (end: ">"))
      content((-0.3, A + 0.5), $X_i(t)$)

      // Draw the sinusoidal curve
      let noise = ()
      for c in (blue, red, green) {
        let prev-point = none
        for i in range(-samples, samples + 1) {
          (rng, noise) = normal(rng)
          let t = i / samples * t-max
          let noise-amp = 0.2 * A
          let x = A * calc.sin(2 * calc.pi * f * t) * calc.exp(-calc.abs(t)) + noise-amp * noise
          let curr-point = (t, x)

          if prev-point != none {
            line(prev-point, curr-point, stroke: c + 1.5pt)
          }
          prev-point = curr-point
        }
      }
    }),
    caption: [Three realizations of a non stationnary random signal],
  ) <fig-random-signal>
]
=== Random signals
A random signal $X(t,s)$, also known as a stochastic process, is a function of time (or another variable) whose amplitude at any given time $t$ is a random variable.
It is a set of functions of $t$, the set being indexed by $s$ as illustrated in #ref(<fig-random-signal>). A random signal is thus a bivariate quantity. When $s=s_i$ is fixed, we get a realization of the random process, denoted $X(t,s_i)$ or, more simply, $X_i (t)$. When $t$ is fixed, the random process reduces to a simple random variable. A random signal can be either continuous or discrete in time or value.

A random signal is  *wide-sense stationary* if its mean and auto-covaiance are finite and independent of the choice of the origin of time:
/* #math.equation(
  block: true,
  $&EE[X(t)] = mu , quad forall t in RR \
  &EE[X(t) thin X^*(t + tau)] = gamma_X (tau)$,
)<eq-random-stationnary> */
/* $
  & EE[X^2(t)] < infinity , quad forall t in RR \
  //$<eq-random-stationnary-finite>
  //$
  & EE[X(t)] = mu , quad forall t in RR \
  //$<eq-random-stationnary-mean>
  //$
  & EE[X(t) thin X^*(t + tau)] = gamma_X (tau) , quad forall t in RR .
$<eq-random-stationnary> */
$
  EE[X^2(t)] < infinity , quad forall t in RR
$<eq-random-stationnary-finite>
$
  EE[X(t)] = mu , quad forall t in RR
$<eq-random-stationnary-mean>
$
  EE[X(t) thin X^*(t + tau)] = gamma_X (tau)
$<eq-random-stationnary-correlation>
$gamma_X (tau)$ is the correlation function.


=== Energy
The energy $E$ of a continuous signal $x(t)$ /* in the interval $[t_1, t_2]$ */ is defined as:
/* #math.equation(
  block: true,
  $E = integral_(t_1)^(t_2) |x(t)|^2 dif t$,
) <eq-signal-energy-interval>

 */
$
  E = integral_(-infinity)^infinity |x(t)|^2 dif t
$ <eq-signal-energy>
The unit of energy is the square of the unit of $x(t)$. In this context, this energy is not, strictly speaking, the same as the conventional notion of energy in physics (usually in joules).

For some signals the integral in #ref(<eq-signal-energy>) might not converge: #eg if $x(t)$ or $x[n]$ is periodic. Such signals have infinite energy: $x(t)$ is not a square-integrable function (#ie does not belong to the $L^2$ space).
Signals of finite energy (#ie $E < infinity$) are often called energy signals.

=== Power
Power $P$ of the signal $x(t)$ is defined as the amount of energy per unit time:
#math.equation(
  block: true,
  $lim_(T->infinity) P = 1/(2 T) integral_(-T)^T |x(t)|^2 dif t$,
) <eq-signal-power>
This quantity is useful to work with infinite energy signals. By construction, $P=0$ for energy signals (#ie $E < infinity$).
Signals of non-zero but finite power (#ie $0 < P < infinity$) are often called power signals. Periodic or constant signals are examples of power signals. There are signals, like $x(t) = t$, with infinite power that are neither energy nor power signals.


These quantities are also defined for discrete signals $x[n]$:
$
  E = sum_(n=-infinity)^infinity |x[n]|^2
$<eq-energy-discrete>
$
  P = lim_(N ->infinity) 1/(2N+1) sum_(-N)^N |x[n]|^2
$<eq-power-discrete>

It is important to remember that, in this lecture, the terms "power" and "energy" are used independently of whether these quantities are actually related to physical energy.


//=== Signal power

== Systems<sec-system>

#margin-note[
  #figure(
    diagram(
      node-stroke: 0pt,
      edge-stroke: 1pt,
      node((0, 0), []),
      edge("-|>", [`input`]),
      node((2, 0), [`System`], stroke: 1pt, shape: rect),
      edge("-|>", [`output`]),
      node((4, 0), []),
    ),
    caption: [Block diagram of a system],
  ) <fig-system>
]
A system is a powerful conceptual tool used across a wide range of scientific fields, particularly in physics. In this abstraction, described as a block diagram in @fig-system, a system transforms an input signal into an output signal.
$
  y(t) = S{x(t)}
$

A seismometer is a good example of a system: the physical ground motion $x(t)$ is the input and the seismometer transforms it into an electrical voltage $y(t)$.
The *description* of a system is *arbitrary*, and its inputs/outputs can be defined to facilitate calculations or the understanding of the system. For example, in the case of a seismometer the input can be ground displacement, its velocity, its acceleration, #etc.


=== Properties of systems<sec-system-properties>

/ BIBO Stability: A system is said to be bounded input bounded output (BIBO) stable if the output is bounded for every bounded input to the system.

/ Causality: A system is causal if the output at any time depends only on values of the input at the present time and in the past. If any value of the output signal depends on a future value of the input signal, then the system is non-causal.

/ Linearity: A system is said to be linear if it satisfies the *principle of superposition* (additivity and homogeneity) where for any $(a_1,a_2) in CC^2$:
$
  S{a_1 x_1(t) + a_2 x_2(t)} & = S{a_1 x_1(t) } + S{a_2 x_2(t) } #margin-note[additivity] \
                             & = a_1 S{x_1(t) } +a_2 S{x_2(t) } #margin-note[homogeneity]
$


/ Time invariance: A system is said to be time invariant if its behavior does not change over time. This means delaying the input by some amount simply delays the output by the same amount:
$ y(t + tau) = S{x(t+ tau)} $

=== Modularity
One of the main advantages of this description is that a system is *modular*: it can be decomposed into smaller elementary systems (#eg mass/spring system + transducer + analog to digital converter + #etc) or be included in a larger system (#eg seismic source + propagation medium + array of seismometers + #etc) as illustrated in @fig-seismometer.
#figure(
  text(size: 8pt, diagram(
    label-size: 1pt,
    node-stroke: 0pt,
    edge-stroke: 1pt,
    node((0, 0), align(center)[`Seismic` \ `source`]),
    edge("-|>"),
    node((1, 0), [`Propagation` \ `medium`], stroke: 1pt, shape: rect),
    edge("-|>"),
    node((2, 0), [`transducer`], stroke: 1pt, shape: rect),
    edge("-|>"),
    node((3, 0), [`ADC`], stroke: 1pt, shape: rect),
    edge("-|>"),
    node((4, 0), [`preprocessing`], stroke: 1pt, shape: rect),
    edge("-|>"),
    node((5, 0), [`data`]),
    node(
      enclose: ((2, 0), (3, 0)),
      height: 2cm,
      align(top + center)[`Seismometer`],
      stroke: 1pt,
      shape: rect,
    ),
  )),
  caption: [Seismometer as a modular system],
) <fig-seismometer>


=== Why studying systems?
There are many reasons to describe a problem as a system. Depending on the final goal, one can use this formalism to study:
- *output*: predicting the output from the input given a known system, #eg the _Deep Thought_ supercomputer answering _42_ to the _Ultimate Question of Life, the Universe, and Everything_.
- *system*: characterizing the effect of the system (distortion, attenuation, #etc) on measurements, #eg understanding how the transmission medium is changing communication signals.
- *input*: inferring the input from the output. This is often tackled within an "inverse problem" framework, #eg estimating the position and energy of an earthquake from seismograms, or estimating the question to which the answer is _42_.


#margin-note[
  #figure(
    diagram(
      node-stroke: 0pt,
      edge-stroke: 1pt,
      node((0, 0), $x(t)$),
      edge("-|>"),
      node((1, 0), [`ADC`], stroke: 1pt, shape: rect),
      edge("-|>"),
      node((2, 0), $x[n]$),
    ),
    caption: [Sampling system],
  ) <fig-sampling>
]
=== Signal Sampling
The digitization is the process of converting an analog signal $x(t)$ into a discrete signal $x[n]$, usually done in practice by an analog to digital converter (ADC). The digitization itself is composed of two operations:
- *sampling* that goes from continuous time to discrete time
- *quantization* that goes from continuous value to a finite number of levels

Quantization, being a non-linear operation, will not be treated in this lecture.

The sampling of the function $f(t)$ with the sampling period $T_N$ is given by the equation:
$
  f[n] = integral_(-infinity)^(+infinity) f(t) thin delta(t - n thin T_N) dif t thin ,
$
where $delta$ is the Dirac delta distribution described next section. The condition to perfectly reproduce $f(t)$ from $f[n]$ will be treated in @sec-sampling.




== Dirac delta  function

The Dirac delta  function (or distribution), also known as the unit impulse, is a generalized function on the real numbers, whose value is zero everywhere except at zero, and whose integral over the entire real line is equal to one:
$
  delta(t) = cases(
    +infinity quad & "if" t = 0 thin ",",
    0 quad & "otherwise."
  )
$
such that
$
  integral_(-infinity)^(+infinity) delta(t) dif t = 1
$
It is a generalized function that appears only under an integral. It is often defined as the limit of a sequence of functions, #eg a sequence of Gaussian distributions centered at the origin with variance tending to zero.

=== Properties

/ Translation:
$
  integral_(-infinity)^(+infinity) f(t) thin delta(t - tau) dif t = f(tau)
$
/ Scaling:
$
  delta(a thin t) = 1 / abs(a) delta(t)
$
/ Symmetry: $delta$ is even
$
  delta(t) = delta(-t)
$



=== Heavyside step function

The Heaviside function or unit step function $H(t)$ is a step function defined as:
$
  H(t) = cases(
    0 quad & "if" t < 0 thin ",",
    1 quad & "if" t >= 0 .
  )
$
It is the indicator function of $RR^+$.
Two conventions exist: whether $H(0) = 1$ or $H(0) = 1/2$.
It is related to the Dirac delta function by:
$
  (dif u(t)) / dif t = delta(t)
$


= Linear Time Invariant systems

Among the properties of a system given in @sec-system, linearity and time invariance play a fundamental role in signal and system analysis. First, the linearity and time invariance properties are fortunately shared by numerous physical phenomena. In addition, signal and system analysis provides powerful tools to analyze LTI systems in great detail, going deep into their properties.

The main reason LTI systems can be deeply analyzed is a consequence of the superposition property given in @sec-system-properties:
if we can represent the input to an LTI system in terms of a linear combination of a set of basic signals, we can compute its output as the combination of its responses to these basic signals.

== Linear Systems

== Convolution

=== Properties

= Fourier representation

== Fourier series

== Harmonic Signals

== Linear Time Invariant systems

== Fourier transform

=== Filtering

= Discrete Fourier Transform

== Sampling<sec-sampling>


= Signaux alléatoires


== Definitions



#bibliography("reference.bib", style: "american-geophysical-union")
