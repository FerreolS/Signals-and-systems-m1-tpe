#import "template.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2": canvas, draw, matrix, vector
#import "@preview/suiji:0.4.0": *
#import "@preview/cetz-plot:0.1.3": plot

#let rng = gen-rng(42)
#let opts = (x-tick-step: none, y-tick-step: none, size: (4, 2))



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
A continuous signal, written $x(t)$ and also called an analog signal, is a function defined for all values of time (possibly in an interval). For example, the fluctuations in the current produced by a coil in an electromagnetic microphone form a continuous signal. Such signals can take any value in a continuous range. #ref(<fig-continuous-signal-a>) shows an example.

#margin-note[
  //#figure(

  #grid(columns: 1, gutter: 0.6em)[
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
A discrete signal written $x[n]$ is defined only at discrete time indices $n$ (integers).
It is sometimes referred to as a discrete-time sequence.
For example, the daily average temperature measured at a weather station is a discrete signal, as it is only known at specific times (once per day in this case). Discrete signals often arise from sampling continuous signals at regular intervals.  #ref(<fig-discrete-signal>) shows a discrete signal obtained by sampling the continuous signal presented in #ref(<fig-continuous-signal-a>).

A discrete signal (or discrete time signal) should not be confused with discrete valued signal (which can be either continuous or discrete time). A discrete valued signal also called quantized signal can take only a finite or countable number of values. An example of a discrete valued signal is a digital signal used in digital electronics, which can take only two values (0 and 1).

=== Periodic signals<sec-periodic-signal>
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
)<eq-discrete-periodic>


=== Energy
The energy $E$ of a continuous signal $x(t)$ /* in the interval $[t_1, t_2]$ */ is defined as:
/* #math.equation(
  block: true,
  $E = integral_(t_1)^(t_2) |x(t)|^2 dif t$,
) <eq-signal-energy-interval>

 */
#rect(fill: silver)[$
  E = integral_(-infinity)^infinity |x(t)|^2 dif t
$ <eq-signal-energy>]
The unit of energy is the square of the unit of $x(t)$. In this context, this energy is not, strictly speaking, the same as the conventional notion of energy in physics (usually in joules).

For some signals the integral in #ref(<eq-signal-energy>) might not converge: #eg if $x(t)$ or $x[n]$ is periodic. Such signals have infinite energy: $x(t)$ is not a square-integrable function (#ie does not belong to the $L^2$ space).
Signals of finite energy (#ie $E < infinity$) are often called energy signals.

=== Power
Power $P$ of the signal $x(t)$ is defined as the amount of energy per unit time:
#rect(fill: silver)[
  #math.equation(
    block: true,
    $P = lim_(T->infinity) 1/(2 T) integral_(-T)^T |x(t)|^2 dif t$,
  ) <eq-signal-power>]
This quantity is useful to work with infinite energy signals. By construction, $P=0$ for energy signals (#ie $E < infinity$).

For periodic signals, this amounts to calculating the average power over a single period:
$
  P = 1/T ∫_(t_0)^(t_0 + T) |x(t)|^2 dt thin.
$

Signals of non-zero but finite power (#ie $0 < P < infinity$) are often called power signals. Periodic or constant signals are examples of power signals. There are signals, like $x(t) = t$, with infinite power that are neither energy nor power signals.


These quantities are also defined for discrete signals $x[n]$:
$
  E = sum_(n=-infinity)^infinity |x[n]|^2
$<eq-energy-discrete>
$
  P = lim_(N ->infinity) 1/(2N+1) sum_(n=-N)^N |x[n]|^2
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
  y(t) = H{x(t)}
$

A seismometer is a good example of a system: the physical ground motion $x(t)$ is the input and the seismometer transforms it into an electrical voltage $y(t)$.
The *description* of a system is *arbitrary*, and its inputs/outputs can be defined to facilitate calculations or the understanding of the system. For example, in the case of a seismometer the input can be ground displacement, its velocity, its acceleration, #etc.


=== Properties of systems<sec-system-properties>

/ BIBO Stability: A system is said to be bounded input bounded output (BIBO) stable if the output is bounded for every bounded input to the system.

/ Causality: A system is causal if the output at any time depends only on values of the input at the present time and in the past. If any value of the output signal depends on a future value of the input signal, then the system is non-causal.

/ Linearity: A system is said to be linear if it satisfies the *principle of superposition* (additivity and homogeneity) where for any $(a_1,a_2) in CC^2$:

$
  H{a_1 x_1(t) + a_2 x_2(t)} & = H{a_1 x_1(t) } + H{a_2 x_2(t) } &  text(weight: "bold", "additivity") \
                             & = a_1 H{x_1(t) } +a_2 H{x_2(t) }  & text(weight: "bold", "homogeneity")
$


/ Time invariance: A system is said to be time-invariant if its behavior does not change over time. This means delaying the input by some amount simply delays the output by the same amount:
$ y(t + tau) = H{x(t+ tau)} $

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

== Representation of signals

=== Unit impulse
In discrete time, the unit impulse, also known as the delta function, is the simplest discrete signal.
#rect(fill: silver)[ $
    delta[n] = cases(
      1 quad & "if" n = 0 thin ",",
      0 quad & "otherwise."
    )
  $
]

=== Representation of discrete time signal<sec-representation-discrete>
Any discrete-time signal can be viewed as a sequence of scaled individual unit pulses:
#rect(fill: silver)[$
  x[n] = sum_(k=-infinity)^(+infinity) x[k] thin delta[n-k]
$<eq-discrete-representation>]
This can be used to represent any arbitrary sequence as a linear combination of
shifted unit impulses $delta[n- k]$, where the weights are $x[k]$. This is sometimes called the _sifting property_ of the discrete-time unit impulse, where the impulse acts as a selector preserving only the value corresponding to $k=n$. The impulse functions form a *complete basis set* for discrete-time signals.
The coefficient for each basis function is simply $x[k]$.


=== Dirac delta function
In continuous time we do not have a discrete sequence of values, but we can think of a continuous unit impulse function $delta_{Delta}$ as a pulse of width $Delta$:
$
  delta_(Delta)(t) = cases(
    1/Delta quad & "if" abs(t) < Delta/2 thin ",",
    0 quad & "otherwise."
  )
$<eq-delta-Delta>
/*
We consider  a "staircase" approximation, $x(t)$, to a
continuous-time signal x(t):
$
  tilde(x)(t) & = sum_(k=-infinity)^(+infinity) integral_(- Delta/2)^(Delta/2) x(t - k Delta) dif t \
              & = sum_(k=-infinity)^(+infinity) integral_RR delta_(Delta)(t - k Delta) x(t) dif t
$<eq-staircase>
*/
As $Delta -> 0$, $delta_(Delta)$ approaches the Dirac delta distribution.
The Dirac delta function (or distribution) is a generalized function on the real numbers, whose value is zero everywhere except at zero, and whose integral over the entire real line is equal to one:
#rect(fill: silver)[
  $
    delta(t) = cases(
      +infinity quad & "if" t = 0 thin ",",
      0 quad & "otherwise."
    )
  $
  such that
  $
    integral_(-infinity)^(+infinity) delta(t) dif t = 1
  $]
It is a generalized function that appears only under an integral. It is often defined as the limit of a sequence of functions, such as the sequence defined in @eq-delta-Delta with decreasing $Delta$, or a sequence of Gaussian distributions centered at the origin with variance tending to zero.

With this Dirac delta distribution, similarly to the discrete case @eq-discrete-representation, we can represent any continuous signal as:
#rect(fill: silver)[
  $
    x(t) = integral_(-infinity)^(+infinity) x(tau) thin delta(t - tau) thin dif tau
  $
]
Again this can be viewed as a "weighted sum" of shifted impulses where the weight on the impulse  $delta(t - tau)$ is $x(tau)$. Contrary to the discrete case, the Dirac delta distribution does not, strictly speaking, define a basis of the space of continuous signals as $delta$ itself does not belong to this space.

=== Properties of the Dirac delta distribution

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

