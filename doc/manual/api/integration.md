# integration API

The `integration` package computes definite integrals of a `Func_Math` over a finite interval $[a, b]$ with Gauss–Kronrod quadrature. It provides the basic Gauss–Kronrod rules, an adaptive integrator that subdivides the interval, and a non-adaptive integrator that raises the order of the rule.

## Gauss–Kronrod rules

### `kronrod_r15`, `kronrod_r21`, `kronrod_r31`, `kronrod_r41`, `kronrod_r51`, `kronrod_r61`

Each function applies one Gauss–Kronrod rule to `f` on $[a, b]$; the number in the name is the number of Kronrod points.

```mbti
fn kronrod_r15((Double) -> Double, Double, Double) -> (Double, Double, Double, Double)
fn kronrod_r21((Double) -> Double, Double, Double) -> (Double, Double, Double, Double)
fn kronrod_r31((Double) -> Double, Double, Double) -> (Double, Double, Double, Double)
fn kronrod_r41((Double) -> Double, Double, Double) -> (Double, Double, Double, Double)
fn kronrod_r51((Double) -> Double, Double, Double) -> (Double, Double, Double, Double)
fn kronrod_r61((Double) -> Double, Double, Double) -> (Double, Double, Double, Double)
```

The result is the tuple `(result, result_abs, result_asc, error)`:

| Value | Meaning |
| --- | --- |
| `result` | The Kronrod approximation of the integral of `f`. |
| `result_abs` | The same rule applied to $\lvert f \rvert$. |
| `result_asc` | The same rule applied to $\lvert f - \bar f \rvert$, where $\bar f$ is the mean value of `f` on the interval; it measures how much `f` varies. |
| `error` | The difference between the Kronrod and the embedded Gauss approximation, rescaled with `rescale_error`. |

Every rule has the type `Quad_GK` from the `basic` package, so it can be passed to `adap_quad_gk`.

### `rescale_error`

`rescale_error` turns the raw difference between two quadrature approximations into a conservative error estimate.

```mbti
fn rescale_error(Double, Double, Double) -> Double
```

`rescale_error(err, result_abs, result_asc)` scales $\lvert err \rvert$ to $result\_asc \cdot \min(1, (200 \lvert err \rvert / result\_asc)^{3/2})$ when both are non-zero, and never returns less than $50\,\varepsilon \cdot result\_abs$, where $\varepsilon$ is the machine epsilon of `Double`. This is the error heuristic of QUADPACK.

## Integrators

### `adap_quad_gk`

`adap_quad_gk` integrates `f` over $[a, b]$ adaptively: it bisects the subinterval with the largest error until the total error meets the tolerance.

```mbti
fn adap_quad_gk((Double) -> Double, ((Double) -> Double, Double, Double) -> (Double, Double, Double, Double), Double, Double, Double, Double, Int) -> Result[(Double, Double, ErrCode), ErrCode]
```

`adap_quad_gk(f, q, a, b, epsabs, epsrel, limit)` applies the rule `q`, for example `kronrod_r21`, to each subinterval. The computation stops successfully when the estimated absolute error is at most $\max(epsabs, epsrel \cdot \lvert I \rvert)$, where $I$ is the current integral estimate. `limit` is the maximum number of subintervals.

The result is `Ok((integral, error, OK))` on success. Otherwise it is `Err(code)`:

| Code | Cause |
| --- | --- |
| `E_BAD_TOL` | `epsabs` is not positive and `epsrel` is smaller than the machine epsilon or $0.5 \cdot 10^{-28}$. |
| `E_ROUND` | Roundoff error prevents the requested tolerance from being reached. |
| `E_SINGULARITY` | A subinterval became too small to bisect, which suggests a singularity or a highly oscillatory integrand. |
| `E_MAX_ITER` | `limit` subintervals were used before the tolerance was reached. |

### `non_adap_quad_gk`

`non_adap_quad_gk` integrates `f` over $[a, b]$ with Gauss–Kronrod rules of increasing order, without subdividing the interval.

```mbti
fn non_adap_quad_gk((Double) -> Double, Double, Double, Double, Double) -> Result[(Double, Double, Int), ErrCode]
```

`non_adap_quad_gk(f, a, b, epsabs, epsrel)` tries the 21-, 43- and 87-point rules in turn and returns as soon as the estimated error is below `epsabs` or below `epsrel` times the absolute value of the result. The result is `Ok((integral, error, neval))`, where `neval` is the number of function evaluations used (21, 43 or 87). It is `Err(E_BAD_TOL)` for invalid tolerances, as in `adap_quad_gk`, and `Err(E_FAILED)` when even the 87-point rule does not reach the tolerance.

```moonbit
// Integrate x^2 from 0 to 1 (exact answer: 1/3)
let f = fn(x) { x * x }
match non_adap_quad_gk(f, 0.0, 1.0, 0.0000000001, 0.0000000001) {
  Ok((result, error, neval)) =>
    println("Integral: \{result}, Error: \{error}, Evaluations: \{neval}")
  Err(code) => println("Integration failed with error: \{code}")
}
```

## Error codes

### `ErrCode`

`ErrCode` reports the outcome of an integration.

```moonbit
pub(all) enum ErrCode {
  OK
  E_ROUND
  E_SINGULARITY
  E_MAX_ITER
  E_FAILED
  E_BAD_TOL
} derive(Eq)
```

| Constructor | Meaning |
| --- | --- |
| `OK` | The integration succeeded. |
| `E_ROUND` | Unexpected roundoff error. |
| `E_SINGULARITY` | Possible singularity or highly oscillatory integrand. |
| `E_MAX_ITER` | Maximum number of subdivisions reached. |
| `E_FAILED` | General failure. |
| `E_BAD_TOL` | Invalid tolerance parameters. |

`ErrCode` implements `Eq`, so a result code can be compared with a constructor.
