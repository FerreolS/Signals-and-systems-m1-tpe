#import "CC-template.typ": *
#import "@preview/cetz:0.4.2": canvas, draw, matrix, vector
#import "@preview/cetz-plot:0.1.3": plot


// =====================================
// EXAMPLE USAGE - Delete or modify below
// =====================================

#show: exam.with(
  title: "Data Science",
  course: "TD 4",
  date: "10 December 2025",
  duration: none,
  student-info: none,
  show-solutions: sys.inputs.at("solutions", default: "true") == "true", // Set to true to display solutions
)



= Optimal Filtering and the Wiener Filter

A geophysicist measures a seismic signal
$ y(t)=x(t)+n(t) $ where:
- $x(t)$ is the stationary seismic signal of interest. It is centered ($μ_x=0$) with autocorrelation function $γ_x (τ) = σ_x^2 thin e^(-α abs(τ))$
- $n(t)$ is stationary measurement noise, it is centered and independent of $x(t)$
- the signal and the noise are uncorrelated: $EE{x(t) thin n(t')} = 0$

The goal is to design an *optimal linear filter* $h(t)$ that estimates $x(t)$ from the noisy measurements $y(t)$. We seek an estimate $x^+ (t)$ that minimizes the *mean square error (MSE)*:
$
  "MSE" = ∫_RR EE{abs(x(t) - x^+ (t))^2} dt
$

== Computing power spectral densities
#question()[
  The noise is assumed independent, white, and identically distributed with variance $σ^2_n$.
  #subquestion()[Write its autocorrelation function.
    #solution(lines: 0)[
      $γ_n(τ) = σ^2_n thin δ(τ)$
    ]
  ]
  #subquestion()[
    Compute the autocorrelation $γ_y(τ)$ of the measured signal $y$.
    #solution(lines: 0)[
      Since $x(t)$ and $n(t)$ are uncorrelated, we have:
      $
        γ_y(τ) = γ_x(τ) + γ_n (τ) = σ_x^2 thin e^(-α abs(τ)) + σ^2_n thin δ(τ)
      $
    ]
  ]
  #subquestion()[Compute the cross-correlation $γ_(x,y) (τ) = ∫_RR E{x(t)thin y(t + τ)} dt$ between the true signal and the measurements.
    #solution(lines: 0)[
      Since $x(t)$ and $n(t)$ are uncorrelated, we have:
      $
        γ_(x,y) (τ) = γ_x (τ) + 0 = σ_x^2 thin e^(-α abs(τ))
      $
    ]
  ]
]
#question()[
  Compute the power spectral densities of:
  - the true signal $S_x (ν)$
  - the noise $S_n (ν)$
  - the measurements $S_y (ν)$
  - the cross power spectral density between $x$ and $y$: $S_(x,y) (ν)$

    #solution(lines: 0)[
      Using the Fourier transform of the autocorrelation functions, we have:
      - $
          S_x (ν) = FT{γ_x } = ∫_RR σ_x^2 thin e^(-α abs(τ)) thin e^(-j 2π ν τ) dif τ = σ_x^2 thin (2α) / (α^2 + (2π ν)^2)
        $
      - $
          S_n (ν) = FT{γ_n } = ∫_RR σ^2_n thin δ(τ) thin e^(-j 2π ν τ) dif τ = σ^2_n
        $
      - $ S_y (ν) = S_x (ν) + S_n (ν) = σ_x^2 thin (2α) / (α^2 + (2π ν)^2) + σ^2_n $
      - $
          S_(x,y) (ν) = S_x (ν) = σ_x^2 thin (2α) / (α^2 + (2π ν)^2)
        $
    ]
]


== Derivation of the Wiener filter

The Wiener filter is the filter with transfer function $hat(h)$ that minimizes the Mean Square Error. From Parseval-Plancherel we can write:
$
  "MSE" = ∫_RR EE{ abs(hat(x)(ν) - hat(h)(ν)thin hat(y)(ν))^2 } dif ν
