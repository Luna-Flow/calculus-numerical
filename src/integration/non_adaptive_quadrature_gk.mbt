///|
/// Computes the definite integral of a function over a finite interval using
/// non-adaptive Gauss-Kronrod quadrature with progressively higher-order rules
/// (10-21, 21-43, and 43-87 point rules).
///
/// Parameters:
///
/// * `f` : The function to integrate.
/// * `a` : The lower bound of the integration interval.
/// * `b` : The upper bound of the integration interval.
/// * `epsabs` : The absolute error tolerance for the integration result.
/// * `epsrel` : The relative error tolerance for the integration result.
///
/// Returns a `Result` containing either:
///
/// * `Ok((integral, error, neval))` where `integral` is the computed integral
///   value, `error` is the estimated absolute error, and `neval` is the number
///   of function evaluations used (21, 43, or 87)
/// * `Err(error_code)` if the integration fails
///
/// Returns `Err(E_BAD_TOL)` if the tolerance parameters are invalid (epsabs ≤ 0
/// and epsrel is too small), or `Err(E_FAILED)` if the desired accuracy cannot
/// be achieved with the highest-order rule.
///
/// Example:
///
/// ```moonbit
/// // Integrate x^2 from 0 to 1 (exact answer: 1/3)
/// let f = fn(x) { x * x }
/// match non_adap_quad_gk(f, 0.0, 1.0, 0.0000000001, 0.0000000001) {
///   Ok((result, error, neval)) => 
///     println("Integral: \{result}, Error: \{error}, Evaluations: \{neval}")
///   Err(code) => {
///     println("Integration failed with error: \{code}")
///   }
/// }
/// ```
///
pub fn non_adap_quad_gk(
  f : Func_Math,
  a : Double,
  b : Double,
  epsabs : Double,
  epsrel : Double,
) -> Result[(Double, Double, Int), ErrCode] {
  let half_interval = 0.5 * (b - a)
  let center = 0.5 * (a + b)
  let center_value = f(center)
  let abs_half_interval = half_interval.abs()
  let func_values = []
  if epsabs <= 0 &&
    (epsrel < 50.0 * @internal.machine_dbl_epsilon || epsrel < 0.5e-28) {
    return Err(E_BAD_TOL)
  }
  let get_abscissa = fn(sample_point : Double) -> Double {
    half_interval * sample_point
  }
  let func_vals_left_10 = []
  let func_vals_right_10 = []
  let func_vals_left_21 = []
  let func_vals_right_21 = []
  let mut result_asc = 0.0
  let eval_pair = fn(abscissa : Double) -> (Double, Double) {
    (f(center - abscissa), f(center + abscissa))
  }
  let mut result_abs = wg_21b[5] * center_value.abs()
  let mut result_10 = 0.0
  let mut result_21 = wg_21b[5] * center_value
  for i in 0..<5 {
    let abscissa = get_abscissa(ng_c[i])
    let (left_value, right_value) = eval_pair(abscissa)
    let function_sum = left_value + right_value
    result_10 = result_10 + wg_10[i] * function_sum
    result_21 = result_21 + wg_21a[i] * function_sum
    result_abs = result_abs + wg_21a[i] * (left_value.abs() + right_value.abs())
    func_values.push(function_sum)
    func_vals_left_10.push(left_value)
    func_vals_right_10.push(right_value)
  }
  for i in 0..<5 {
    let abscissa = get_abscissa(ng_21[i])
    let (left_value, right_value) = eval_pair(abscissa)
    let function_sum = left_value + right_value
    result_21 = result_21 + wg_21b[i] * function_sum
    result_abs = result_abs + wg_21b[i] * (left_value.abs() + right_value.abs())
    func_values.push(function_sum)
    func_vals_left_21.push(left_value)
    func_vals_right_21.push(right_value)
  }
  result_abs = result_abs * abs_half_interval
  let mean_value = 0.5 * result_21
  result_asc = wg_21b[5] * (center_value - mean_value).abs()
  for i in 0..<5 {
    result_asc = result_asc +
      wg_21a[i] *
      (
        (func_vals_left_10[i] - mean_value).abs() +
        (func_vals_right_10[i] - mean_value).abs()
      ) +
      wg_21b[i] *
      (
        (func_vals_left_21[i] - mean_value).abs() +
        (func_vals_right_21[i] - mean_value).abs()
      )
  }
  result_asc = result_asc * abs_half_interval
  let mut integral_result = result_21 * abs_half_interval
  let mut error = rescale_error(
    (result_21 - result_10) * half_interval,
    result_abs,
    result_asc,
  )
  if error < epsabs || error < epsrel * integral_result.abs() {
    return Ok((integral_result, error, 21))
  }
  let mut result_43 = 0.0
  result_43 = wg_43b[11] * center_value
  for i in 0..<10 {
    result_43 = result_43 + wg_43a[i] * func_values[i]
  }
  for i in 0..<11 {
    let abscissa = get_abscissa(ng_43[i])
    let (left_value, right_value) = eval_pair(abscissa)
    let function_sum = left_value + right_value
    result_43 = result_43 + wg_43b[i] * function_sum
    func_values.push(function_sum)
  }
  integral_result = result_43 * abs_half_interval
  error = rescale_error(
    (result_43 - result_21) * half_interval,
    result_abs,
    result_asc,
  )
  if error < epsabs || error < epsrel * integral_result.abs() {
    return Ok((integral_result, error, 43))
  }
  let mut result_87 = wg_87b[22] * center_value
  for i in 0..<21 {
    result_87 = result_87 + wg_87a[i] * func_values[i]
  }
  for i in 0..<22 {
    let abscissa = get_abscissa(ng_87[i])
    let (left_value, right_value) = eval_pair(abscissa)
    let function_sum = left_value + right_value
    result_87 = result_87 + wg_87b[i] * function_sum
  }
  integral_result = result_87 * abs_half_interval
  error = rescale_error(
    (result_87 - result_43) * half_interval,
    result_abs,
    result_asc,
  )
  if error < epsabs || error < epsrel * integral_result.abs() {
    return Ok((integral_result, error, 87))
  }
  Err(E_FAILED)
}
