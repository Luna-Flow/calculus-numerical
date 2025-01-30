///| @coverage.skip
fn central_deriv(
  f : @basic.Func_Math,
  x : Double,
  h : Double
) -> (Double, Double, Double) {
  let fm1 = f(x - h)
  let fp1 = f(x + h)
  let fmh = f(x - 0.5 * h)
  let fph = f(x + 0.5 * h)
  let r3 = 0.5 * (fp1 - fm1)
  let r5 = 4.0 / 3.0 * (fph - fmh) - 1.0 / 3.0 * r3
  let e3 = (fp1.abs() + fm1.abs()) * @internal.machine_dbl_epsilon
  let e5 = 2.0 * (fph.abs() + fmh.abs()) * @internal.machine_dbl_epsilon + e3
  let dy = @luna_utils.max((r3 / h).abs(), (r5 / h).abs()) *
    (x.abs() / h) *
    @internal.machine_dbl_epsilon
  (r5 / h, ((r5 - r3) / h).abs(), (e5 / h).abs() + dy)
}

///|
/// Computes the central derivative approximation of a function at a point with
/// adaptive step size refinement. Uses a combination of 5-point and 3-point
/// rules to estimate both the derivative and its error, with automatic step size
/// optimization based on the relative magnitudes of truncation and round-off
/// errors.
///
/// Parameters:
///
/// * `function` : A mathematical function that takes a `Double` and returns a
/// `Double`. The function to be differentiated.
/// * `point` : The point at which to compute the derivative.
/// * `step` : The initial step size for the numerical approximation. Will be
/// automatically refined if possible to minimize the total error.
///
/// Returns a tuple containing:
///
/// * The best available derivative approximation
/// * The estimated absolute error of the computation, combining both truncation
/// and round-off errors
///
/// Example:
///
/// ```moonbit
/// test "deriv_central" {
///   let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
///   let (deriv, error) = deriv_central(f, 2.0, 0.1)
///   inspect!((deriv - 4.0).abs() < error, content="true")
/// }
/// ```
/// @coverage.skip
pub fn deriv_central(
  f : @basic.Func_Math,
  x : Double,
  h : Double
) -> (Double, Double) {
  let (r_0, round, trunc) = central_deriv(f, x, h)
  let mut error = round + trunc
  let mut r = r_0
  if round < trunc && round > 0 && trunc > 0 {
    let h_opt = @luna_math.pow(h * (round / (2.0 * trunc)), 1.0 / 3.0)
    let (r_opt, round_opt, trunc_opt) = central_deriv(f, x, h_opt)
    let error_opt = round_opt + trunc_opt
    if error_opt < error && (r_opt - r_0).abs() < 4.0 * error {
      r = r_opt
      error = error_opt
    }
  }
  (r, error)
}

///| @coverage.skip
fn forward_deriv(
  f : @basic.Func_Math,
  x : Double,
  h : Double
) -> (Double, Double, Double) {
  let fn_eval = [x + h * 0.25, x + h * 0.5, x + h * 0.75, x + h]
  fn_eval.map_inplace(f)
  let r2 = 2.0 * (fn_eval[3] - fn_eval[1])
  let r4 = 22.0 / 3.0 * (fn_eval[3] - fn_eval[2]) -
    62.0 / 3.0 * (fn_eval[2] - fn_eval[1]) +
    52.0 / 3.0 * (fn_eval[1] - fn_eval[0])
  let abs_eval = fn_eval.map(@double.abs)
  let e4 = 2.0 *
    20.67 *
    @luna_utils.arr_sum_dbl(abs_eval) *
    @internal.machine_dbl_epsilon
  let dy = @luna_utils.max((r2 / h).abs(), (r4 / h).abs()) *
    (x / h).abs() *
    @internal.machine_dbl_epsilon
  (r4 / h, ((r4 - r2) / h).abs(), (e4 / h).abs() + dy)
}

///|
/// Computes the forward derivative approximation of a function at a point with
/// adaptive step size refinement. Uses a combination of 4-point and 2-point
/// rules to estimate both the derivative and its error, with automatic step size
/// optimization based on the relative magnitudes of truncation and round-off
/// errors.
///
/// Parameters:
///
/// * `function` : A mathematical function that takes a `Double` and returns a
/// `Double`. The function to be differentiated.
/// * `point` : The point at which to compute the derivative.
/// * `step` : The initial step size for the numerical approximation. Will be
/// automatically refined if possible to minimize the total error.
///
/// Returns a tuple containing:
///
/// * The best available derivative approximation
/// * The estimated absolute error of the computation, combining both truncation
/// and round-off errors
///
/// Example:
///
/// ```moonbit
/// test "deriv_forward" {
///   let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
///   let (deriv, error) = deriv_forward(f, 2.0, 0.1)
///   inspect!((deriv - 4.0).abs() < error, content="true")
/// }
/// ```
/// @coverage.skip
pub fn deriv_forward(
  f : @basic.Func_Math,
  x : Double,
  h : Double
) -> (Double, Double) {
  let (r_0, round, trunc) = forward_deriv(f, x, h)
  let mut r = r_0
  let mut error = round + trunc
  if round < trunc && round > 0 && trunc > 0 {
    let h_opt = h * @luna_math.sqrt(round / trunc)
    let (r_opt, round_opt, trunc_opt) = forward_deriv(f, x, h_opt)
    let error_opt = round_opt + trunc_opt
    if error_opt < error && (r_opt - r_0).abs() < 4.0 * error {
      r = r_opt
      error = error_opt
    }
  }
  (r, error)
}

///|
/// Computes the backward derivative approximation of a function at a point with
/// adaptive step size refinement. Uses the same algorithm as forward
/// differentiation but with a negative step size, making it suitable for cases
/// where backward differences are preferred.
///
/// Parameters:
///
/// * `function` : A mathematical function that takes a `Double` and returns a
/// `Double`. The function to be differentiated.
/// * `point` : The point at which to compute the derivative.
/// * `step` : The initial step size for the numerical approximation. Will be
/// automatically refined if possible to minimize the total error.
///
/// Returns a tuple containing:
///
/// * The best available derivative approximation
/// * The estimated absolute error of the computation, combining both truncation
/// and round-off errors
///
/// Example:
///
/// ```moonbit
/// test "deriv_backward" {
///   let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
///   let (deriv, error) = deriv_backward(f, 2.0, 0.1)
///   inspect!((deriv - 4.0).abs() < error, content="true")
/// }
/// ```
/// @coverage.skip
pub fn deriv_backward(
  f : @basic.Func_Math,
  x : Double,
  h : Double
) -> (Double, Double) {
  deriv_forward(f, x, -h)
}