$
#question()[
  #subquestion()[ Show that
    $
      "MSE" = ∫_RR S_x (ν) - 2 thin Re(hat(h)(ν)thin S_(x,y)(ν)) + abs(hat(h)(ν))^2 thin S_y (ν) dif ν
    $

    #solution(lines: 0)[
      By expanding the square and using the definition of spectral density, we have:
      $
        "MSE" = ∫_RR EE{ abs(hat(x)(ν))^2 } - 2 thin Re(EE{ hat(x)(ν) thin conj(hat(h)(ν) thin hat(y)(ν)) }) + EE{ abs(hat(h)(ν) thin hat(y)(ν))^2 } dif ν
      $
      Using the definition of spectral density, we obtain:
      $
        "MSE" = ∫_RR S_x (ν) - 2 thin Re(hat(h)(ν) thin S_(x,y)(ν)) + abs(hat(h)(ν))^2 thin S_y (ν) dif ν
      $
    ]

  ]
  #subquestion()[To minimize the MSE, take the derivative with respect to $hat(h)(ν)$
    and set it to zero. Show that the optimal filter (Wiener filter) satisfies:
    $
      hat(h) (ν) = (S_(x) (ν)) / ( S_(x)(ν) + S_n (ν)), quad ∀ ν ∈ RR
    $

    #solution(lines: 0)[
      Taking the derivative of the MSE with respect to $hat(h)(ν)$ and setting it to zero, we have:
      $
        (dif "MSE" )/(dif hat(h)(ν))= ∫_RR -2 thin S_(x,y)(ν) + 2 hat(h)(ν) thin S_y (ν) dif ν = 0
      $
      Solving for $hat(h)(ν)$, we obtain:
      $
        hat(h) (ν) = (S_(x,y)(ν)) / ( S_(y)(ν))
      $
      Replacing $S_(x,y)(ν)$ and $S_y (ν)$ by their expressions found in the previous question, we get:
      $
        hat(h) (ν) = (S_(x) (ν)) / ( S_(x)(ν) + S_n (ν))
      $
    ]
  ]
]

== Application
#question()[
  #subquestion()[
    Write the Wiener filter expression using the densities computed in question 2:

    #solution(lines: 0)[
      Replacing the expressions of $S_x (ν)$ and $S_n (ν)$ found in question 2, we have:
      $
        hat(h) (ν) & = (σ_x^2 thin (2α) / (α^2 + (2π ν)^2)) / (σ_x^2 thin (2α) / (α^2 + (2π ν)^2) + σ^2_n) \
                   & = (σ_x^2 thin (2α)) / (σ_x^2 thin (2α) + σ^2_n thin (α^2 + (2π ν)^2)) \
                   & = 1 / (1 + (σ^2_n) / ( σ_x^2 ) thin (α^2 + (2π ν)^2)/(2 α))
      $

    ]
  ]

  #subquestion()[Analyze the behavior of the Wiener filter:
    - What happens at low frequencies?
    - What happens at high frequencies?
    - How does the filter depend on the signal-to-noise ratio: $"SNR"= ( σ_x^2 )/ (σ^2_n)$?

  ]
  #subquestion()[
    Sketch (qualitatively) the magnitude $abs(hat(h)(ν))^2$
  ]
]



= Spatial Interpolation and  Kriging

A geophysicist has measured a physical property (e.g., porosity, seismic velocity) at
$N$ discrete locations $VV(x) = [x_1, x_2, ..., x_N]^T$  in a geological formation. The measurements are $Z(x_i) = z_i$ (#ie the vector $VV(z) = [z_1, z_2, ..., z_N]^T$).

The goal is to estimate the value $tilde(Z)(x_0)$ at an unmeasured location  $x_0$  using a linear combination of the observations:
$
  tilde(Z)(x_0) = ∑_(i=1)^N λ_i Z(x_i)
$

== Expressing the covariance structure
We model $Z(x)$  as a stationary random field (spatial random signal) with zero mean $EE{Z(x)} = 0$ and covariance function
$
  γ(h) = EE{Z(x) conj(Z)(x+h)}= σ^2 e^(-abs(h)/a)
$
where $a$ is the correlation length (range) and $σ^2$ a constant.

#question()[
  #subquestion()[What is the covariance $γ(0)$ at zero distance? Interpret this value.

    #solution(lines: 0)[
      The covariance at zero distance is:
      $
        γ(0) = EE{Z(x) conj(Z)(x)} = σ^2
      $
      This value represents the variance of the random field $Z(x)$, indicating the spread or variability of the measurements around their mean (which is zero in this case).
    ]
  ]
  #subquestion()[
    How does the covariance drop at a distance $a$?

    #solution(lines: 0)[
      At a distance equal to the correlation length $a$, the covariance drops to:
      $
        γ(a) = EE{Z(x) conj(Z)(x+a)} = σ^2 e^(-abs(a)/a) = σ^2 e^(-1) ≈ 0.368 thin σ^2
      $
      This indicates that at a distance equal to the correlation length, the covariance has decreased to approximately 36.8% of its maximum value at zero distance.
    ]
  ]

]

== Optimal weights

We want to find weights $VV(λ)= [ λ_1, λ_2, ...,λ_N]$ that minimize the mean square prediction error:
$
  "MSE" = EE{abs(tilde(Z)(x_0) - Z(x_0))^2}
