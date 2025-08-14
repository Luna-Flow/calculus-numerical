///|
/// Performs adaptive quadrature integration using Gauss-Kronrod quadrature
/// rules. Adaptively subdivides the integration interval to achieve the
/// requested accuracy, handling difficult integrands by focusing computational
/// effort where needed.
///
/// Parameters:
///
/// * `integrand` : The function to be integrated. Takes a `Double` and returns a
/// `Double`.
/// * `quadrature` : The Gauss-Kronrod quadrature rule to be used for
/// integration. Can be any of the predefined rules (15, 21, 31, 41, 51, or 61
/// points).
/// * `lower_bound` : The lower bound of the integration interval.
/// * `upper_bound` : The upper bound of the integration interval.
/// * `absolute_tolerance` : The absolute error tolerance. Must be positive.
/// * `relative_tolerance` : The relative error tolerance. Must be greater than
/// machine epsilon.
/// * `subdivision_limit` : The maximum number of subintervals allowed in the
/// subdivision process.
///
/// Returns a `Result` containing either:
///
/// * `Ok((result, error, status))` where:
///  * `result` is the approximated value of the integral
///  * `error` is the estimated absolute error
///  * `status` is an error code indicating the success or failure mode
/// * `Err(error_code)` if the integration fails due to invalid tolerance
/// parameters
///
/// Example:
///
/// ```moonbit
/// test "adap_quad_gk" {
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, error, status) = adap_quad_gk(f, kronrod_r21, 0.0, 1.0, 1e-10, 1e-10, 100).unwrap()
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
///   inspect!(status, content="OK")
/// }
/// ```
///
/// @coverage.skip
pub fn adap_quad_gk(
  f : Func_Math,
  q : Quad_GK,
  a : Double,
  b : Double,
  epsabs : Double,
  epsrel : Double,
  limit : Int,
) -> Result[(Double, Double, ErrCode), ErrCode] {
  let mut iteration_count : Int = 0
  let mut integral_result : Double = 0
  let mut absolute_error : Double = 0
  let mut error_code : ErrCode = E_FAILED
  let workspace = IntegrationWorkspace::new(limit)
  if epsabs <= 0 && (epsrel < @internal.machine_dbl_epsilon || epsrel < 0.5e-28) {
    return Err(E_BAD_TOL)
  } else {
    let (initial_result, initial_abs_error, initial_resasc, initial_error) = q(
      f, a, b,
    )
    IntegrationWorkspace::init(workspace, a, b, initial_result, initial_error)
    let mut tolerance = max(epsabs, epsrel * initial_result.abs())
    let roundoff_threshold = 50.0 *
      @internal.machine_dbl_epsilon *
      initial_abs_error
    if initial_error <= roundoff_threshold && initial_error > tolerance {
      integral_result = initial_result
      absolute_error = initial_error
      return Err(E_ROUND)
    } else if (initial_error <= tolerance && initial_error != initial_resasc) ||
      initial_error == 0.0 {
      integral_result = initial_result
      absolute_error = initial_error
      return Ok((integral_result, absolute_error, OK))
    } else if limit == 1 {
      integral_result = initial_result
      absolute_error = initial_error
      return Err(E_MAX_ITER)
    }
    let mut total_area = initial_result
    let mut total_error = initial_error
    iteration_count = 1
    let mut error_type = 0
    let mut roundoff_count_1 = 0
    let mut roundoff_count_2 = 0
    while iteration_count < limit && error_type == 0 && total_error > tolerance {
      let (prev_lower_bound, prev_upper_bound, prev_area, prev_error) = IntegrationWorkspace::retrieve(
        workspace,
      )
      let mid_point = 0.5 * (prev_lower_bound + prev_upper_bound)
      let (area_left, _, left_resasc, left_error) = q(
        f, prev_lower_bound, mid_point,
      )
      let (area_right, _, right_resasc, right_error) = q(
        f, mid_point, prev_upper_bound,
      )
      let combined_area = area_left + area_right
      let combined_error = left_error + right_error
      total_error = total_error + (combined_error - prev_error)
      total_area = total_area + (combined_area - prev_area)
      if left_resasc != left_error && right_resasc != right_error {
        let delta = prev_area - area_right
        if delta.abs() <= 1.0e-5 * combined_area.abs() &&
          combined_error >= 0.99 * prev_error {
          roundoff_count_1 = roundoff_count_1 + 1
        }
        if iteration_count >= 10 && combined_error > prev_error {
          roundoff_count_2 = roundoff_count_2 + 1
        }
      }
      tolerance = max(epsabs, epsrel * total_area.abs())
      if total_error > tolerance {
        if roundoff_count_1 >= 6 || roundoff_count_2 >= 20 {
          error_type = 2
          error_code = E_ROUND
        }
        if subinterval_check(prev_lower_bound, mid_point, prev_upper_bound) {
          error_type = 3
          error_code = E_SINGULARITY
        }
      }
      IntegrationWorkspace::update(
        workspace, prev_lower_bound, mid_point, area_left, left_error, mid_point,
        prev_upper_bound, area_right, right_error,
      )
      iteration_count = iteration_count + 1
    }
    integral_result = arr_sum(workspace.r_list)
    absolute_error = total_error
    if total_error <= tolerance {
      error_code = OK
    } else if iteration_count == limit && error_type == 0 {
      error_code = E_MAX_ITER
    }
  }
  if error_code != OK {
    Err(error_code)
  } else {
    Ok((integral_result, absolute_error, error_code))
  }
}
