///|
/// Performs Gauss-Kronrod quadrature integration of a function over a specified
/// interval.
///
/// Parameters:
///
/// * `n` : The number of Kronrod points in the quadrature rule.
/// * `xgk` : Array of abscissae (evaluation points) for the Kronrod rule.
/// * `wg` : Array of weights for the Gauss quadrature rule.
/// * `wgk` : Array of weights for the Kronrod quadrature rule.
/// * `f` : The mathematical function to integrate.
/// * `a` : The lower bound of the integration interval.
/// * `b` : The upper bound of the integration interval.
///
/// Returns a tuple containing four values:
///
/// 1. The Kronrod quadrature approximation of the integral
/// 2. The absolute value of the Kronrod approximation
/// 3. The absolute sum contribution used for error estimation
/// 4. The rescaled error estimate between Gauss and Kronrod approximations
///
fn gauss_kronrod(
  n : Int,
  xgk : Array[Double],
  wg : Array[Double],
  wgk : Array[Double],
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  let center = 0.5 * (a + b)
  let half_length = 0.5 * (b - a)
  let abs_half_length = half_length.abs()
  let f_center = f(center)
  let mut result_gauss : Double = 0
  let mut result_kronrod = f_center * wgk[n - 1]
  let mut result_abs = result_kronrod.abs()
  let mut result_asc : Double = 0
  let fv1 : Array[Double] = zero_arr(n)
  let fv2 : Array[Double] = zero_arr(n)
  if n % 2 == 0 {
    result_gauss = f_center * wg[n / 2 - 1]
  }
  for i in 0..<((n - 1) / 2) {
    let jtw = 2 * i + 1
    let abscissa = half_length * xgk[jtw]
    let fval1 = f(center - abscissa)
    let fval2 = f(center + abscissa)
    let fsum = fval1 + fval2
    fv1[jtw] = fval1
    fv2[jtw] = fval2
    result_gauss = result_gauss + wg[i] * fsum
    result_kronrod = result_kronrod + wgk[jtw] * fsum
    result_abs = result_abs + wgk[jtw] * (fval1.abs() + fval2.abs())
  }
  for i in 0..<(n / 2) {
    let jtwm1 = 2 * i
    let abscissa = half_length * xgk[jtwm1]
    let fval1 = f(center - abscissa)
    let fval2 = f(center + abscissa)
    fv1[jtwm1] = fval1
    fv2[jtwm1] = fval2
    result_kronrod = result_kronrod + wgk[jtwm1] * (fval1 + fval2)
    result_abs = result_abs + wgk[jtwm1] * (fval1.abs() + fval2.abs())
  }
  let mean = result_kronrod * 0.5
  result_asc = wgk[n - 1] * (f_center - mean).abs()
  for i in 0..<(n - 1) {
    result_asc = result_asc +
      wgk[i] * ((fv1[i] - mean).abs() + (fv2[i] - mean).abs())
  }
  let err = (result_kronrod - result_gauss) * half_length
  result_kronrod = result_kronrod * half_length
  result_abs = result_abs * abs_half_length
  result_asc = result_asc * abs_half_length
  (
    result_kronrod,
    result_abs,
    result_asc,
    rescale_error(err, result_abs, result_asc),
  )
}

///|
/// Performs numerical integration using the 15-point Gauss-Kronrod quadrature
/// rule.
///
/// Parameters:
///
/// * `f` : The mathematical function to integrate.
/// * `a` : The lower bound of the integration interval.
/// * `b` : The upper bound of the integration interval.
///
/// Returns a tuple containing four values: the Kronrod approximation of the
/// integral, the absolute value approximation, the absolute scaled convergence
/// approximation, and the error estimate.
pub fn kronrod_r15(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(8, xgk_r15, wg_r15, wgk_r15, f, a, b)
}

