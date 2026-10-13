# integration API

The `integration` package integrates functions `(Double) -> Double` over a finite interval and returns an `Estimate[Double]`. The original integrators are in [`legacy/integration`](legacy_integration.md).

## `gauss_kronrod_21` : `(function: (Double) -> Double, lower: Double, upper: Double) -> (Double, Double, Int)`

**Description:**
Applies the 21-point Gauss–Kronrod rule (with the embedded 10-point Gauss rule) once on `[lower, upper]`.

**Returns:**

A tuple `(value, error, evaluations)`: the Kronrod value, the absolute difference between the Kronrod and Gauss values (an empirical error estimate), and `21`.

## `adaptive_gauss_kronrod` : `(function: (Double) -> Double, lower: Double, upper: Double, absolute_tolerance?: Double, relative_tolerance?: Double, max_intervals?: Int) -> Estimate[Double]`

**Description:**
Integrates by repeatedly bisecting the subinterval with the largest error estimate and applying `gauss_kronrod_21`, until the total error estimate is at most `max(absolute_tolerance, relative_tolerance * |value|)`.

**Parameters:**

- `absolute_tolerance`, `relative_tolerance` — Both default to `1.0e-10` and must not be negative.
- `max_intervals` — The maximum number of subintervals. Defaults to `256`; it must be positive.

**Returns:**

`status` is `Converged` if the tolerance was met (also when it was met by the last permitted subdivision) and `MaxIterations` otherwise. `InvalidInput` is returned, with no evaluation, when `lower == upper`, a tolerance is negative, or `max_intervals` is not positive. Reversed bounds give the negated integral. `iterations` is the number of bisections.

**Example Usage:**

```moonbit nocheck
let result = @integration.adaptive_gauss_kronrod(fn(x) { x * x }, 0.0, 1.0)
// result.value is close to 1/3
```

## `tanh_sinh` : `(function: (Double) -> Double, lower: Double, upper: Double, step?: Double, tolerance?: Double, max_terms?: Int) -> Estimate[Double]`

**Description:**
Integrates with the tanh–sinh (double exponential) rule of Takahasi and Mori. The rule clusters nodes doubly exponentially towards the endpoints, so it handles integrable endpoint singularities such as `1/sqrt(x)` at `0`.

**Parameters:**

- `step` — The spacing in the transformed variable. Defaults to `0.125`; it must be positive.
- `tolerance` — Stop when the magnitude of the latest term, times `step`, is at most this. Defaults to `1.0e-12`; it must not be negative.
- `max_terms` — The maximum number of terms on each side of the midpoint. Defaults to `64`; it must be positive.

**Returns:**

`status` is `Converged` when the tolerance is met or when the nodes reach the endpoints in floating point, and `MaxIterations` when `max_terms` is exhausted. `estimated_error` is the magnitude of the last term, a heuristic indicator, not a bound. Nodes close to an endpoint are computed as `midpoint ± half_length * tanh(…)`, so their distance from the endpoint is limited by double precision.

**Example Usage:**

```moonbit nocheck
let result = @integration.tanh_sinh(fn(x) { 1.0 / x.sqrt() }, 0.0, 1.0)
// result.value is close to 2
```