The Heaviside function or unit step function $u(t)$ is a step function defined as:
$
  u(t) = cases(
    0 quad & "if" t < 0 thin ",",
    1 quad & "if" t >= 0 .
  )
$
It is the indicator function of $RR^+$.
Two conventions exist: either $u(0) = 1$ or $u(0) = 1/2$.
It is related to the Dirac delta function by:
$
  (dif ) / (dif t) u(t) = delta(t)
$


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

== Sampling
The digitization is the process of converting an analog signal $x(t)$ into a discrete signal $x[n]$, usually done in practice by an analog to digital converter (ADC). The digitization itself is composed of two operations:
- *sampling* that goes from continuous time to discrete time
- *quantization* that goes from continuous value to a finite number of levels

Quantization, being a non-linear operation, will not be treated in this lecture.

The sampling of the function $f(t)$ with the sampling period $Delta$ is given by the equation:
$
  f[n] = integral_(-infinity)^(+infinity) f(t) thin delta(t - n thin Delta) dif t thin ,
$
The condition to perfectly reproduce $f(t)$ from $f[n]$ will be treated in @sec-sampling.


= Linear Time-Invariant Systems

Among the properties of a system given in @sec-system, linearity and time invariance play a fundamental role in signal and system analysis. First, the linearity and time invariance properties are fortunately shared by numerous physical phenomena. In addition, signal and system analysis provides powerful tools to analyze LTI systems in great detail, going deep into their properties.

The main reason LTI systems can be deeply analyzed is a consequence of the superposition property given in @sec-system-properties:
if we can represent the input to an LTI system in terms of a linear combination of a set of basic signals, we can compute its output as the combination of its responses to these basic signals.

== Discrete time LTI systems
As shown in @sec-representation-discrete, a discrete signal $x[n]$ can be represented as a sum of impulses:
$x[n] = sum_k x[k] thin delta[n - k]$.
In this representation, an arbitrary sequence is a linear combination of
shifted unit impulses $delta[n- k]$, where the weights are $x[k]$.

=== Discrete time linear system
If $H$ is a *linear system* then its output $y[n]$ is simply the weighted linear combination of shifted unit impulse responses:
$
  y[n] & = H(x[n])thin, \
       & = H(sum_k x[k] thin delta[n - k]) thin, \
       & = sum_k x[k] thin H(delta[n - k]) thin, \
       & = sum_k x[k] thin h_k [n - k]
$
where $h_k [n] = H(delta[n - k])$ denotes the response of the linear system $H$ to the shifted unit impulse $delta[n - k]$.

In matrix–vector notation we define the input vector $Vx = [x_1, x_2, ..., x_{N-1}]^T$, the output $Vy = [y_0, y_1, ..., y_{M-1}]^T$; the linear system is described by the linear operator (matrix) $M_H$:
$
  Vy & = MH dot Vx
$
$
  vec(y_1, y_2, dots.v, y_(M-1)) & = x_1 vec(h_0[0], h_0[1], dots.v, h_0[N-1])
                                   + x_2 vec(h_1[-1], h_1[0], dots.v, h_1[N-2])
                                   + dots \
                                 & = mat(
                                     h_0[0], h_1[-1], ..., h_N [1-N];
                                     h_0[1], h_1[0], ..., h_N [2-N];
                                     dots.v, dots.v, dots.down, dots.v;
                                     h_0[M-1], h_1[M-2], ..., h_N [M-N];
                                   ) dot vec(x_1, x_2, dots.v, x_(N-1))
$

=== Discrete-Time Linear Time-Invariant System
If the linear system $H$ is also *time-invariant* all $h_k [n]$ are time-shifted versions of a single sequence $h_0[n]$:
$
  h_k [n] = h_0[n - k]
$
Dropping the subscript $0$ for convenience, we define the *impulse response* $h$ of the system:
$
  h[n] = h_0[n]
$
$h[n]$ being the output of the LTI system $H$ to the unit impulse $delta[n]$.

Then for any LTI systems, its output depends only on the input and its impulse response:
$
  y[n] = sum_(k = -infinity)^(+infinity) x[k] thin h[n-k]
$
This is a *convolution sum* or superposition sum, and the operation on the right-hand side is known as the convolution of the sequences x[n] and h[n].  This convolution is denoted with the symbol $*$ as in :
$
  y[n] = (x * h)[n].
$

The convolution matrix is then a band-diagonal matrix:
$
  MH = mat(
    h[0], h[-1], ..., h[1-N];
    h[1], h[0], ..., h[2-N];
    dots.v, dots.v, dots.down, dots.v;
    h[M-1], h[M-2], ..., h[M-N];
  )
$

== Continuous time LTI system

=== Continuous time linear system
Let us define $h(t, tau)$ as the response at time $t$ to a unit impulse $delta(t - tau)$ applied at time $tau$.
Similarly to the discrete case, the output of the system is:
$
  y(t) = integral_(-infinity)^(+infinity) x(tau) thin h(t, tau) dif tau
$<eq-continuous-linear>
If we intuitively think of $x(t)$ as a "sum" of weighted shifted impulses (where
the weight on the impulse $delta(t- tau)$ is $x(tau)$) this @eq-continuous-linear represents
the superposition of the responses to each of these inputs, and by linearity, the weight
on the response $h(t,tau)$ to the shifted impulse $delta(t- tau)$ is also $x(tau)$.

=== Continuous-Time Linear Time-Invariant System
If, in addition to being linear, the system is time-invariant, its response no longer depends on the instant $tau$ where the impulse was applied but only on the time difference $t - tau$:
$
  h (t, tau) = h (t - tau)thin.
$
With this definition, $h(t)$ is the  response of the system to the impulse $delta(t)$, that is the *impulse response* of the system.

For Linear Time-Invariant systems, @eq-continuous-linear becomes the *convolution integral*:
#rect(fill: silver)[$
    y(t) = integral_(-infinity)^(+infinity) x(tau) thin h(t- tau) dif tau
  $<eq-continuous-convolution>
]



== Convolution

The convolution of two functions $f$ and $g$, written $f * g$, is defined as the integral of the product of the two functions after one is reflected and shifted:
#rect(fill: silver)[$
    (f*g)(t) = integral_(-infinity)^(+infinity) f(tau) thin g(t- tau) dif tau
  $<eq-continuous-convolution>
]
This operation is well defined only if $f$ and $g$ decay sufficiently rapidly at infinity so that the integral exists. Existence conditions include:
- $f$ and $g$ have compact support (then $f * g$ exists and also has compact support),
- $f \in L^p$ and $g \in L^q$ with $1 \le 1/p + 1/q \le 2$, ensuring integrability (Young's convolution inequality).

In physics, signals typically have finite energy or power, so these conditions are usually satisfied in practice.


=== Properties of the convolution operation


/ Commutativity:
$
  f * g = g * f
$
/ Associativity:
$
  f * (g * h) = (f * g) * h
$
/ Distributivity:
$
  f * (g + h) = f * g + f * h
$
/ Identity element:
$
  f * delta = f
$
/ Time reversal:
$
  (f * g)(-t) = f(-t) * g(-t)
$
/ Conjugation:
$
  conj(f * g) = conj(f) * conj(g)
$
/ Differentiation:
$
  (dif ) / (dif t) (f * g) = (dif f ) / (dif t) * g = f * (dif g ) / (dif t)
$
/ Integration:
$
  integral_(-infinity)^(+infinity) (f * g)(t) dif t = (integral_(-infinity)^(+infinity) f(t) dif t) thin (integral_(-infinity)^(+infinity) g(t) dif t)
$
/ Green's function $G$ of a system with impulse response $h$:
$
  h * G = delta quad text("by definition")
$

=== Eigenfunctions of an LTI system
An eigenfunction is a function $f$ for which the output of the operator is the same function scaled by some constant:
$
  H{f} = lambda f thin,
$
where $lambda$ is the eigenvalue (a constant).

Complex exponential functions are eigenfunctions of any LTI system. That is, when a complex exponential is applied as input to an LTI system, the output is simply a scaled version of the input:
#rect(fill: silver)[$
    h * e^(j omega t) = lambda thin e^(j omega t)
  $<eq-lti-eigenfunctions>
]
Demonstration
#math.equation(
  block: true,
  $
    h * e^(j omega t) &= integral_RR h(tau) thin e^(j omega (t - tau)) thin dif tau \
    &= integral_RR h(tau) thin e^(j omega t) thin e^(-j omega tau) thin dif tau \
    &= underbrace(e^(j omega t), text("eigen")\ text("function")) thin underbrace(integral_RR h(tau) thin e^(-j omega tau) thin dif tau, lambda text("(scalar)"))
  $,
)
This property is extremely important because the effect of an LTI system on a linear combination of complex exponentials is, thanks to the superposition property, the same complex exponentials weighted by the eigenvalues $lambda$ that can be computed independently once and for all.

