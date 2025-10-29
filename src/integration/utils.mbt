///|
/// Checks if two values satisfy a numerical tolerance condition based on
/// machine precision.
///
/// Parameters:
///
/// * `a_1` : The first value to check against the tolerance threshold.
/// * `a_2` : The second value used to compute the tolerance threshold.
/// * `b_2` : The third value to check against the tolerance threshold.
///
/// Returns `true` if both `a_1` and `b_2` are within the computed tolerance
/// based on `a_2`, `false` otherwise.
///
fn subinterval_check(a_1 : Double, a_2 : Double, b_2 : Double) -> Bool {
  let tmp = (1.0 + 100.0 * @internal.machine_dbl_epsilon) *
    (a_2.abs() + 1000.0 * @internal.machine_dbl_min)
  a_1.abs() <= tmp && b_2.abs() <= tmp
}

///|
/// Rescales the error estimate for numerical integration to ensure proper
/// relative and absolute error bounds.
///
/// Parameters:
///
/// * `err` : The initial error estimate from the integration algorithm.
/// * `result_abs` : The absolute value of the integration result.
/// * `result_asc` : The absolute sum of the function values used in the
///   integration, providing a measure of the function's variation.
///
/// Returns the rescaled error estimate that accounts for both relative and
/// absolute precision requirements.
///
pub fn rescale_error(
  err : Double,
  result_abs : Double,
  result_asc : Double,
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
