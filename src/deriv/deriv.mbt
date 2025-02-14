///| @coverage.skip
fn central_deriv(
  f : @basic.Func_Math,
  x : Double,
  h : Double
) -> (Double, Double, Double) {
  let f_x_minus_h = f(x - h)
  let f_x_plus_h = f(x + h)
  let f_x_minus_half_h = f(x - 0.5 * h)
  let f_x_plus_half_h = f(x + 0.5 * h)
  let central_diff_1st_order = 0.5 * (f_x_plus_h - f_x_minus_h)
  let central_diff_2nd_order = 4.0 / 3.0 * (f_x_plus_half_h - f_x_minus_half_h) -
    1.0 / 3.0 * central_diff_1st_order
  let error_1st_order = (f_x_plus_h.abs() + f_x_minus_h.abs()) *
    @internal.machine_dbl_epsilon
  let error_2nd_order = 2.0 *
    (f_x_plus_half_h.abs() + f_x_minus_half_h.abs()) *
    @internal.machine_dbl_epsilon +
    error_1st_order
  let estimated_roundoff_error = @math.maximum(
      (central_diff_1st_order / h).abs(),
      (central_diff_2nd_order / h).abs(),
    ) *
    (x.abs() / h) *
    @internal.machine_dbl_epsilon
  (
    central_diff_2nd_order / h,
    ((central_diff_2nd_order - central_diff_1st_order) / h).abs(),
    (error_2nd_order / h).abs() + estimated_roundoff_error,
  )
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
  let (initial_derivative, roundoff_error, truncation_error) = central_deriv(
    f, x, h,
  )
  let mut total_error = roundoff_error + truncation_error
  let mut derivative = initial_derivative
  if roundoff_error < truncation_error &&
    roundoff_error > 0 &&
    truncation_error > 0 {
    let optimal_h = @luna_math.pow(
      h * (roundoff_error / (2.0 * truncation_error)),
      1.0 / 3.0,
    )
    let (optimal_derivative, optimal_roundoff_error, optimal_truncation_error) = central_deriv(
      f, x, optimal_h,
    )
    let optimal_total_error = optimal_roundoff_error + optimal_truncation_error
    if optimal_total_error < total_error &&
      (optimal_derivative - initial_derivative).abs() < 4.0 * total_error {
      derivative = optimal_derivative
      total_error = optimal_total_error
    }
  }
  (derivative, total_error)
}

///| @coverage.skip
fn forward_deriv(
  f : @basic.Func_Math,
  x : Double,
  h : Double
) -> (Double, Double, Double) {
  let function_values = [x + h * 0.25, x + h * 0.5, x + h * 0.75, x + h]
  function_values.map_inplace(f)
  let forward_diff_1st_order = 2.0 * (function_values[3] - function_values[1])
  let forward_diff_2nd_order = 22.0 /
    3.0 *
    (function_values[3] - function_values[2]) -
    62.0 / 3.0 * (function_values[2] - function_values[1]) +
    52.0 / 3.0 * (function_values[1] - function_values[0])
  let abs_function_values = function_values.map(@double.abs)
  let error_2nd_order = 2.0 *
    20.67 *
    @luna_utils.arr_sum(abs_function_values) *
    @internal.machine_dbl_epsilon
  let estimated_roundoff_error = @math.maximum(
      (forward_diff_1st_order / h).abs(),
      (forward_diff_2nd_order / h).abs(),
    ) *
    (x / h).abs() *
    @internal.machine_dbl_epsilon
  (
    forward_diff_2nd_order / h,
    ((forward_diff_2nd_order - forward_diff_1st_order) / h).abs(),
    (error_2nd_order / h).abs() + estimated_roundoff_error,
  )
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
  let (initial_derivative, roundoff_error, truncation_error) = forward_deriv(
    f, x, h,
  )
  let mut derivative = initial_derivative
  let mut total_error = roundoff_error + truncation_error
  if roundoff_error < truncation_error &&
    roundoff_error > 0 &&
    truncation_error > 0 {
    let optimal_h = h * @luna_math.sqrt(roundoff_error / truncation_error)
    let (optimal_derivative, optimal_roundoff_error, optimal_truncation_error) = forward_deriv(
      f, x, optimal_h,
    )
    let optimal_total_error = optimal_roundoff_error + optimal_truncation_error
    if optimal_total_error < total_error &&
      (optimal_derivative - initial_derivative).abs() < 4.0 * total_error {
      derivative = optimal_derivative
      total_error = optimal_total_error
    }
  }
  (derivative, total_error)
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