If we can decompose any input signal as a sum of complex exponentials, then computing the output of any LTI system is trivial:
#math.equation(
  block: true,
  numbering: none,
  $
    h *(a_1 e^(j omega_1 t) + a_2 e^(j omega_2 t)) &= a_1 thin h * e^(j omega_1 t) + a_2 thin h * e^(j omega_2 t)\
    &=a_1 thin lambda_1 thin e^(j omega_1 t) + a_2 thin lambda_2 thin e^(j omega_2 t).
  $,
)
with
#math.equation(
  block: true,
  numbering: none,
  $
    lambda_1 & = integral_RR h(tau) thin e^(-j omega_1 tau) thin dif tau \
    lambda_2 & = integral_RR h(tau) thin e^(-j omega_2 tau) thin dif tau
  $,
)


= Fourier Series

To use the fact that complex exponentials are eigenfunctions of LTI systems, one has to decompose the input signal into complex exponentials. First, we will see that any periodic signal can be decomposed as a sum of complex exponentials via Fourier series; then we will extend to aperiodic signals (using the Fourier transform).

== Harmonic Signals

As stated in @sec-periodic-signal, a signal is periodic if for some $T>0$:
$
  x(t) = x(t + T), quad forall t in RR .
$


A complex exponential $e^(j omega t)$ is periodic of period $T$ if and only if
#math.equation(
  block: true,
  $
        & e^(j omega t) & = & e^(j omega (t +T)) \
        &               & = & e^(j omega t) e^(j omega T) \
    <=> & e^(j omega T) & = & 1 \
    <=> & omega         & = & n thin (2 pi) / T, quad forall n in ZZ
  $,
)
Every  signal $x(t)$ that is linear combination of complex exponentials, periodic of period $T$ can be expressed as:
$
  x(t) = sum_(k=-infinity)^(+infinity) a_k e^(j k thin omega_0 ),
$<eq-harmonic>
where $omega_0 = (2 pi) / T$ is the fundamental frequency (or pulsation). This @eq-harmonic is referred to as the synthesis equation. The signal $x$ is a *harmonic signal* with frequencies that are integer multiples of the fundamental frequency $omega_0$ (the harmonics). The coefficients $a_k = rho_k thin e^(j thin phi_k)$ are complex and can also be expressed in terms of phase and amplitude. The component $a_0$ corresponding to the mean of $x$ is sometimes called the DC component.

=== Real harmonic signal
/* Real harmonic signals are the real part of complex harmonic signals:
#math.equation(
  block: true,
  $
    x(t) & =sum_(k=-infinity)^(+infinity) Re(a_k e^(j k thin omega_0 )).
    //       & = sum_(k=-infinity)^(+infinity) b_k cos(k thin omega_0),
  $,
) */
#margin-note(rect(fill: silver)[
  #align(center)[*Euler formulae*]
  #math.equation(
    block: true,
    numbering: none,
    $
      cos(theta) & = (e^(j thin theta) + e^(-j thin theta) )/2 \
      sin(theta) & = (e^(j thin theta) - e^(-j thin theta) )/(2j)
    $,
  )])
Using Euler formula and defining  $a_k = b_k + j c_k$, we can rewrite @eq-harmonic:
#math.equation(
  block: true,
  numbering: none,
  $
    x(t) // = &sum_(k=-infinity)^(+infinity)( Re(a_k) e^(j k thin omega_0 ) + j thin Im(c_k) e^(j k thin omega_0 )), \
    = & a_0 + sum_(n=1)^(+infinity)( a_n e^(j n thin omega_0 ) + a_(-n) e^(-j n thin omega_0 )) \
    = & a_0 + sum_(n=1)^(+infinity) ((a_n + a_(-n))/2 cos(n thin omega_0) - j (a_n - a_(-n))/(2) sin(n thin omega_0)) \
    = & a_0 + sum_(n=1)^(+infinity) ((Re(a_n) + Re(a_(-n)))/2 cos(n thin omega_0) + (Im(a_n) - Im(a_(-n)))/(2) sin(n thin omega_0)) \
    & + j sum_(n=1)^(+infinity)( (Im(c_n) + Im(c_(-n)))/2 cos(n thin omega_0) - (Re(c_n) - Re(c_(-n)))/2 sin(n thin omega_0))
    //       & = sum_(k=-infinity)^(+infinity) b_k cos(k thin omega_0),
  $,
)

Real harmonic signals are  complex harmonic signals with zero imaginary part:
#math.equation(
  block: true,
  $
    x(t) & =sum_(k=-infinity)^(+infinity) Re(a_k e^(j k thin omega_0 )), &\
    & = a_0 + sum_(n=1)^(+infinity) ((Re(a_n) + Re(a_(-n)))/2 cos(n thin omega_0) + (Im(a_n) - Im(a_(-n)))/(2) sin(n thin omega_0)) &\
    & = a_0 + sum_(n=1)^(+infinity) b_n cos(n thin omega_0) + c_n sin(n thin omega_0)) & \
    & = a_0 + sum_(n=1)^(+infinity) rho_n cos(n thin omega_0 + phi_n) &
  $,
)
where we define:
$
    b_n & =(Re(a_n) + Re(a_(-n)))/2    &                                                  \
    c_n & = (Im(a_n) - Im(a_(-n)))/(2) &                                                  \
  rho_n & = sqrt(b_n^2 + c_n^2)        & text(weight: "bold", "cartesian representation") \
  phi_n & = arctan(c_n/b_n)            &     text(weight: "bold", "polar representation") \
    a_n & = cases(
            1/2 (b_n - j thin c_n) quad & "if" n < 0 thin ",",
            a_n quad & "if" n = 0 thin ",",
            1/2 (b_n + j thin c_n) quad & "if" n > 0 thin ".",
          )                            &
$
$b_n$ and $c_n$ will describe the even and odd components of $x$ respectively.


== Fourier Series Representation of Continuous Periodic Signals
<sec-FourierSeries-continuous>

The idea of decomposing any periodic function into the sum of simple oscillating functions was initially  proposed by Fourier in 1807. He stated that any periodic function $x(t)$ of period $T$ can be represented as a sum of complex exponentials of frequencies that are integer multiples of the fundamental frequency $omega_0 = (2 pi) / T$ as in the synthesis @eq-harmonic.

To determine Fourier coefficients $a_k$ from any periodic function $x(t)$ of period $T$ we will use two properties of periodic signal:
- the integration of a periodic signal $x$ over any interval of length equals to its period $T$ is:
$
  integral_(T) x(t) thin dif t = integral_(t_0)^(t_0+T) x(t) thin dif t, quad forall t in RR.
$
- the integral of a complex exponential over a period $T$ is zero  excepted for $k=0$:
#math.equation(
  block: true,
  $
    1/T integral_T e^(-j k thin omega_0 t) thin dif t & = cases(
                                                          1 quad k=0,
                                                          0 quad text("otherwise")
                                                        ) \
                                                      & = delta[k]
  $,
)


