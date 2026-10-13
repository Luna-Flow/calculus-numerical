# series API

The `series` package sums finite and infinite series of `Double` values.

## Finite sums

Each function takes a `ReadOnlyArray[Double]` and returns its sum. They differ in how rounding error accumulates:

| Function | Method | Error growth |
| --- | --- | --- |
| `naive_sum` | Left-to-right accumulation. | Proportional to the number of terms. |
| `pairwise_sum` | Recursive halving, with blocks of at most 16 terms summed directly. | Proportional to the logarithm of the number of terms. |
| `kahan_sum` | Kahan compensated summation. | Independent of the number of terms for well-scaled inputs. |
| `neumaier_sum` | Neumaier's variant of compensated summation, which also handles a term larger than the running sum. | Independent of the number of terms. |

The sum of an empty array is `0`.

**Example Usage:**

```moonbit nocheck
let values : ReadOnlyArray[Double] = [1.0e16, 1.0, -1.0e16]
// naive_sum(values) = 0, neumaier_sum(values) = 1
```

## `wynn_epsilon` : `(term: (Int) -> Double, max_terms?: Int, tolerance?: Double) -> Estimate[Double]`

**Description:**
Accelerates the convergence of the series whose `index`-th term (counting from `0`) is `term(index)`, with Wynn's epsilon algorithm applied to the partial sums.

**Parameters:**

- `max_terms` — The number of terms summed. Defaults to `32`; it must be at least `3`.
- `tolerance` — Stop when two successive accelerated estimates differ by at most this. Defaults to `1.0e-12`; it must not be negative.

**Returns:**

An `Estimate[Double]` whose `estimated_error` is the difference of the last two accelerated estimates. This is a heuristic indicator, not a bound. `status` is `Converged` when the tolerance was met, `MaxIterations` otherwise, and `InvalidInput` for invalid arguments. `evaluations` is `max_terms`.

**Notes:**

- The method suits alternating and slowly converging series, such as the alternating harmonic series (sum `ln 2`) or the Leibniz series for `pi/4`.
- It does not detect divergent series, and it may return a misleading limit for them.

**Example Usage:**

```moonbit nocheck
let result = @series.wynn_epsilon(fn(index) {
  let sign = if index % 2 == 0 { 1.0 } else { -1.0 }
  sign / (index + 1).to_double()
})
// result.value is close to ln 2
```
