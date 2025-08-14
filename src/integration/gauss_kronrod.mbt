///|@coverage.skip
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
/// Performs numerical integration using Gauss-Kronrod quadrature rule of degree
/// 15 (7-15 pair) on a given function over a specified interval.
///
/// Parameters:
///
/// * `integrand` : A function that takes a `Double` and returns a `Double`. This
/// is the function to be integrated.
/// * `lower_bound` : The lower bound of the integration interval.
/// * `upper_bound` : The upper bound of the integration interval.
///
/// Returns a tuple containing:
///
/// * The approximation of the integral using Kronrod quadrature
/// * The absolute value of the integral approximation
/// * The absolute central difference approximation
/// * The estimated error of the integration
///
/// Example:
///
/// ```moonbit
/// test "kronrod_r15" {
///   // Integrate x^2 from 0 to 1
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, _, _, error) = kronrod_r15(f, 0.0, 1.0)
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
///   inspect!(@double.round(error * 1000.0) / 1000.0, content="0.000")
/// }
/// ```
/// @coverage.skip
pub fn kronrod_r15(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(8, xgk_r15, wg_r15, wgk_r15, f, a, b)
}

///|
/// Performs numerical integration using Gauss-Kronrod quadrature rule of degree
/// 21 (10-21 pair) on a given function over a specified interval.
///
/// Parameters:
///
/// * `integrand` : A function that takes a `Double` and returns a `Double`. This
/// is the function to be integrated.
/// * `lower_bound` : The lower bound of the integration interval.
/// * `upper_bound` : The upper bound of the integration interval.
///
/// Returns a tuple containing:
///
/// * The approximation of the integral using Kronrod quadrature
/// * The absolute value of the integral approximation
/// * The absolute central difference approximation
/// * The estimated error of the integration
///
/// Example:
///
/// ```moonbit
/// test "kronrod_r21" {
///   // Integrate x^2 from 0 to 1
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, _, _, error) = kronrod_r21(f, 0.0, 1.0)
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
///   inspect!(@double.round(error * 1000.0) / 1000.0, content="0.000")
/// }
/// ```
/// @coverage.skip
pub fn kronrod_r21(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(11, xgk_r21, wg_r21, wgk_r21, f, a, b)
}

///|
/// Performs numerical integration using Gauss-Kronrod quadrature rule of degree
/// 31 (15-31 pair) on a given function over a specified interval. Provides
/// higher accuracy compared to `kronrod_r15` and `kronrod_r21` at the cost of
/// more function evaluations.
///
/// Parameters:
///
/// * `integrand` : A function that takes a `Double` and returns a `Double`. This
/// is the function to be integrated.
/// * `lower_bound` : The lower bound of the integration interval.
/// * `upper_bound` : The upper bound of the integration interval.
///
/// Returns a tuple containing:
///
/// * The approximation of the integral using Kronrod quadrature
/// * The absolute value of the integral approximation
/// * The absolute central difference approximation
/// * The estimated error of the integration
///
/// Example:
///
/// ```moonbit
/// test "kronrod_r31" {
///   // Integrate x^2 from 0 to 1
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, _, _, error) = kronrod_r31(f, 0.0, 1.0)
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
///   inspect!(@double.round(error * 1000.0) / 1000.0, content="0.000")
/// }
/// ```
/// @coverage.skip
pub fn kronrod_r31(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(16, xgk_r31, wg_r31, wgk_r31, f, a, b)
}

///|
/// Performs numerical integration using Gauss-Kronrod quadrature rule of degree
/// 41 (20-41 pair) on a given function over a specified interval. This method
/// provides a higher degree of accuracy compared to lower-order rules like
/// `kronrod_r15`, making it suitable for integrating functions with moderate
/// complexity.
///
/// Parameters:
///
/// * `integrand` : A function that takes a `Double` and returns a `Double`. This
/// is the function to be integrated.
/// * `lower_bound` : The lower bound of the integration interval.
/// * `upper_bound` : The upper bound of the integration interval.
///
/// Returns a tuple containing:
///
/// * The approximation of the integral using Kronrod quadrature
/// * The absolute value of the integral approximation
/// * The absolute central difference approximation
/// * The estimated error of the integration
///
/// Example:
///
/// ```moonbit
/// test "kronrod_r41" {
///   // Integrate x^2 from 0 to 1
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, _, _, error) = kronrod_r41(f, 0.0, 1.0)
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
///   inspect!(@double.round(error * 1000.0) / 1000.0, content="0.000")
/// }
/// ```
/// @coverage.skip
pub fn kronrod_r41(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(21, xgk_r41, wg_r41, wgk_r41, f, a, b)
}

///|
/// Performs numerical integration using Gauss-Kronrod quadrature rule of degree
/// 51 (25-51 pair) on a given function over a specified interval. This method
/// provides highly accurate numerical integration results by using 51 evaluation
/// points for the Kronrod rule and 25 points for the embedded Gauss rule.
///
/// Parameters:
///
/// * `integrand` : A function that maps a real number to a real number (type
/// `@internal.Func_Math`). This is the function to be integrated.
/// * `lower_bound` : The lower limit of the integration interval (type
/// `Double`).
/// * `upper_bound` : The upper limit of the integration interval (type
/// `Double`).
///
/// Returns a tuple of four components:
///
/// * The approximation of the integral using the Kronrod quadrature rule
/// * The absolute value of the integral approximation
/// * The absolute value of the central difference approximation
/// * The estimated error of the integration
///
/// Example:
///
/// ```moonbit
/// test "kronrod_r51" {
///   // Integrate x^2 from 0 to 1
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, _, _, error) = kronrod_r51(f, 0.0, 1.0)
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
///   inspect!(@double.round(error * 1000.0) / 1000.0, content="0.000")
/// }
/// ```
/// @coverage.skip
pub fn kronrod_r51(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(26, xgk_r51, wg_r51, wgk_r51, f, a, b)
}

///|
/// Performs numerical integration using Gauss-Kronrod quadrature rule of degree
/// 61 (30-61 pair) on a given function over a specified interval. This is the
/// highest-order rule available in this package, providing the most accurate
/// results at the cost of more function evaluations.
///
/// Parameters:
///
/// * `integrand` : A function that takes a `Double` and returns a `Double`. This
/// is the function to be integrated.
/// * `lower_bound` : The lower bound of the integration interval.
/// * `upper_bound` : The upper bound of the integration interval.
///
/// Returns a tuple containing:
///
/// * The approximation of the integral using Kronrod quadrature
/// * The absolute value of the integral approximation
/// * The absolute central difference approximation
/// * The estimated error of the integration
///
/// Example:
///
/// ```moonbit
/// test "kronrod_r61" {
///   // Integrate x^2 from 0 to 1
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, _, _, error) = kronrod_r61(f, 0.0, 1.0)
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
///   inspect!(@double.round(error * 1000.0) / 1000.0, content="0.000")
/// }
/// ```
/// @coverage.skip
pub fn kronrod_r61(
  f : Func_Math,
  a : Double,
  b : Double,
) -> (Double, Double, Double, Double) {
  gauss_kronrod(31, xgk_r61, wg_r61, wgk_r61, f, a, b)
}
