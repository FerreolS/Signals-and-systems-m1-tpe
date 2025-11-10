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

== Systems

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

A seismometer is a good example of a system: the physical ground motion $x(t)$ is the input and the seismometer transforms it into an electrical voltage $y(t)$.
The *description* of a system is *arbitrary*, and its inputs/outputs can be defined to facilitate calculations or the understanding of the system. For example, in the case of a seismometer the input can be ground displacement, its velocity, its acceleration, #etc.

One of the main advantages of this description is that a system is *modular*: it can be decomposed into smaller elementary systems (#eg mass/spring system + transducer + analog digital converter + #etc) or be included in a larger system (#eg seismic source + rock medium + array of seismometers #etc).



#figure(
  diagram(
    node-stroke: 0pt,
    edge-stroke: 1pt,
    node((0, 0), [`Ground motion`]),
    edge("-|>", [`input`]),
    node((2, 0), [`Seismometer`], stroke: 1pt, shape: rect),
    edge("-|>", [`output`]),
    node((4, 0), [`Electrical signal`]),
  ),
  caption: [Seismometer as an LTI measurement system],
) <fig-seismometer>




After digitization at sampling period T_s we obtain the discrete record y[n] = y(n T_s).

/*

Practical notes:
- The measured y(t) contains both the true ground motion convolved with the instrument response and sensor/electronic noise.
- Correct interpretation requires deconvolving the instrument response (inverse filtering) or applying the known transfer function in the frequency domain.
- Real instruments have a natural frequency and damping (poles and zeros), limiting the frequency band where the LTI approximation holds.
- Digitization imposes sampling and quantization constraints (aliasing, finite resolution).

Notes:
- "Linear" means superposition holds. "Time-invariant" means a shift in input causes same shift in output.
- "Causal" means output at time t depends only on present and past inputs. "BIBO stable" means bounded input ⇒ bounded output.

 */

== Functions

=== Dirac

=== Heavyside

= Linear Time Invariant systems

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

== Sampling

= Signaux alléatoires


== Definitions



#bibliography("reference.bib", style: "american-geophysical-union")