$
#question()[
  #subquestion()[
    Show that the prediction error can be written as:
    $
      "MSE" = γ(0) - 2 ∑_(i=1)^N λ_i γ(x_0 - x_1) + ∑_(i=1)^N ∑_(j =1)^N λ_i λ_j γ(x_i - x_j)
    $

    #solution(lines: 0)[
      By expanding the square and using the definition of covariance, we have:
      $
        "MSE" = EE{ abs(∑_(i=1)^N λ_i Z(x_i) - Z(x_0))^2 } = EE{ (∑_(i=1)^N λ_i Z(x_i) - Z(x_0)) conj(∑_(j=1)^N λ_j Z(x_j) - Z(x_0)) }
      $
      Expanding this expression, we get:
      $
        "MSE" = EE{ ∑_(i=1)^N ∑_(j=1)^N λ_i λ_j Z(x_i) conj(Z(x_j)) - 2 ∑_(i=1)^N λ_i Z(x_i) conj(Z(x_0)) + Z(x_0) conj(Z(x_0)) }
      $
      Using the definition of covariance, we can rewrite this as:
      $
        "MSE" = ∑_(i=1)^N ∑_(j=1)^N λ_i λ_j γ(x_i - x_j) - 2 ∑_(i=1)^N λ_i γ(x_0 - x_i) + γ(0)
      $
      Rearranging the terms, we obtain:
      $
        "MSE" = γ(0) - 2 ∑_(i=1)^N λ_i γ(x_0 - x_i) + ∑_(i=1)^N ∑_(j=1)^N λ_i λ_j γ(x_i - x_j)
      $
    ]

  ]

  #subquestion()[
    Find the system of linear equations in $λ_i$ that minimizes the $"MSE"$ by setting the derivative with respect to $λ_i$ to zero.
    #solution(lines: 0)[
      Taking the derivative of the MSE with respect to $λ_k$ and setting it to zero, we have:
      $
        (dif "MSE" )/(dif λ_k) = -2 γ(x_0 - x_k) + 2 ∑_(j=1)^N λ_j γ(x_k - x_j) = 0
      $
      Rearranging this equation, we obtain:
      $
        ∑_(j=1)^N λ_j γ(x_k - x_j) = γ(x_0 - x_k), quad ∀ k = 1, 2, ..., N
      $
      This gives us a system of $N$ linear equations that can be solved to find the optimal weights $λ_i$.
    ]

  ]
  #subquestion()[Rewrite it in a matrix form leading to the simple kriging equations:
    $
      VV(λ) =MM(C)^(-1) ⋅ VV(c) \
      tilde(Z)(x_0) = VV(z)^T ⋅ MM(C)^(-1) ⋅ VV(c) = ∑_(i=1)^N λ_i Z(x_i)
    $


    #solution(lines: 0)[

      Let $VV(λ) = [ λ_1, λ_2, ..., λ_N]^T$ be the vector of weights, and let $MM(C)$ be the covariance matrix with entries $γ(x_i - x_j)$ for $i, j = 1, 2, ..., N$. We can rewrite the system of equations in matrix form as:
      $
        MM(C) VV(λ) = VV(c)
      $
      where:
      - $C_(i,j) = γ(x_i - x_j)$
      - $VV(c)_i = γ(x_0 - x_i)$
      This matrix equation can be solved for the weight vector $VV(λ)$.
    ]
  ]
]
== Properties

#question()[Estimate the bias of the estimator $tilde(Z)(x_0)$, that is $"Bias" = EE{ tilde(Z)(x_0) - Z(x_0)}$

  #solution(lines: 0)[
    The bias of the estimator $tilde(Z)(x_0)$ is given by:
    $
      "Bias" = EE{ tilde(Z)(x_0) - Z(x_0)} = EE{ ∑_(i=1)^N λ_i Z(x_i) - Z(x_0) }
    $
    Since $Z(x)$ has zero mean, we have:
    $
      EE{ Z(x_i) } = 0, quad ∀ i
    $
    Therefore, the bias simplifies to:
    $
      "Bias" = ∑_(i=1)^N λ_i EE{ Z(x_i) } - EE{ Z(x_0) } = 0 - 0 = 0
    $
    This shows that the estimator $tilde(Z)(x_0)$ is unbiased.
  ]
]


#question()[Estimate the variance of the estimator $"Var"(tilde(Z)(x_0)) = EE{abs(tilde(Z)(x_0)- Z(x_0))^2}$
  #solution(lines: 0)[
    The variance of the estimator $tilde(Z)(x_0)$ can be computed as:
    $
      "Var"(tilde(Z)(x_0)) = EE{ abs(tilde(Z)(x_0) - "Bias")^2 } = EE{ abs(∑_(i=1)^N λ_i Z(x_i))^2}
    $
    Expanding this expression, we have:
    $
      "Var"(tilde(Z)(x_0)) = EE{ ∑_(i=1)^N ∑_(j=1)^N λ_i λ_j Z(x_i) conj(Z(x_j)) }
    $
    Using the definition of covariance, we can rewrite this as:
    $
      "Var"(tilde(Z)(x_0)) & = ∑_(i=1)^N ∑_(j=1)^N λ_i λ_j γ(x_i - x_j) \
                           & = VV(λ)^T⋅MM(C)⋅VV(λ) \
                           & = VV(λ)^T⋅VV(c)
    $
    This expression gives the variance of the estimator $tilde(Z)(x_0)$ in terms of the weights $λ_i$ and the covariance function $γ(h)$.
  ]
]