If any periodic signal $x(t)$ can be expressed as a weighted sum of complex exponentials thanks to the synthesis @eq-harmonic, then we can compute its correlation with a complex exponential of frequency $k omega_0$ for any $k in ZZ$ as follows:
#math.equation(
  block: true,
  numbering: none,
  $
    1/T integral_T x(t) thin e^(-j k thin omega_0 t) thin dif t & = 1/T integral_T sum_(ell=-infinity)^(+infinity) a_ell thin e^(j ell thin omega_0 t) thin e^(-j k thin omega_0 t) thin dif t, \
    & = 1/T integral_T sum_(ell=-infinity)^(+infinity) a_ell thin e^(j (ell - k) thin omega_0 t) thin dif t, \
    & = 1/T sum_(ell=-infinity)^(+infinity) integral_T a_ell thin e^(j (ell - k) thin omega_0 t) thin dif t, \
    & = a_ell thin delta[ell - k],\
    & = a_k
  $,
)

This defines the #emph("analysis–synthesis") set of equations of the Fourier series:
#rect(fill: silver)[
  $
    hat(x)_k & = 1/T ∫_(t_0)^(t_0 + T) x(t) thin e^(-j k thin omega_0 t) thin dif t, & text(weight: "bold", "    analysis") \
    //#label("eq-fourier-analysis") \
    x(t) & = ∑_(k=-∞ )^(+∞) a_k e^(j k thin ω₀). & text(weight: "bold", "    synthesis") // #label("eq-fourier-synthesis")
  $
]
Depending on the field, the Fourier series coefficients $hat(x)_k$ can also be denoted $hat(x)[k]$ or $X[k]$.


== Convergence of Fourier Series
<sec-FourierSerie-Convergence>
/*
#margin-note[
  #figure(
    canvas(
      length: 1cm,
      {
        import draw: *
        let order = 50
        let f = 0.4
        let A = 1
        let samples = 150
        let t-max = 2

        // Draw axes
        line((-t-max - 0.1, 0), (t-max + 0.5, 0), mark: (end: ">"))
        content((t-max + 0.5, -0.3), $t$)

        line((0, -A - 0.5), (0, A + 0.5), mark: (end: ">"))
        content((-0.3, A + 0.5), $x_i(t)$)


        let prev-point = none
        for i in range(-samples, samples + 1) {
          let t = i / samples * t-max
          let x = A * sign(calc.sin(2 * calc.pi * f * t))
          let curr-point = (t, x)
          if prev-point != none {
            line(prev-point, curr-point, stroke: 1.1pt)
          }
          prev-point = curr-point
        }

        let prev-point = none
        for i in range(-samples, samples + 1) {
          let t = i / samples * t-max
          let x = 0 // 4 / calc.pi * calc.sin(2 * calc.pi * f * t)
          for k in range(1, order) {
            if calc.odd(k) {
              x += A * 4 / calc.pi / k * calc.sin(2 * k * calc.pi * f * t)
            }
          }
          let curr-point = (t, x)
          if prev-point != none {
            line(prev-point, curr-point, stroke: blue + 1.1pt)
          }
          prev-point = curr-point
        }
      },
    ),
    caption: [Gibbs phenomena],
  ) <fig-gibbs>
]

 */

#margin-note[

  #let f = 0.4
  #let A = 1
  #let samples = 150
  #let t-max = 2
  #let square(x) = A * sign(calc.sin(2 * calc.pi * f * x))
  #let square_serie(x, order: 5) = {
    let y = 0
    for k in range(1, order + 1) {
      if calc.odd(k) {
        y += A * 4 / calc.pi / k * calc.sin(2 * k * calc.pi * f * x)
      }
    }
    return y
  }
  #figure(
    canvas(
      length: 1cm,
      {
        import draw: *

        plot.plot(
          ..opts,
          x-format: plot.formats.multiple-of,
          y-min: -1.5,
          y-max: 1.5,
          legend: "inner-north",
          axis-style: "school-book",
          {
            let domain = (-t-max, +t-max)
            plot.add(square, samples: samples, domain: domain, style: (stroke: black))
            plot.add(x => square_serie(x, order: 1), samples: samples, domain: domain, style: (stroke: blue))
            plot.add(x => square_serie(x, order: 3), samples: samples, domain: domain, style: (stroke: red))
            plot.add(x => square_serie(x, order: 5), samples: samples, domain: domain, style: (stroke: green))
            // plot.add(x => square_serie(x, order: 100), samples: samples * 10, domain: domain, style: (stroke: silver))
          },
        )
      },
    ),
    caption: [eq-fourier-transform-synthesis ($N=1,3,5$) orders of the Fourier series of a square wave],
  ) <fig-square>

  #figure(
    canvas(
      length: 1cm,
      {
        import draw: *

        plot.plot(
          ..opts,
          x-format: plot.formats.multiple-of,
          y-min: -1.5,
          y-max: 1.5,
          legend: "inner-north",
          axis-style: "school-book",
          {
            let domain = (-0.75, 1.5)
            plot.add(square, samples: samples, domain: domain, style: (stroke: black))
            plot.add(
              x => square_serie(x, order: 50),
              samples: samples * 10,
              domain: domain,
              style: (stroke: blue + 0.5pt),
            )
            plot.add-anchor("pt", (1, 1))
          },
        )
      },
    ),
    caption: [Gibbs phenomena  on the Fourier series (order $N=50$) of a square wave],
  ) <fig-gibbs>
]

The question of the convergence of Fourier series, #ie does all periodic function can be represented by its Fourier series?, was only solved by Dirichlet in 1829. He showed that the Fourier series of a periodic function $x(t)$ converges to $x(t)$ at all points where $x$ is continuous and to the average of the left-hand and right-hand limits at points of discontinuity, provided that:
- $x(t)$ is absolutely integrable over a period, #ie $integral_(T) abs(x(t)) thin dif t < infinity$
- $x(t)$ has a finite number of maxima and minima in any given period,
- $x(t)$ has a finite number of discontinuities in any given period.


The point-wise convergence is only _almost everywhere_, meaning that the Fourier series may not converge to $x(t)$ for some points, #ie at discontinuities. Indeed, a truncated Fourier series approximation of a discontinuous signal will in general exhibit high-frequency ripples and overshoot x(t) near the discontinuities. These ripples, known as _Gibbs phenomena_, are present no matter how large the approximation order, as seen in @fig-gibbs (at least $9%$ overshoot for a unit square wave). However, large enough approximation order can always be chosen so as to guarantee that the total energy in these ripples is insignificant.
$
  lim_(N->+infinity) integral_T abs(x(t) - sum_(k=-N)^(k=+N) hat(x)_k thin e^(j thin k thin omega_0 thin t))^2 dif t = 0
$

/*
However, the Fourier series of a periodic function $x(t)$ converges to $x(t)$ in the mean square sense if $x(t)$ is square integrable over a period, #ie $integral_(T) abs(x(t))^2 thin dif t < infinity$. */




== Orthonormal basis of harmonic signals space
The space of square-integrable periodic functions on the period $[0,T]$ forms the Hilbert space $L^2([0,T])$. This space is equipped with the inner product:
$ inner(f, g) = 1/T integral_0^T f(t) thin overline(g(t)) thin dif t, $<eq-inner-product>
where $overline(g(t))$  is the complex conjugate of $g(t)$. This inner product induces the norm:
$
  norm(f) = sqrt(inner(f, f))
$

The scalar product between two complex exponentials is:
#math.equation(
  block: true,
  $
    < e^(j k thin omega_0 ),e^(j ell thin omega_0 )> & = 1/T integral_0^T e^(j k thin omega_0 ) thin e^(-j ell thin omega_0 ) thin dif t,\
    & = 1/T integral_0^T e^(j (k- ell) thin omega_0 ) thin dif t \
    & = delta[k -ell]
  $,
)
That means that ${e^(j k thin omega_0 ) thick : thick k in ZZ}$ forms an *orthonormal basis* of  $L^2([0,T])$.  In other words, any square-integrable periodic function can be represented as a Fourier series as defined by the analysis-synthesis equations above.

== Parseval theorem

The Parseval theorem states that the energy of a signal $x(t)$ over a period $T$ is equal to the sum of the squared magnitudes of its Fourier series coefficients:

#rect(fill: silver)[$
  1/T ∫_0^T abs(x(t))^2 thin dif t = ∑_(k=-∞)^(k=+∞) abs(hat(x)_k)^2
