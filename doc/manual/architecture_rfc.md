# RFC 0001: Luna-Flow numerical calculus foundation architecture

- Status: experimental validation
- Target version: next major version
- Scope: architecture, algorithm selection and API feasibility; does not replace the current production implementation

## 1. Decision summary

The next-generation `calculus-numerical` no longer takes GSL's `Double` API and implementation structure as its blueprint. Instead, it is built on Luna-Flow's algebraic traits, checked arithmetic and explicit numerical contexts.

- When the migration is carried out, the current `basic`, `deriv`, `diff` and `integration` APIs move into `legacy/*` and keep a compatibility period of one major version.
- In its first phase the new API supports only same-type scalar functions `(T) -> T`. The coordinate type, the return type and the error scalar are not separated for now.
- `Double` and `Float` use fast context-free implementations; `Decimal` and `BinFloat` use explicit context adapters.
- Full entry points must take a context, tolerances and resource limits; convenience entry points may use a documented default context. The default for Decimal is Decimal128.
- Numerical algorithms return named results and diagnostics instead of tuples whose meaning is opaque.
- `estimated_error` denotes an empirical error estimate. Only implementations based on interval arithmetic or BallFloat may return a `certified_bound`.

## 2. Standards and independent implementation

### 2.1 Numerical semantics

- Classification, rounding and special values of binary and decimal floating point follow IEEE 754-2019.
- Decimal context, flags, cohort and exception semantics follow the General Decimal Arithmetic specification and the decNumber test specification.
- Arbitrary-precision reference values are generated with MPFR or Arb; no particular machine `Double` implementation is taken as the standard of correctness.

### 2.2 Algorithm sources

Implementations are based on papers and published algorithm descriptions; mature libraries are consulted only to cross-check interfaces and behavior:

| Area | First-phase candidate | Primary basis | Reason for the choice |
| --- | --- | --- | --- |
| Numerical derivatives | Fornberg weights | Fornberg, 1988/1998 | Arbitrary nodes and derivative orders, without hand-written stencil magic numbers |
| Adaptive derivatives | Richardson/Ridders | Richardson extrapolation and Ridders' method | Explainable step-size sequence and error estimate |
| Fixed quadrature | Gauss–Kronrod 15/21 | Gauss–Kronrod rules and the QUADPACK literature | One sampling pass also yields a nested error estimate |
| Adaptive integration | Subdivide the interval with the largest error first | QUADPACK algorithm descriptions | Mature workspace and stopping strategy |
| High-precision integration | Tanh–Sinh | Takahasi–Mori double exponential formulas | Suited to endpoint singularities and high-precision Decimal |
| Integration of smooth functions | Clenshaw–Curtis | Chebyshev expansion literature | Reuses samples and extends naturally to high precision |
| Finite sums | pairwise, Kahan, Neumaier | Floating-point error analysis literature | Offers tiers of performance and stability |
| Infinite series | Wynn epsilon, Euler transform | Convergence acceleration literature | Covers common alternating and slowly converging cases |
| Power series | Truncated coefficient algebra | Standard formal power series algorithms | Supports evaluation, differentiation, integration and basic composition |

GSL is GPL software. This project may compare its public behavior and the papers it cites, but must not copy, translate or structurally rewrite its source code.

## 3. Dependency boundaries

Dependencies must stay one-way:

```text
luna-generic -> arithmetic -> floating
                         \-> calculus-numerical
floating ----------------> calculus-numerical
luna-poly ---------------> calculus-numerical/power_series adapters
autodiff ----------------> optional calculus bridge
```

This phase does not modify `arithmetic` or `floating`. Ordinary algebraic operations compose the existing traits directly; inside calculus, minimal providers are used only for capabilities that are missing and depend on a context. Once validation has stabilized, a separate RFC will move the general `next_up`, numerical-format and context capabilities up into `arithmetic`, and `floating` will implement the Decimal/BinFloat instances.

`floating` must not depend on calculus. The context capabilities of the existing Decimal types are provided by provider values owned by calculus; non-context capabilities such as addition, subtraction, multiplication, division, comparison, zero and one continue to use trait composition.

## 4. Type system decisions

### 4.1 A single scalar and value type in the first phase

Stable entry points use `(T) -> T`. The current MoonBit/Luna-Flow ecosystem has no mature public capability that expresses the following relations:

```text
V + V -> V
S * V -> V
norm(V) -> E
```

Vector scaling in `linear-algebra` currently uses the same element type as well. A public three-type `S/V/E` API would force callers to pass large function tables and could introduce indirect calls into integration hot paths. Integration over vectors, matrices and heterogeneous value types is therefore deferred to a separate RFC.

### 4.2 Trait composition plus minimal providers

No `RealNumber` trait bundling all elementary functions is added, and existing trait operations are not rewrapped into function tables. Algorithms take the minimal capabilities they need through trait composition:

- Core scalars: compose existing traits such as `Zero`, `One`, `IntegralHomomorphism`, `Add`, `Sub`, `Mul`, `Div` and `Compare` directly.
- Numerical format: epsilon, adjacent values, minimum normal, maximum finite, value classification.
- Optional capabilities: context-aware `sqrt`, integer powers and parsing.