///|
/// Computes the definite integral of a function using the 21-point
/// Gauss-Kronrod quadrature rule.
///
/// Parameters:
///
/// * `f` : The function to integrate.
/// * `a` : The lower bound of integration.
/// * `b` : The upper bound of integration.
///
/// Returns a tuple containing four values:
///
/// * The approximated integral value using Kronrod quadrature
/// * The absolute value estimate used for error bounds
/// * The absolute sum of contributions estimate used for error bounds
/// * The estimated absolute error of the integration
///
/// Example:
///
/// ```moonbit
/// // Integrate x^2 from 0 to 1
/// let f = fn(x) { x * x }
/// let (result, abs_est, asc_est, error) = kronrod_r21(f, 0.0, 1.0)
/// // result should be approximately 1/3 ≈ 0.333...
/// ```
///
pub fn kronrod_r21(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(11, xgk_r21, wg_r21, wgk_r21, f, a, b)
}

///|
/// Computes the definite integral of a function using the 31-point
/// Gauss-Kronrod quadrature rule.
///
/// Parameters:
///
/// * `f` : The function to integrate.
/// * `a` : The lower bound of integration.
/// * `b` : The upper bound of integration.
///
/// Returns a tuple containing four values: the integral approximation, the
/// absolute value of the integral, the absolute sum for error estimation, and
/// the estimated error bound.
///
/// Example:
///
/// ```moonbit
/// // Integrate x^2 from 0 to 1
/// let f = fn(x) { x * x }
/// let (result, abs_result, asc, error) = kronrod_r31(f, 0.0, 1.0)
/// // result should be approximately 1/3 ≈ 0.3333
/// ```
///
pub fn kronrod_r31(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(16, xgk_r31, wg_r31, wgk_r31, f, a, b)
}

///|
/// Computes the definite integral of a function using the 41-point
/// Gauss-Kronrod quadrature rule.
///
/// Parameters:
///
/// * `f` : The function to integrate.
/// * `a` : The lower bound of the integration interval.
/// * `b` : The upper bound of the integration interval.
///
/// Returns a tuple containing four values: the Kronrod approximation of the
/// integral, the absolute value of the integral, the absolute sum contribution,
/// and the estimated error bound.
///
/// Example:
///
/// ```moonbit
/// // Integrate x^2 from 0 to 1
/// let f = fn(x) { x * x }
/// let (result, abs_result, asc, error) = kronrod_r41(f, 0.0, 1.0)
/// // result should be approximately 1/3 ≈ 0.333...
/// ```
///
pub fn kronrod_r41(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(21, xgk_r41, wg_r41, wgk_r41, f, a, b)
}

///|
/// Computes the definite integral of a function using the 51-point
/// Gauss-Kronrod quadrature rule.
///
/// Parameters:
///
/// * `f` : The function to integrate.
/// * `a` : The lower bound of the integration interval.
/// * `b` : The upper bound of the integration interval.
///
/// Returns a tuple containing four values: the Kronrod approximation of the
/// integral, the absolute value of the integral approximation, the absolute sum
/// contribution, and the error estimate.
///
/// Example:
///
/// ```moonbit
/// // Integrate x^2 from 0 to 1
/// let square = fn(x) { x * x }
/// let (result, abs_val, abs_sum, error) = kronrod_r51(square, 0.0, 1.0)
/// // Result should be approximately 1/3 ≈ 0.333333
/// ```
///
pub fn kronrod_r51(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(26, xgk_r51, wg_r51, wgk_r51, f, a, b)
}

///|
/// Computes the definite integral of a function using the 61-point
/// Gauss-Kronrod quadrature rule.
///
/// Parameters:
///
/// * `f` : The function to integrate.
/// * `a` : The lower bound of the integration interval.
/// * `b` : The upper bound of the integration interval.
///
/// Returns a tuple containing four values: the Kronrod approximation of the
/// integral, the absolute value estimate, the absolute scaled error estimate,
/// and the rescaled error estimate.
///
/// Example:
///
/// ```moonbit
/// let f = fn(x) { x * x }  // Function f(x) = x²
/// let (integral, abs_val, abs_err, err) = @integration.kronrod_r61(f, 0.0, 2.0)
/// // Computes ∫₀² x² dx = 8/3 ≈ 2.667
/// ```
///
pub fn kronrod_r61(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(31, xgk_r61, wg_r61, wgk_r61, f, a, b)
}
