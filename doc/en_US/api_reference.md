# API Reference Manual

## @Luna-Flow/calculus-numerical/basic

### Type Aliases

#### `Func_Math` : `(Double) -> Double`

Represents a single-variable mathematical function.

<br>

#### `Quad_GK` : `(Func_Math, Double, Double) -> (Double, Double, Double, Double,)`

Represents a Gauss-Kronrod numerical integration function, such as `@integration.kronrod_r15()`

<br>

## @Luna-Flow/calculus-numerical/deriv

### Derivation

#### `deriv_central` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

##### Description

Computes the derivative of the function `f` at point `x` using an __adaptive central difference method__, which balances truncation and round-off errors for improved accuracy.

##### Parameters

- `f: Func_Math` — A mathematical function that takes a `Double` as input and returns a `Double` as output.
- `x: Double` — The point at which the derivative is evaluated.
- `h: Double` — The initial step size for numerical differentiation, which will be  adaptively adjusted if necessary.

##### Returns

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative at `x`.
- The second value is the total estimated error, combining truncation and round-off errors.

##### Example Usage

```moonbit
test "deriv_central" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_central(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

##### Notes

- The method __automatically adjusts the step size__ to achieve the best accuracy.
- Works well for smooth functions but may be __less accurate near discontinuities__.
- Compared to a simple 2-point method, this approach significantly reduces numerical errors.

<br>

#### `deriv_forward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

##### Description

Computes the derivative of the function `f` at point `x` using an __adaptive forward difference method__, which optimizes step size to minimize truncation and round-off errors.

##### Parameters

- `f: Func_Math` — A mathematical function that takes a `Double` as input and returns a `Double` as output.
- `x: Double` — The point at which the derivative is evaluated.
- `h: Double` — The initial step size for numerical differentiation, which will be adaptively adjusted if necessary.

##### Returns

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative at `x`.
- The second value is the total estimated error, combining truncation and round-off errors.

##### Example Usage

```moonbit
test "deriv_forward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_forward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

##### Notes

- The method __automatically refines the step size__ for better accuracy.
- Compared to basic forward difference methods, this approach __significantly reduces numerical errors__.
- Works well for smooth functions but may be __less accurate for functions with sharp changes or discontinuities__.
- This method is especially useful when evaluating derivatives at boundaries where central differences are not feasible.

<br>

#### `deriv_backward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

##### Description

Computes the derivative of the function `f` at point `x` using an __adaptive backward difference method__, which mirrors forward differentiation but with a negative step size.

##### Parameters

- `f: Func_Math` — A mathematical function that takes a `Double` as input and returns a `Double` as output.
- `x: Double` — The point at which the derivative is evaluated.
- `h: Double` — The initial step size for numerical differentiation, which will be adaptively adjusted if necessary.

##### Returns

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative at `x`.
- The second value is the total estimated error, combining truncation and round-off errors.

##### Example Usage

```moonbit
test "deriv_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_backward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

##### Notes

- The method __automatically refines the step size__ to optimize accuracy.
- Suitable for cases where __backward differences__ are preferred, such as differentiation near the upper boundary of a dataset.
- Shares the same numerical advantages as `deriv_forward`, significantly reducing numerical errors compared to simple finite differences.

<br>

## @Luna-Flow/calculus-numerical/diff

###  Differentiation

#### `diff_backward` : `(f : Func_Math, x : Double) -> (Double, Double)`

##### Description

Computes the numerical derivative of a function at a given point using the backward difference method with adaptive step size.

##### Parameters

- `f: Func_Math` — A function that takes a `Double` and returns a `Double`. The function to be differentiated.
- `x: Double` — The point at which to compute the derivative.

##### Returns

A tuple `(Double, Double)`, where:

- The first value is the estimated derivative value using backward difference approximation.
- The second value is the estimated absolute error of the computation.

##### Example Usage

```
test "diff_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
  let (derivative, error) = diff_backward(f, 2.0)
  inspect!((derivative - 4.0).abs() < error, content="true")
}
```

##### Notes

- The function evaluates the given function at three backward points using an adaptive step size.
- It applies Neville’s recursion to compute divided differences and estimate the derivative.
- The method includes an error estimation based on the second-order divided difference.
- If `h` is too large, accuracy may decrease; if too small, numerical precision issues may arise.
