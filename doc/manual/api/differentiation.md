# differentiation API

The `differentiation` package computes derivatives of functions `(Double) -> Double` from function values. It does not use the step-size heuristics of `legacy/deriv` and `legacy/diff`.

## `fornberg_weights` : `(nodes: ReadOnlyArray[Double], center: Double, derivative_order: Int) -> Array[Array[Double]]?`

**Description:**
Computes finite-difference weights for arbitrary nodes with the algorithm of Fornberg (1988), without solving a Vandermonde system.

**Returns:**

`Some(weights)`, where `weights[i][k]` is the weight of `nodes[i]` in the approximation of the `k`-th derivative at `center`, for `k` from `0` to `derivative_order`. Returns `None` if `derivative_order` is negative, if there are not more than `derivative_order` nodes, or if two nodes coincide.

**Notes:**

- The stencil is exact for polynomials of degree below the number of nodes.
- Badly spread nodes make the weights ill-conditioned; the function does not detect this.

**Example Usage:**

```moonbit nocheck
let nodes : ReadOnlyArray[Double] = [-1.0, 0.0, 1.0]
let weights = @differentiation.fornberg_weights(nodes, 0.0, 2).unwrap()
// weights[0][2] = 1, weights[1][2] = -2, weights[2][2] = 1
```

## `apply_stencil` : `(function: (Double) -> Double, nodes: ReadOnlyArray[Double], weights: Array[Double]) -> Double?`

**Description:**
Evaluates `function` at the nodes and returns the weighted sum. Returns `None` if `nodes` and `weights` differ in length.

## `ridders` : `(function: (Double) -> Double, point: Double, initial_step?: Double, max_iterations?: Int) -> Estimate[Double]`

**Description:**
Estimates the first derivative at `point` by Ridders' method: central differences with the step divided by 1.4 at every level, extrapolated in a Richardson tableau.

**Parameters:**

- `initial_step` — The first step size. Defaults to `0.1`; it must be positive.
- `max_iterations` — The number of levels. Defaults to `10`; it must be positive.

**Returns:**

An `Estimate[Double]`. `estimated_error` is the largest disagreement between the best tableau entry and its two neighbours. It is a heuristic indicator, not a bound. `status` is `Converged` when the error stops improving and `MaxIterations` when all levels were used; with invalid arguments it is `InvalidInput`.

**Example Usage:**

```moonbit nocheck
let result = @differentiation.ridders(@math.sin, 0.0)
// result.value is close to 1
```