$ <eq-Parseval-series>]

Demonstration:
#math.equation(
  block: true,
  numbering: none,
  $
    1/T ∫_0^T abs(x(t))^2 thin dif t & = 1/T integral_0^T x(t) thin conj(x)(t) thin dif t \
    & = 1/T integral_0^T ∑_(k=-∞)^(k=+∞) hat(x)_k thin e^(j thin k thin ω_0 thin t) conj(∑_(k=-∞)^(k=+∞) hat(x)_k thin e^(j thin k thin ω_0 thin t)) thin dif t \
    & = 1/T integral_0^T ∑_(k=-∞)^(k=+∞) hat(x)_k thin e^(j thin k thin ω_0 thin t) ∑_(k=-∞)^(k=+∞) conj(hat(x)_k) thin e^(-j thin k thin ω_0 thin t) thin dif t \
    & = 1/T ∑_(k=-∞)^(k=+∞) ∑_(k'=-∞)^(k'=+∞) ∫_0^T hat(x)_k conj(hat(x)_k') thin e^(j thin (k - k') thin ω_0 thin t) thin dif t \
    & =1/T ∑_(k=-∞)^(k=+∞) ∑_(k'=-∞)^(k'=+∞) hat(x)_k conj(hat(x)_k')thin T thin δ[k-k'] \
    & = ∑_(k=-∞)^(k=+∞) abs(hat(x)_k)^2
  $,
)


== Properties of Fourier Series
<sec-FSeries-properties>

/ Linearity:
$
  z(t) = a thin x(t) + b thin y(t) <=> hat(z)_k = a thin hat(x)_k + b thin hat(z)_k
$
/ Time Shifting:
$
  y(t) = x(t - t_0) <=>hat(y)_k = e^(j thin k thin ω_0 thin t_0) hat(x)_k
$
/ Time reversal:
$
  y(t) = x(-t) <=> hat(y)_k = hat(x)_(-k)
$
/ Frequency Shifting:
$
  y(t) = e^(j thin k_0 thin omega_0 thin t) thin x(t) <=> hat(y)_k = hat(x)_(k - k_0)
$
/ Scaling:
$
  y(t) = x(a thin t) <=> hat(y)_k = 1/abs(a) hat(x)[k / a]
$
/ Multiplication:
$
  z(t) = x(t) thin y(t) <=> hat(z)_k = sum_(ell=-infinity)^(+infinity) hat(x)_ell thin hat(y)_(k - ell)
$
/ Conjugation:
$
  y(t) = conj(x(t)) <=> hat(y)_k = conj(hat(x)_(-k))
$
/ Differentiation:
$
  y(t) = (dif x(t)) / (dif t) <=> hat(y)_k = j thin k thin omega_0 thin hat(x)_k
$
/ Symmetry for real signals:
$
  x(t) in RR <=> hat(x)_(-k) = conj(hat(x)_k)
$
/ Even  real signals:
$
  x(t) = x(-t) in RR <=> hat(x)_k in RR
$
/ Odd  real signals:
$
  x(t) = -x(-t) in RR <=> hat(x)_k in j thin RR
$



== Fourier Series Representation of Discrete Periodic Signals

From @eq-discrete-periodic, a discrete time  signal is periodic with  period $N$ if:
#math.equation(
  block: true,
  $x[n] = x[n + N], quad forall n in NN$,
)<eq-discrete-periodic2>
The fundamental frequency is $ω_0 = (2 π)/ N$ is defined from the fundamental period $N$, the smallest integer for which the    @eq-discrete-periodic2 holds.

The set of all discrete time complex exponentials that are periodic with period $N$ is finite and given by:
$
  { e^(j thin ω_0 thin k thin n) thick : thick k = 0, 1, ..., N-1 }
$
as for any $k>=N$ or $k<0$:
$
  e^(j thin ω_0 thin k thin n) = e^(j thin ω_0 (k mod N) thin n)
$

=== Analysis-Synthesis Equations
As for continous-time signal described @sec-FourierSeries-continuous, any discrete periodic signal $x[n]$ of period $N$ can be expressed as a weighted sum of these complex exponentials. The  analysis synthesis equation for discrete-time Fourier series are:
#rect(fill: silver)[
  $
    hat(x)[k] & = 1/N ∑_(n=1)^(N) x[n] thin e^(-j thin omega_0 thin k thin n ), &  text(weight: "bold", "    analysis") \
    //#label("eq-fourier-analysis") \
         x[n] & = ∑_(k=1)^(N) hat(x)[k]thin e^(j thin ω_0 thin k thin n).       & text(weight: "bold", "    synthesis") // #label("eq-fourier-synthesis")
  $
]
In these equations, the limits of the summation can be any contigous
range in $NN$ (#eg $k=0,1,dots,N-1$ or $k= 1,2,dots,N$).


=== Parseval Theorem
The Parseval theorem holds equivalently in discrete-time:
#rect(fill: silver)[$
    ∑_(n=1)^(n=N) abs(x[n])^2 = ∑_(k=1)^(k=N) abs(hat(x)[k])^2
  $ <eq-Parseval-series>
]



=== Properties of Discrete Time Fourier Series
The properties of Fourier series decomposition for discrete time signal are similar to the continuous signal ones described in @sec-FSeries-properties.

#show table.cell: set text(size: 10pt)
#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    stroke: 0.5pt + silver,
    table.header([*Property*], [*Time Domain*], [*Frequency Domain*]),
    [Linearity], $z[n] = a thin x[n] + b thin y[n]$, $hat(z)[k] = a thin hat(x)[k] + b thin hat(y)[k]$,

    [Time Shifting], $y[n] = x[n - n_0]$, $hat(y)[k] = e^(-j thin omega_0 thin k thin n_0) hat(x)[k]$,

    [Time Reversal], $y[n] = x[-n]$, $hat(y)[k] = hat(x)[-k]$,

    [Frequency Shifting], $y[n] = e^(j thin omega_0 thin k_0 thin n) thin x[n]$, $hat(y)[k] = hat(x)[k - k_0]$,

    [Multiplication], $z[n] = x[n] thin y[n]$, $hat(z)[k] = sum_(ell=0)^(N-1) hat(x)[ell] thin hat(y)[k - ell]$,

    [Conjugation], $y[n] = conj(x[n])$, $hat(y)[k] = conj(hat(x)[-k])$,

    [First Difference], $y[n] = x[n] - x[n-1]$, $hat(y)[k] = (1 - e^(-j thin omega_0 thin k)) hat(x)[k]$,

    [Symmetry ], $x[n] in RR$, $hat(x)[-k] = conj(hat(x)[k])$,

    [Even Real Signals], $x[n] = x[-n] in RR$, $hat(x)[k] in RR$,

    [Odd Real Signals], $x[n] = -x[-n] in RR$, $hat(x)[k] in j thin RR$,
  ),
  caption: [Properties of Discrete Time Fourier Series],
)<table-discrete-fourier-properties>

= Fourier transform

As complex exponentials are eigen functions of  LTI  systems (see @eq-lti-eigenfunctions), the Fourier series decomposition of the output signal $y$ of an LTI of impulse response $h$ can be easyly computed from the Fourier series representation of the input signal $x$:
#math.equation(
  block: true,
  $y(t) &= h * x \
  &= h * (∑_(k=-∞)^(+∞) hat(x)_k thin e^(j thin ω_0 thin k thin t)),\
  & = ∑_(k=-∞)^(+∞) hat(x)_k thin (h * e^(j thin ω_0 thin k thin t)), \
  & = ∑_(k=-∞)^(+∞) hat(x)_k thin λ_k thin e^(j thin ω_0 thin k thin t), \
  hat(y)_k &= hat(x)_k lambda_k$,
)
with
$
  λ_k = integral_RR h(tau) thin e^(-j thin omega_0 thin k thin tau) thin dif tau
$<eq-λ>
The operation on the right-hand side of @eq-λ is  Fourier transform of the impulse response $h$ taken at frequency $ω = k thin ω_0$.


