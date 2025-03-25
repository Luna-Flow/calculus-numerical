///|
/// Checks if a subinterval is too small relative to its position in the
/// integration interval, which helps detect possible numerical instabilities
/// during adaptive integration.
///
/// Parameters:
///
/// * `left_bound` : The left endpoint of the first subinterval.
/// * `middle_point` : The point that divides the original interval.
/// * `right_bound` : The right endpoint of the second subinterval.
///
/// Returns a boolean value indicating whether the subinterval is too small
/// relative to its position (true) or not (false).
///
/// Example:
///
/// ```moonbit
/// test "subinterval_check" {
///   let is_small = subinterval_check(1e-15, 1e-15, 1e-15)
///   inspect!(is_small, content="true")
/// }
/// ```
fn subinterval_check(a_1 : Double, a_2 : Double, b_2 : Double) -> Bool {
  let tmp = (1.0 + 100.0 * @internal.machine_dbl_epsilon) *
    (a_2.abs() + 1000.0 * @internal.machine_dbl_min)
  a_1.abs() <= tmp && b_2.abs() <= tmp
}

///|
/// Rescales the absolute error estimate using both the magnitude of the result
/// and the accumulation of roundoff errors. Implements sophisticated error
/// rescaling that accounts for both the relative size of the error and numerical
/// precision limitations.
///
/// Parameters:
///
/// * `error` : The initial error estimate to be rescaled.
/// * `result_abs` : The absolute value of the computed result.
/// * `result_asc` : The accumulation of roundoff errors from the computation
/// sequence.
///
/// Returns a rescaled error value that takes into account both the relative
/// magnitude of the error and machine precision limitations.
///
/// Temporary implementation: Use sqrt(x * x * x) instead of pow(x, 1.5) 
/// until a new, higher-precision implementation of pow is completed.
/// 
/// Example:
///
/// ```moonbit
/// test "rescale_error" {
///   let err = rescale_error(0.001, 1.0, 0.1)
///   // The rescaled error will account for both the relative error size
///   // and numerical precision constraints
///   inspect!(err > 0.0, content="true")
/// }
/// ```
pub fn rescale_error(
  err : Double,
  result_abs : Double,
  result_asc : Double
) -> Double {
  let mut err_ = err.abs()
  if result_asc != 0 && err_ != 0 {
    let x = 200.0 * err_ / result_asc
    let scale = sqrt(x * x * x)
    if scale < 1 {
      err_ = result_asc * scale
    } else {
      err_ = result_asc
    }
  }
  if result_abs >
    @internal.machine_dbl_min / (50.0 * @internal.machine_dbl_epsilon) {
    let min_err = 50.0 * @internal.machine_dbl_epsilon * result_abs
    if min_err > err_ {
      err_ = min_err
    }
  }
  err_
}
