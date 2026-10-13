# power_series API

The `power_series` package represents truncated power series over any coefficient type `T` that provides the required algebraic traits of `Luna-Flow/luna-generic`. It has no dependency on `Double`, so the same code works for `Double`, `Decimal` and other numbers.

## `PowerSeries[T]`

A series `c[0] + c[1] x + c[2] x^2 + …` stored as its coefficient array.

| Function | Meaning |
| --- | --- |
| `PowerSeries::from_coefficients(coefficients)` | Wraps the coefficients `c[0], c[1], …`. |
| `order(self)` | The degree of the truncation, `length - 1`. |
| `coefficient(self, order)` | `Some(c[order])`, or `None` outside the stored range. |
| `evaluate(self, value)` | Evaluates the series at `value` with Horner's scheme. Needs `AddMonoid` and `Mul`. |
| `derivative(self)` | The termwise derivative, of order one lower. A constant series gives the zero series. Needs `FromNat`, `Zero` and `Mul`. |
| `antiderivative(self, context)` | The termwise antiderivative with zero constant term, of order one higher. Division by the term index is contextual, so it rounds as the arithmetic context says and can fail. Returns `Result[PowerSeries[T], ArithmeticError]`. |

## `taylor_from_derivatives` : `(derivative: (Int) -> T, order: Int, context: ArithmeticContext) -> Result[PowerSeries[T], ArithmeticError]`

**Description:**
Builds the Taylor polynomial about a point from an oracle for the derivatives at that point: the coefficient of `x^k` is `derivative(k) / k!`. Each division uses the supplied arithmetic context. Negative `order` is a domain error.

`maclaurin_from_derivatives` is the same function; use it when the point is `0`.

**Example Usage:**

```moonbit nocheck
// exp: every derivative at 0 is 1.
let series = @power_series.maclaurin_from_derivatives(
  fn(_) { 1.0 },
  12,
  @lf_arith.ArithmeticContext::new(53),
).unwrap()
// series.evaluate(1.0) is close to e
```

**Notes:**

- With `Decimal` coefficients the division honours the Decimal precision of the context (for example `1/6 = 0.1666666666666667` at 16 digits).
- The package computes coefficients from a derivative oracle; it does not differentiate numerically.