== Fourier transform of Continuous Signals
The Fourier transform can be derived from the Fourier series representation of periodic signals by considering the limit when the period $T$ tends to infinity. In this case, the fundamental frequency $ω_0 = (2 π) / T$ tends to zero and the frequencies $k thin ω_0$ become continuous over the real line $RR$.

/*
The Fourier series synthesis equation thus becomes:
#math.equation(
  block: true,
  numbering: none,
  $
    x(t) & = sum_(k=-infinity)^(+infinity) hat(x)[k] thin e^(j thin k thin omega_0 thin t) \
    & = sum_(k=-infinity)^(+infinity) hat(x)[k thin omega_0] thin omega_0 thin e^(j thin k thin omega_0 thin t) / omega_0 \
    & = integral_RR hat(x)(omega) thin e^(j thin omega thin t) thin dif omega
  $,
)
with
$ hat(x)(omega) = 1/(2 pi) integral_RR x(t) thin e^(-j thin omega thin t) thin dif t $
 */This defines the Fourier transform pair in angular frequency $ω$:
#rect(fill: silver)[
  $
    hat(x)(omega) & = 1/(2 pi) integral_RR x(t) thin e^(-j thin omega thin t) thin dif t, & text(weight: "bold", "    Forward transform") \
    //#label("eq-fourier-transform-analysis") \
    x(t) & = integral_RR hat(x)(omega) thin e^(j thin omega thin t) thin dif omega. & text(weight: "bold", "    Inverse transform") // #label("eq-fourier-transform-synthesis")
  $
]
or equivalently in ordinary frequency $ν$:
#rect(fill: silver)[
  $
    hat(x)(ν) & = ∫_RR x(t) thin e^(-j thin 2π thin ν thin t) thin dif t, & text(weight: "bold", "    Forward transform") \
    //#label("eq-fourier-transform-analysis") \
    x(t) & = ∫_RR hat(x)(ν) thin e^(j thin 2 π thin ν thin t) thin dif omega. & text(weight: "bold", "    Inverse transform") // #label("eq-fourier-transform-synthesis")
  $
]
The angular frequency Fourier transform can be made unitary as:
#rect(fill: silver)[
  $
    hat(x)(omega) & = 1/sqrt(2 pi) integral_RR x(t) thin e^(-j thin omega thin t) thin dif t, & text(weight: "bold", "    Forward transform") \
    //#label("eq-fourier-transform-analysis") \
    x(t) & = 1/sqrt(2 pi) integral_RR hat(x)(omega) thin e^(j thin omega thin t) thin dif omega. & text(weight: "bold", "    Inverse transform") // #label("eq-fourier-transform-synthesis")
  $
]

For periodic function of period $T$, the Fourier transform is defined only at discrete frequencies $ν = k/T$ with $k in ZZ$ and is related to the Fourier series coefficients as:
$
  hat(x)( ν) = ∑_(k=-∞)^(+∞) hat(x)_k thin δ(ν - k/T )thin .
$

== Convergence of Fourier transform

If  $x(t)$ is  square integrable over $RR$, #ie $integral_RR abs(x(t))^2 thin dif t < infinity$, then its Fourier transform exists and $hat(x)(omega)$ is also square integrable over $RR$.
As in physics, many signal are of finite energy then  this condition holds in many application involving physical quantities.

For periodic signals, the Fourier transform of a signal $x(t)$ exists under the same Dirichlet conditions stated in #ref(<sec-FourierSerie-Convergence>), which require that:
- $x(t)$ is absolutely integrable over $RR$, #ie $integral_RR abs(x(t)) thin dif t < infinity$. //In this case, the Fourier transform $hat(x)(omega)$ is bounded and continuous.
- $x(t)$ is of bounded variation (#ie there is finite number of maxima and minima within finite interval)
- x(t) have a finite number of discontinuities within finite interval.

== Plancherel-Parseval theorem
The Plancherel-Parseval theorem states that the total energy of a signal $x(t)$ is equal to the total energy of its Fourier transform $hat(x)(ν)$:
#rect(fill: silver)[$
  ∫_RR x(t)thin conj(y(t)) dif t & = ∫_RR hat(x)(ν) thin conj(hat(y)(ν))dif ν & quad text(weight: "bold", "inner product") \
  ∫_RR abs(x(t))^2 dif t & = ∫_RR abs(hat(x)(ν))^2 dif ν & quad text(weight: "bold", "energy preservation")
$ <eq-Parseval-transform>]
Demonstration:
#math.equation(
  block: true,
  numbering: none,
  $
    ∫_RR abs(x(t))^2 dif t & = ∫_RR x(t) thin conj(x(t)) thin dif t \
    & = ∫_RR x(t) thin conj(∫_RR hat(x)(ν) thin e^(j thin 2 π thin ν thin t) thin dif ν) thin dif t \
    & = ∫_RR x(t) thin ∫_RR conj(hat(x)(ν)) thin e^(-j thin 2 π thin ν thin t) thin dif ν thin dif t \
    & = ∫_RR ∫_RR x(t) thin conj(hat(x)(ν)) thin e^(-j thin 2 π thin ν thin t) thin dif t thin dif ν \
    & = ∫_RR conj(hat(x)(ν)) thin (∫_RR x(t) thin e^(-j thin 2 π thin ν thin t) thin dif t) thin dif ν \
    & = ∫_RR abs(hat(x)(ν))^2 thin dif ν
  $,
)

== Convolution theorem
The convolution theorem states that the Fourier transform of the convolution of two signals is equal to the product of their Fourier transforms:
#rect(fill: silver)[$
  z(t) = x(t) * y(t) <=> hat(z)(ν) = hat(x)(ν) thin hat(y)(ν)
$ <eq-convolution-theorem>]
Demonstration:
#math.equation(
  block: true,
  numbering: none,
  $
    hat(z)(ν) & = ∫_RR z(t) thin e^(-j thin 2 π thin ν thin t) thin dif t \
    & = ∫_RR (∫_RR x(τ) thin y(t - τ) thin dif τ) thin e^(-j thin 2 π thin ν thin t) thin dif t \
    & = ∫_RR ∫_RR x(τ) thin y(t - τ) thin e^(-j thin 2 π thin ν thin t) thin dif τ thin dif t \
    & = ∫_RR x(τ) thin (∫_RR y(t - τ) thin e^(-j thin 2 π thin ν thin t) thin dif t) thin dif τ \
    & = ∫_RR x(τ) thin (∫_RR y(u) thin e^(-j thin 2 π thin ν thin (u + τ)) thin dif u) thin dif τ \
    & = ∫_RR x(τ) thin e^(-j thin 2 π thin ν thin τ) thin (∫_RR y(u) thin e^(-j thin 2 π thin ν thin u) thin dif u) thin dif τ \
    & = hat(x)(ν) thin hat(y)(ν)
  $,
)


== Properties of the continuous Fourier transform
<sec-FT-properties>

#show table.cell: set text(size: 10pt)
#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    stroke: 0.5pt + silver,
    table.header([*Property*], [*Time Domain*], [*Frequency Domain*]),
    [Linearity], $z(t) = a thin x(t) + b thin y(t)$, $hat(z)(ν) = a thin hat(x)(ν) + b thin hat(y)(ν)$,

    [Time Shifting], $y(t) = x(t - t_0)$, $hat(y)(ν) = e^(-j thin 2π thin ν thin t_0) hat(x)(ν)$,

    [Time Reversal], $y(t) = x(-t)$, $hat(y)(ν) = hat(x)(-ν)$,

    [Frequency Shifting], $y(t) = e^(j thin 2π thin ν_0 thin t) thin x(t)$, $hat(y)(ν) = hat(x)(ν - ν_0)$,

    [Time Scaling], $y(t) = x(a thin t)$, $hat(y)(ν) = 1/abs(a) hat(x)(ν/a)$,

    [Convolution], $z(t) = x(t) * y(t)$, $hat(z)(ν) = hat(x)(ν) thin hat(y)(ν)$,

    [Multiplication], $z(t) = x(t) thin y(t)$, $hat(z)(ν) = hat(x)(ν) * hat(y)(ν)$,

    [Conjugation], $y(t) = conj(x(t))$, $hat(y)(ν) = conj(hat(x)(-ν))$,

    [Differentiation], $y(t) = (dif) / (dif t) x(t)$, $hat(y)(ν) = j thin 2π thin ν thin hat(x)(ν)$,

    [Integration],
    $y(t) = integral_(-infinity)^t x(τ) dif τ$,
    $hat(y)(ν) = (hat(x)(ν)) / (j thin 2π thin ν) + hat(x)(0) thin δ(ν)$,

    [Symmetry ], $x(t) in RR$, $hat(x)(-ν) = conj(hat(x)(ν))$,

    [Even Real Signals], $x(t) = x(-t) in RR$, $hat(x)(ν) in RR$,

    [Odd Real Signals], $x(t) = -x(-t) in RR$, $hat(x)(ν) in j thin RR$,
  ),
  caption: [Properties of Continuous Fourier Transform],
) <table-continuous-fourier-properties>

