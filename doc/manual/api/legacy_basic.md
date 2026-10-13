# legacy/basic API

The `legacy/basic` package defines the function types shared by the other packages and a set of mathematical constants.

## Type aliases

### `Func_Math` : `(Double) -> Double`

Represents a single-variable mathematical function.

### `Quad_GK` : `(Func_Math, Double, Double) -> (Double, Double, Double, Double,)`

Represents a Gauss-Kronrod numerical integration function, such as `@legacy_integration.kronrod_r15()`

## Constants

The constants are `Double` values with full double precision.

| Constant | Value |
| --- | --- |
| `math_e` | $e$ |
| `math_log_2_e` | $\log_2 e$ |
| `math_log_10_e` | $\log_{10} e$ |
| `math_sqrt_2` | $\sqrt{2}$ |
| `math_sqrt_1_2` | $\sqrt{1/2}$ |
| `math_sqrt_3` | $\sqrt{3}$ |
| `math_pi` | $\pi$ |
| `math_pi_2` | $\pi/2$ |
| `math_pi_4` | $\pi/4$ |
| `math_sqrt_pi` | $\sqrt{\pi}$ |
| `math_2_sqrt_pi` | $2/\sqrt{\pi}$ |
| `math_1_pi` | $1/\pi$ |
| `math_2_pi` | $2/\pi$ |
| `math_ln_10` | $\ln 10$ |
| `math_ln_2` | $\ln 2$ |
| `math_ln_pi` | $\ln \pi$ |
| `math_euler` | Euler's constant $\gamma$ |
