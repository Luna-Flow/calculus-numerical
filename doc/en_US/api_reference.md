# API Reference Manual

## @Luna-Flow/calculus-numerical/basic

### Type Aliases

#### `Func_Math` : `(Double) -> Double`

Represents a single-variable mathematical function.

---

#### `Quad_GK` : `(Func_Math, Double, Double) -> (Double, Double, Double, Double,)`

Represents a Gauss-Kronrod numerical integration function, such as `@integration.kronrod_r15()`

---

## @Luna-Flow/calculus-numerical/deriv

### Derivation

#### `deriv_central` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

**Description:**
Computes the derivative of the function `f` at point `x` using an **adaptive central difference method**, which balances truncation and round-off errors for improved accuracy.

**Parameters:**

- `f: Func_Math` — A mathematical function that takes a `Double` as input and Returns: a `Double` as output.
- `x: Double` — The point at which the derivative is evaluated.
- `h: Double` — The initial step size for numerical differentiation, which will be adaptively adjusted if necessary.

**Returns:**

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative at `x`.
- The second value is the total estimated error, combining truncation and round-off errors.

**Example Usage:**

```moonbit
test "deriv_central" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_central(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

**Notes:**

- The method **automatically adjusts the step size** to achieve the best accuracy.
- Works well for smooth functions but may be **less accurate near discontinuities**.
- Compared to a simple 2-point method, this approach significantly reduces numerical errors.

---

#### `deriv_forward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

**Description:**
Computes the derivative of the function `f` at point `x` using an **adaptive forward difference method**, which optimizes step size to minimize truncation and round-off errors.

**Parameters:**

- `f: Func_Math` — A mathematical function that takes a `Double` as input and Returns: a `Double` as output.
- `x: Double` — The point at which the derivative is evaluated.
- `h: Double` — The initial step size for numerical differentiation, which will be adaptively adjusted if necessary.

**Returns:**

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative at `x`.
- The second value is the total estimated error, combining truncation and round-off errors.

**Example Usage:**

```moonbit
test "deriv_forward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_forward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

**Notes:**

- The method **automatically refines the step size** for better accuracy.
- Compared to basic forward difference methods, this approach **significantly reduces numerical errors**.
- Works well for smooth functions but may be **less accurate for functions with sharp changes or discontinuities**.
- This method is especially useful when evaluating derivatives at boundaries where central differences are not feasible.

---

#### `deriv_backward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

**Description:**
Computes the derivative of the function `f` at point `x` using an **adaptive backward difference method**, which mirrors forward differentiation but with a negative step size.

**Parameters:**

- `f: Func_Math` — A mathematical function that takes a `Double` as input and Returns: a `Double` as output.
- `x: Double` — The point at which the derivative is evaluated.
- `h: Double` — The initial step size for numerical differentiation, which will be adaptively adjusted if necessary.

**Returns:**
A tuple `(Double, Double)`, where:

- The first value is the estimated derivative at `x`.
- The second value is the total estimated error, combining truncation and round-off errors.

**Example Usage:**

```moonbit
test "deriv_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_backward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

**Notes:**

- The method **automatically refines the step size** to optimize accuracy.
- Suitable for cases where **backward differences** are preferred, such as differentiation near the upper boundary of a dataset.
- Shares the same numerical advantages as `deriv_forward`, significantly reducing numerical errors compared to simple finite differences.

---

## @Luna-Flow/calculus-numerical/diff

### Differentiation

#### `diff_backward` : `(f : Func_Math, x : Double) -> (Double, Double)`

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
  inspect!((derivative - 4.0).abs() < error, content="true")
}
```

**Notes:**

- The function evaluates the given function at three backward points using an adaptive step size.
- It applies Neville’s recursion to compute divided differences and estimate the derivative.
- The method includes an error estimation based on the second-order divided difference.
- If `h` is too large, accuracy may decrease; if too small, numerical precision issues may arise.

---