== Symmetry
When the real and imaginary parts of a complex function are decomposed into their even and odd parts, there are four components, each with a specific symmetry property:
- The real part of the Fourier transform of a real signal is an even function.
- The imaginary part of the Fourier transform of a real signal is an odd function.
- The real part of the Fourier transform of an imaginary signal is an odd function.
- The imaginary part of the Fourier transform of an imaginary signal is an even function.

The transform of a real-valued function thus exhibits conjugate symmetry.
Conversely, if a function's Fourier transform has conjugate symmetry, the original function is real-valued.

== Incertitude Principle
The Fourier transform incertitude principle states that a signal cannot be simultaneously localized in time and frequency. More precisely,considering  a  centered signal ($∫_RR t thin x(t) dt = 0$) of unit energy ($∫_RR abs(x(t))^2 dt = 1$) for simplicity, if we define the time spread (standard deviation) $Δ t$ and the frequency spread $Δ ν$ of a signal $x(t)$ as:
$
  Δ t & = sqrt(∫_RR t^2 abs(x(t))^2 dif t) \
  Δ ν & = sqrt(∫_RR ν^2 abs(hat(x)(ν))^2 dif ν)thin ,
$
then the incertitude principle states that:
#math.equation(
  block: true,
  $Δ t thin Δ ν >= 1 / (4 π) thin .$,
)
In quantum mechanics, as  the momentum and position wave functions are Fourier transform pairs (up to a factor of the Planck constant), this inequality becomes the Heisenberg uncertainty principle.

== Notable Fourier transforms
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

    [Dirac delta], $x(t) = δ(t)$, $hat(x)(ν) = 1$,

    [Constant], $x(t) = 1$, $hat(x)(ν) = δ(ν)$,

    [Complex exponential], $x(t) = e^(j 2π ν_0 t)$, $hat(x)(ν) = δ(ν - ν_0)$,

    [Cosine], $x(t) = cos(2π ν_0 t)$, $hat(x)(ν) = 1/2 [δ(ν - ν_0) + δ(ν + ν_0)]$,

    [Sine], $x(t) = sin(2π ν_0 t)$, $hat(x)(ν) = 1/(2j) [δ(ν - ν_0) - δ(ν + ν_0)]$,

    [Sign], $x(t) = "sgn"(t) = cases(1 quad &t > 0, -1 quad &t < 0)$, $hat(x)(ν) = 1/(j π ν)$,

    [Unit step], $x(t) = u(t)$, $hat(x)(ν) = 1/(j 2π ν) + 1/2 δ(ν)$,
  ),
  caption: [Notable Fourier Transform Pairs],
) <table-fourier-transforms>


== Filtering

Thanks to the convolution theorem of the Fourier transform, the action of a LTI system of impulse response $h$ on a signal $x$ is :
$
    y(t) & = (h*x)(t) \
  hat(y) & = hat(h) thin hat(x) thin,
$
where $hat(h)$, the Fourier transform of $h$ is called the transfert function.

We called the action of these LTI systems as a _Filtering_ of the input signal. It is important to understand that filters  acts on each frequencies independently. We can study the transfert function of filters either to understand their effect on signals or to design filters with specific frequency response. This is widely used in signal processing, communications, control systems, and many other fields. This study generaly amounts to study modulus and phase of the transfert function as a function of frequency:
$
  h(ν) = abs(hat(h)(ν)) thin e^(j thin φ(ν)) thin,
$
where $φ(ν)$ is  the phase response  and $abs(hat(h)(ν))$  is the magnitude response of the filter.

Several categories of filters can be described:
- Low-pass filters: These filters allow low-frequency components to pass through while attenuating high-frequency components. They are commonly used to remove high-frequency noise from signals.
- High-pass filters: These filters allow high-frequency components to pass through while attenuating low-frequency components. They are used to eliminate low-frequency noise or drift.
- Band-pass filters: These filters allow a specific range of frequencies to pass through while attenuating frequencies outside this range. They are used in applications such as audio processing and communications.
- Band-stop filters: These filters attenuate a specific range of frequencies while allowing frequencies outside this range to pass through. They are used to eliminate unwanted frequency components, such as interference.
- All-pass  filters: These filters allow all frequencies to pass through but alter the phase relationship between different frequencies.


Filters can be easily combined  by multiplying their transfer functions. This property is particularly useful in designing complex filtering systems by cascading simpler filters.

/*

#math.equation(
  block: true,
  $
    y & = (h * x) \
    y(t) & = ∫_RR h(τ) thin ∫_RR hat(x)(ν) thin e^(j thin 2 π thin ν thin (t-τ)) thin dif ν dif τ \
    & = ∫_RR hat(x)(ν) thin ∫_RR h(τ) thin e^(j thin 2 π thin ν thin (t-τ)) thin dif τ thin dif ν \
    &= ∫_RR hat(x)(ν) thin (∫_RR h(τ) thin e^(-j thin 2 π thin ν thin τ) thin dif τ) thin e^(j thin 2 π thin ν thin t) thin dif ν\
    hat(y)(ν) & = hat(x)(ν) thin hat(h)(ν)
  $,
) */

= Discrete Fourier Transform

== Discrete-Time Fourier Transform

$x(t)$  is a continuous signal  and its Fourier transform is:
$
  hat(x)(ν) = ∫_RR x(t) thin e^(-j thin 2 π thin ν thin t) thin dif t
$
We define $x_T$ the signal $x$ sampled at interval of $T$ seconds, it becomes:
$
  hat(x_T)(ν) & = ∑_(n=-∞)^(+∞) T thin x(n T) e^(-j thin 2 π thin ν thin T thin n)
$
in angular frequencies, taking $ω = 2π thin ν T$, the function $hat(x)_(2π)(ω)$ became periodic of period $2π$.
$hat(x_(2π))(ν)$ is called the Discrete-Time Fourier Transform (DTFT) of the discrete-time signal $x[n] = x(n T)$:
$
  hat(x_T)(ω) & = ∑_(n=-∞)^(+∞) x[n] thin e^(-j thin ω thin n), & text(weight: "bold", "    Forward DTFT") \
  //#label("eq-dtft-analysis") \
  x[n] & = 1/(2 π) ∫_(-π)^(π) hat(x_T)(ω) thin e^(j thin ω thin n) thin dif ω. & text(weight: "bold", "    Inverse DTFT") // #label("eq-dtft-synthesis")
$

== Discrete Fourier Transform

The Discrete Fourier Transform (DFT) is a sampled version of the DTFT. It is defined for a finite-length discrete-time signal $x[n]$ of length $N$ as:
#rect(fill: silver)[
  $
    hat(x)[k] & = ∑_(n=0)^(N-1) x[n] thin e^(-j thin 2 π thin k thin n / N ), & text(weight: "bold", "    Forward DFT") \
    //#label("eq-dft-analysis") \
    x[n] & = 1/N ∑_(k=0)^(N-1) hat(x)[k] thin e^(j thin 2 π thin k thin n / N). & text(weight: "bold", "    Inverse DFT") // #label("eq-dft-synthesis")
  $
]
where $ω_N = e^(j thin (2 π) / N)$ is the Nth-root of unity.