Only context-dependent operations that existing traits cannot express correctly use a minimal provider, for example a context one of type `(Context) -> T` and a next-up of type `(T, Context) -> T`. Once stable, these capabilities move up into `arithmetic`.

### 4.3 Context and epsilon

The format constants of `Float` and `Double` are determined by the type. The epsilon and range of Decimal are determined jointly by the precision, the exponent range and the rounding context, so a parameterless Decimal `epsilon()` must not be provided.

The working epsilon of Decimal is defined as:

```text
next_plus(1, context) - 1
```

An algorithm entry point builds a derived environment once and caches epsilon, sqrt(epsilon) and commonly used coefficients. Hot loops must not repeatedly construct contexts, convert rule tables or compute format constants.

## 5. Draft packages and public API

```text
core             context, tolerance, status, diagnostics, experimental adapter
differentiation  Fornberg, Richardson/Ridders
integration      quadrature rule, adaptive controller, workspace
series           compensated sum, convergence acceleration
power_series     truncated series and calculus operations
legacy           current public API compatibility layer
```

Suggested result shapes:

```moonbit
pub struct IntegrationResult[T] {
  value : T
  estimated_error : T
  evaluations : Int
  intervals : Int
  status : NumericalStatus
}

pub struct IntegrationOptions[T] {
  absolute_tolerance : T
  relative_tolerance : T
  max_evaluations : Int
  max_intervals : Int
}
```

`NumericalStatus` distinguishes at least completion, resource exhaustion, invalid tolerance, rounding stagnation, suspected singularity, non-finite input/output and context arithmetic failure. Low-level Decimal flags should be aggregated into the diagnostics rather than compressed into a single integer error code.

## 6. Algorithm boundaries

### 6.1 Derivatives

- The rule layer generates Fornberg weights from the nodes and the derivative order; rule objects can be cached.
- The execution layer is only responsible for sampling and weighting.
- The control layer adjusts the step size with Richardson/Ridders and reports truncation and rounding errors.
- `autodiff` stays independent; calculus only provides an optional bridge and guidance on choosing an algorithm, and does not reimplement dual numbers.

### 6.2 Integration

- `QuadratureRule[T]` stores nodes, Gauss weights and extension weights, each with a documented source.
- Fixed rules are separate from the adaptive controller; the controller does not know where the rule coefficients come from.
- The adaptive workspace allows local mutation but exposes no mutable state.
- Double/Float rules use concrete static tables; Decimal/BinFloat rules are converted once for the context at the entry point and cached for that call.
- Tanh–Sinh does not depend on fixed-precision tables and is the preferred complement for high-precision and endpoint-singular cases.

### 6.3 Series

- Finite sequences provide naive, pairwise and Kahan/Neumaier summation, so that no single `sum` implicitly chooses the cost of precision.
- Infinite series must be given an explicit tolerance and maximum number of terms, and return the number of terms used and the reason for termination.
- Convergence acceleration is a composable strategy and is not mixed into sequence generators.
- `PowerSeries[T]` stores its truncation order explicitly; conversion to and from `luna-poly` is an explicit adapter, and a truncated series is not treated as an ordinary polynomial.

## 7. Legacy migration

The migration proper spans two releases:

1. When the new packages are released, the old entry points forward to `legacy/*`, and the documentation marks them deprecated and provides an item-by-item migration table.
2. The next major version removes legacy; serious correctness issues are still fixed, but legacy receives no new algorithms or numeric types.

During this RFC phase no existing files are moved, to avoid creating compatibility changes before the new API has been validated.

## 8. Validation gates

- Each area first delivers one Double/Decimal vertical slice before the number of algorithms is expanded.
- The target overhead of the Double adapter prototype relative to a direct implementation is at most 15%; hot loops must not allocate per item.
- Decimal uses one explicit context throughout; tests must cover inexact, rounded, underflow, overflow and invalid operation.
- Analytic functions, hard functions and high-precision oracles are tested in separate layers; the actual error and the reported error are recorded separately.
- Property tests cover linearity, interval reversal, constant functions, scaling relations, tolerance monotonicity and series truncation consistency.

## 9. Follow-up RFCs

- Move the stable numerical-format capabilities up into `arithmetic`.
- Separation of scalar and value types, and integration over vectors, matrices and complex numbers.
- Certified integration with BallFloat/interval arithmetic.
- Fourier series and the boundary with the FFT ecosystem.
- ODE/PDE solvers; these are outside this foundational phase.

## References

- B. Fornberg, “Generation of Finite Difference Formulas on Arbitrarily Spaced Grids”, 1988.
- B. Fornberg, “Calculation of Weights in Finite Difference Formulas”, 1998.
- R. Piessens et al., *QUADPACK: A Subroutine Package for Automatic Integration*, 1983.
- H. Takahasi and M. Mori, “Double Exponential Formulas for Numerical Integration”, 1974.
- L. N. Trefethen, “Is Gauss Quadrature Better than Clenshaw–Curtis?”, 2008.
- P. Wynn, “On a Device for Computing the e_m(S_n) Transformation”, 1956.
- IEEE 754-2019, *Standard for Floating-Point Arithmetic*.
- General Decimal Arithmetic Specification and decNumber test suite.
