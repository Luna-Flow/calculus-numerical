# core API

The `core` package defines the result type shared by the next-generation numerical routines. A routine returns an `Estimate` instead of a tuple whose fields have no names.

## `NumericalStatus`

Describes how a routine stopped.

| Variant | Meaning |
| --- | --- |
| `Converged` | The stopping criterion of the routine was met. |
| `MaxIterations` | The iteration, interval or term limit was reached before the criterion was met. The value is the last estimate. |
| `InvalidInput` | An argument was out of range (for example a non-positive step or a limit of zero). The value is `0` and no function evaluation was made. |
| `RoundoffStagnation` | Reserved for routines that detect roundoff-limited progress. No routine returns it yet. |

## `Estimate[T]`

| Field | Meaning |
| --- | --- |
| `value : T` | The computed value. |
| `estimated_error : T` | An empirical error estimate. It is **not** a guaranteed bound. |
| `evaluations : Int` | The number of function evaluations. |
| `iterations : Int` | The number of iterations, subdivisions or terms used. |
| `status : NumericalStatus` | How the routine stopped. |
| `diagnostics : ArithmeticDiagnostics` | Arithmetic flags from `Luna-Flow/arithmetic`; empty for the `Double` routines. |

`Estimate::new(value, estimated_error, evaluations, iterations, status, diagnostics?)` builds an estimate, with empty diagnostics by default. `Estimate` and `NumericalStatus` derive `Eq` and `Debug`.
