# diff API

The `diff` package estimates the derivative of a function at a point without a step size from the caller: the step is derived from machine precision and the local behaviour of the function. Each function returns the estimate together with an error bound.

## `diff_backward` : `(f : Func_Math, x : Double) -> (Double, Double)`

**Description:**

Computes the numerical derivative of a function at a given point using the backward difference method with adaptive step size.

**Parameters:**

- `f: Func_Math` — A function that takes a `Double` and Returns: a `Double`. The function to be differentiated.
- `x: Double` — The point at which to compute the derivative.

**Returns:**

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative value using backward difference approximation.
- The second value is the estimated absolute error of the computation.

**Example Usage:**

```moonbit
test "diff_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
  let (derivative, error) = diff_backward(f, 2.0)
  inspect((derivative - 4.0).abs() < error, content="true")
}
```

**Notes:**

- The function evaluates the given function at three backward points using an adaptive step size.
- It applies Neville’s recursion to compute divided differences and estimate the derivative.
- The method includes an error estimation based on the second-order divided difference.
- If `h` is too large, accuracy may decrease; if too small, numerical precision issues may arise.

## `diff_forward` : `(f : Func_Math, x : Double) -> (Double, Double)`

**Description:**

Computes the numerical derivative of a function at a given point using the forward difference method with adaptive step size.

**Parameters:**

- `f: Func_Math` — A function that takes a `Double` and Returns: a `Double`. The function to be differentiated.
- `x: Double` — The point at which to compute the derivative.

**Returns:**

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative value using forward difference approximation.
- The second value is the estimated absolute error of the computation.

**Notes:**

- The function evaluates the given function at three forward points to choose the step size, so it only needs values of `f` at and above `x`.

## `diff_central` : `(f : Func_Math, x : Double) -> (Double, Double)`

**Description:**

Computes the numerical derivative of a function at a given point using the central difference method with adaptive step size.

**Parameters:**

- `f: Func_Math` — A function that takes a `Double` and Returns: a `Double`. The function to be differentiated.
- `x: Double` — The point at which to compute the derivative.

**Returns:**

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative value using central difference approximation.
- The second value is the estimated absolute error of the computation.

**Example Usage:**

```moonbit
test "diff_central" {
  let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
  let (derivative, error) = diff_central(f, 2.0)
  inspect((derivative - 4.0).abs() < error, content="true")
}
```

**Notes:**

- The function evaluates the given function at four points around `x` to choose the step size.
