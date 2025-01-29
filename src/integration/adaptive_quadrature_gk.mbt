///|
/// Performs adaptive Gauss-Kronrod quadrature integration on a given function
/// over a specified interval. Recursively subdivides the interval until the
/// desired accuracy is achieved or certain error conditions are met.
///
/// Parameters:
///
/// * `integrand` : The function to be integrated. Takes a `Double` and returns a
/// `Double`.
/// * `quadrature` : The Gauss-Kronrod quadrature rule to be used for
/// integration. Can be one of `kronrod_r15`, `kronrod_r21`, `kronrod_r31`,
/// `kronrod_r41`, `kronrod_r51`, or `kronrod_r61`.
/// * `lower_bound` : The lower bound of the integration interval.
/// * `upper_bound` : The upper bound of the integration interval.
/// * `absolute_tolerance` : The absolute error tolerance. Must be positive.
/// * `relative_tolerance` : The relative error tolerance. Must be greater than
/// machine epsilon.
/// * `max_intervals` : Maximum number of subintervals allowed in the subdivision
/// process.
///
/// Returns a `Result` containing either:
///
/// * `Ok((result, error, status))` where:
///  * `result` is the approximated value of the integral
///  * `error` is the estimated absolute error
///  * `status` is one of:
///  * `"OK"`: Integration successful
///  * `"E_ROUND"`: Roundoff error detected
///  * `"E_SINGULARITY"`: Possible singularity or highly oscillatory integrand
///  * `"E_MAX_ITER"`: Maximum number of subdivisions reached
/// * `Err(error_message)` where `error_message` is one of:
///  * `"E_BAD_TOL"`: Invalid tolerance parameters
///  * `"E_FAILED"`: Integration failed to converge
///
/// Example:
///
/// ```moonbit
/// test "adap_quad_gk" {
///   // Integrate x^2 from 0 to 1
///   let f = fn(x : Double) -> Double { x * x }
///   let (result, _, _) = adap_quad_gk(
///     f, kronrod_r15, 0.0, 1.0, 1.0e-10, 1.0e-10, 100,
///   ).unwrap()
///   inspect!(@double.round(result * 1000.0) / 1000.0, content="0.333")
/// }
/// ```
/// @coverage.skip
pub fn adap_quad_gk(
  f : @basic.Func_Math,
  q : @basic.Quad_GK,
  a : Double,
  b : Double,
  epsabs : Double,
  epsrel : Double,
  limit : Int
) -> Result[(Double, Double, String), String] {
  let mut iteration : Int = 0
  let mut result : Double = 0
  let mut abserr : Double = 0
  let mut err_code : String = ""
  let workspace = IntegrationWorkspace::new(limit)
  if epsabs <= 0 && (epsrel < @internal.machine_dbl_epsilon || epsrel < 0.5e-28) {
    err_code = "E_BAD_TOL"
  } else {
    let (result_0, resabs_0, resasc_0, abserr_0) = q(f, a, b)
    IntegrationWorkspace::init(workspace, a, b, result_0, abserr_0)
    let mut tolerance = @luna_utils.max(epsabs, epsrel * result_0.abs())
    let round_off = 50.0 * @internal.machine_dbl_epsilon * resabs_0
    if abserr_0 <= round_off && abserr_0 > tolerance {
      result = result_0
      abserr = abserr_0
      err_code = "E_ROUND"
    } else if (abserr_0 <= tolerance && abserr_0 != resasc_0) || abserr_0 == 0.0 {
      result = result_0
      abserr = abserr_0
      err_code = "OK"
    } else if limit == 1 {
      result = result_0
      abserr = abserr_0
      err_code = "E_MAX_ITER"
    }
    let mut area = result_0
    let mut errsum = abserr_0
    iteration = 1
    let mut error_type = 0
    let mut roundoff_type_1 = 0
    let mut roundoff_type_2 = 0
    while iteration < limit && error_type == 0 && errsum > tolerance {
      let (a_i, b_i, r_i, e_i) = IntegrationWorkspace::retrieve(workspace)
      let a_1 = a_i
      let b_1 = 0.5 * (a_i + b_i)
      let a_2 = b_1
      let b_2 = b_i
      let (area_1, _, resasc_1, error_1) = q(f, a_1, b_1)
      let (area_2, _, resasc_2, error_2) = q(f, a_2, b_2)
      let area_12 = area_1 + area_2
      let error_12 = error_1 + error_2
      errsum = errsum + (error_12 - e_i)
      area = area + (area_12 - r_i)
      if resasc_1 != error_1 && resasc_2 != error_2 {
        let delta = r_i - area_2
        if delta.abs() <= 0.00001 * area_12.abs() && error_12 >= 0.99 * e_i {
          roundoff_type_1 = roundoff_type_1 + 1
        }
        if iteration >= 10 && error_12 > e_i {
          roundoff_type_2 = roundoff_type_2 + 1
        }
      }
      tolerance = @luna_utils.max(epsabs, epsrel * area.abs())
      if errsum > tolerance {
        if roundoff_type_1 >= 6 || roundoff_type_2 >= 20 {
          error_type = 2
        }
        if subinterval_check(a_1, a_2, b_2) {
          error_type = 3
        }
      }
      IntegrationWorkspace::update(
        workspace, a_1, b_1, area_1, error_1, a_2, b_2, area_2, error_2,
      )
      iteration = iteration + 1
    }
    result = @luna_utils.arr_sum_dbl(workspace.r_list)
    abserr = errsum
    if errsum <= tolerance {
      err_code = "OK"
    } else if error_type == 2 {
      err_code = "E_ROUND"
    } else if error_type == 3 {
      err_code = "E_SINGULARITY"
    } else if iteration == limit {
      err_code = "E_MAX_ITER"
    } else {
      err_code = "E_FAILED"
    }
  }
  if err_code == "E_FAILED" || err_code == "E_BAD_TOL" {
    Err(err_code)
  } else {
    Ok((result, abserr, err_code))
  }
}