We can defined the DFT matrix  of size $N$ as :
$
      F_(N)[k,n] & = e^(-j thin 2 π (k thin n) / N) , quad k,n = 0, 1, ..., N-1 thin \
  /*              & = mat(
    1, 1, 1, ..., 1;
    1, e^(-j thin 2 π / N), e^(-j thin 2 π 2 / N), ..., e^(-j thin 2 π (N-1) / N);
    1, e^(-j thin 2 π 2 / N), e^(-j thin 2 π 4 / N), ..., e^(-j thin 2 π 2(N-1) / N);
    ..., ..., ..., ..., ...;
    1, e^(-j thin 2 π (N-1) / N), e^(-j thin 2 π 2(N-1) / N), ..., e^(-j thin 2 π (N-1)(N-1) / N);
  ) \ */ MM(F)_N & = mat(
                     1, 1, 1, ..., 1;
                     1, ω_N, ω_N^2, ..., ω_N^(N-1);
                     1, ω_N^2, ω_N^4, ..., ω_N^(2(N-1));
                     ..., ..., ..., ..., ...;
                     1, ω_N^(N-1), ω_N^(2(N-1)), ..., ω_N^((N-1)(N-1));
                   )
$
the discrete Fourier transform becomes:
#rect(fill: silver)[
  $
    hat(VV(x)) & = MM(F)_N ⋅ VV(x) ,          & text(weight: "bold", "    Forward DFT") \
    //#label("eq-dft-analysis") \
         VV(x) & = 1/N MM(F)^H_N ⋅ hat(VV(x)) & text(weight: "bold", "    Inverse DFT") // #label("eq-dft-synthesis")
  $
]
where $MM(F)^H_N$ is the is Hermitian transpose or conjugate transpose:
$ F^H_(N)[i,j] = conj(F_(N)[j,i]) $.

As $MM(F)^H_N ⋅ MM(F)_N = 1/N Id ≠ Id$, this DFT matrix is not unitary. This lead to the unitary definition of the DFT matrix:
#rect(fill: silver)[
  $
    MM(U)_N & = 1 / sqrt(N) MM(F)_N
  $
]
and $MM(U)^H_N ⋅ MM(U)_N = Id$.


The DFT can be computed efficiently using the Fast Fourier Transform (FFT) algorithm that applies the DFT matrix $MM(F)_N$ in $O(N thin log(N))$ operations.

== Properties

The properties of the Discrete Fourier Transform are similar to those of the continuous Fourier transform described in @sec-FT-properties. They can be derived from the properties of the DTFT.
#show table.cell: set text(size: 10pt)
#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    stroke: 0.5pt + silver,
    table.header([*Property*], [*Time Domain*], [*Frequency Domain*]),
    [Linearity], $z[n] = a thin x[n] + b thin y[n]$, $hat(z)[k] = a thin hat(x)[k] + b thin hat(y)[k]$,

    [Time Shifting], $y[n] = x[n - n_0]$, $hat(y)[k] = e^(-j thin 2 π thin k thin n_0 / N) hat(x)[k]$,

    [Frequency Shifting], $y[n] = e^(j thin 2 π thin k_0 thin n / N) thin x[n]$, $hat(y)[k] = hat(x)[(k - k_0) mod N]$,

    [Time Reversal], $y[n] = x[-n mod N]$, $hat(y)[k] = hat(x)[-k mod N]$,

    [Convolution],
    $z[n] = (x * y)[n] = ∑_(m=0)^(N-1) x[m] thin y[(n - m) mod N]$,
    $hat(z)[k] = hat(x)[k] thin hat(y)[k]$,

    [Multiplication],
    $z[n] = x[n] thin y[n]$,
    $hat(z)[k] = 1/N ∑_(ell=0)^(N-1) hat(x)[ell] thin hat(y)[(k - ell) mod N]$,

    [Conjugation], $y[n] = conj(x[n])$, $hat(y)[k] = conj(hat(x)[-k mod N])$,

    [First Difference], $y[n] = x[n] - x[n-1 mod N]$, $hat(y)[k] = (1 - e^(-j thin 2 π thin k / N)) hat(x)[k]$,

    [Symmetry ], $x[n] in RR$, $hat(x)[-k mod N] = conj(hat(x)[k])$,

    [Even Real Signals], $x[n] = x[-n mod N] in RR$, $hat(x)[k] in RR$,
    [Odd Real Signals], $x[n] = -x[-n mod N] in RR$, $hat(x)[k] in j thin RR$,
  ),
  caption: [Properties of Discrete Fourier Transform],
) <table-dft-properties>

== Discrete convolution matrix

Given a finite-length discrete inpulse response $VV(h)$ of length $M$, the convolution matrix $MM(H)$ generated by $VV(h)$ for an input signal $VV(x)$ of size $N$ is defined as:
$
  VV(y) & = MM(H) ⋅ VV(x) \
  MM(H) & = mat(
            h[0], 0, 0, ..., 0;
            h[1], h[0], 0, ..., 0;
            h[2], h[1], h[0], ..., 0;
            ..., ..., ..., ..., ...;
            h[M-1], h[M-2], h[M-3], ..., h[0];
            0, h[M-1], h[M-2], ..., h[1];
            0, 0, h[M-1], ..., h[2];
            ..., ..., ..., ..., ...;
            0, 0, 0, ..., h[M-1];
          )
$
This matrix is of size $(N + M - 1) x N$ and the output signal $VV(y)$ is then of size $N + M - 1$. This formulation supposed that the vector $VV(x)$ is zero outside its defined range.

=== Circulant Matrices
If we supposed the input vector periodic of period $N$,  the matrix $MM(H)$ becomes a Toeplitz circulant matrix of size $N x N$:
$
  MM(H) & = mat(
            h[0], h[N-1], h[N-2], ..., h[1];
            h[1], h[0], h[N-1], ..., h[2];
            h[2], h[1], h[0], ..., h[3];
            ..., ..., ..., ..., ...;
            h[N-1], h[N-2], h[N-3], ..., h[0];
          )
$
This matrix is  Toeplitz as each descending diagonal from left to right is constant.

=== Diagonalization of convolution matrix
The  circulant convolution matrix (a.k.a Toeplitz matrix) $MM(H)$ of size $N$ can be diagonalized using the DFT matrix $MM(F)_N$ as:
#math.equation(
  block: true,
  $
    MM(H) & = MM(F)^H_N ⋅ MM(Λ) ⋅ MM(F)_N
    //MM(Λ) & = MM(F)_N ⋅ MM(H) ⋅ MM(F)^H_N
  $,
)
where $MM(Λ)$ is a diagonal matrix containing the eigenvalues of $MM(H)$ given by the DFT of its first column:
$
  Λ_(k,k) = & hat(h)_k
$
In other word
#math.equation(
  block: true,
  $
    MM(H) & = MM(F)^H_N ⋅ diag(hat(h))⋅ MM(F)_N
    //MM(Λ) & = MM(F)_N ⋅ MM(H) ⋅ MM(F)^H_N
  $,
)
where $diag(hat(h))$ is the diagonal matrix containing the DFT of the impulse response $VV(h)$.



== Sampling<sec-sampling>


= Random signals


== Definitions


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
    caption: [Three realizations of a non-stationary random signal],
  ) <fig-random-signal>
]


=== Random signals
A random signal $X(t,s)$, also known as a stochastic process, is a function of time (or another variable) whose amplitude at any given time $t$ is a random variable.
It is a set of functions of $t$, the set being indexed by $s$ as illustrated in #ref(<fig-random-signal>). A random signal is thus a bivariate quantity. When $s=s_i$ is fixed, we get a realization of the random process, denoted $X(t,s_i)$ or, more simply, $X_i (t)$. When $t$ is fixed, the random process reduces to a simple random variable. A random signal can be either continuous or discrete in time or value.

A random signal is *wide-sense stationary* if its mean and autocovariance are finite and independent of the choice of the origin of time:
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


#bibliography("reference.bib", style: "american-geophysical-union")
