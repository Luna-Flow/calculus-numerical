///|
/// Computes the numerical derivative of a function at a given point using
/// backward difference method with adaptive step size. This implementation is
/// based on the GNU Scientific Library's differentiation module, providing a
/// balance between accuracy and numerical stability.
///
/// Parameters:
///
/// * `function` : A function that takes a `Double` and returns a `Double`. The
/// function to be differentiated.
/// * `point` : The point at which to compute the derivative.
///
/// Returns a tuple containing:
///
/// * The estimated derivative value using backward difference approximation
/// * The estimated absolute error of the computation
///
/// Example:
/// 
/// ```moonbit
/// test "diff_backward" {
///   let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
///   let (derivative, error) = diff_backward(f, 2.0)
///   inspect!((derivative - 4.0).abs() < error, content="true")
/// }
/// ```
/// @coverage.skip
pub fn diff_backward(f : @basic.Func_Math, x : Double) -> (Double, Double) {
  let a : Array[Double] = [-2, -1, 0]
  fn q(n : Double) {
    n * @internal.machine_dbl_epsilon + x
  }

  a.map_inplace(q)
  let d = a.map(f)
  for k = 1; k < 4; k = k + 1 {
    for i = 0; i < 3 - k; i = i + 1 {
      d[i] = (d[i + 1] - d[i]) / (a[i + k] - a[i])
    }
  }
  let mut a2 = @luna_utils.arr_sum_dbl(d).abs()
  let c = 100.0 * @internal.machine_sqrt_dbl_epsilon
  a2 = @luna_utils.max(a2, c)
  let mut h = @luna_math.sqrt(@internal.machine_sqrt_dbl_epsilon * 0.5 / a2)
  h = @luna_utils.min(h, c)
  ((f(x) - f(x - h)) / h, (10.0 * a2 * h).abs())
}

///|
/// Computes the numerical derivative of a function at a given point using
/// forward difference method with adaptive step size. This implementation is
/// based on the GNU Scientific Library's differentiation module, providing a
/// balance between accuracy and numerical stability.
///
/// Parameters:
///
/// * `function` : A function that takes a `Double` and returns a `Double`. The
/// function to be differentiated.
/// * `point` : The point at which to compute the derivative.
///
/// Returns a tuple containing:
///
/// * The estimated derivative value using forward difference approximation
/// * The estimated absolute error of the computation
///
/// Example:
///
/// ```moonbit
/// test "diff_forward" {
///   let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
///   let (derivative, error) = diff_forward(f, 2.0)
///   inspect!((derivative - 4.0).abs() < error, content="true")
/// }
/// ```
/// @coverage.skip
pub fn diff_forward(f : @basic.Func_Math, x : Double) -> (Double, Double) {
  let a : Array[Double] = [0, 1, 2]
  fn q(n : Double) {
    n * @internal.machine_dbl_epsilon + x
  }

  a.map_inplace(q)
  let d = a.map(f)
  for k = 1; k < 4; k = k + 1 {
    for i = 0; i < 3 - k; i = i + 1 {
      d[i] = (d[i + 1] - d[i]) / (a[i + k] - a[i])
    }
  }
  let mut a2 = @luna_utils.arr_sum_dbl(d).abs()
  let c = 100.0 * @internal.machine_sqrt_dbl_epsilon
  a2 = @luna_utils.max(a2, c)
  let mut h = @luna_math.sqrt(@internal.machine_sqrt_dbl_epsilon * 0.5 / a2)
  h = @luna_utils.min(h, c)
  ((f(x + h) - f(x)) / h, @double.abs(10.0 * a2 * h))
}

///|
/// Computes the numerical derivative of a function at a given point using
/// central difference method with adaptive step size. This implementation is
/// based on the GNU Scientific Library's differentiation module, providing
/// higher accuracy compared to forward and backward difference methods.
///
/// Parameters:
///
/// * `function` : A function that takes a `Double` and returns a `Double`. The
/// function to be differentiated.
/// * `point` : The point at which to compute the derivative.
///
/// Returns a tuple containing:
///
/// * The estimated derivative value using central difference approximation
/// * The estimated absolute error of the computation
///
/// Example:
///
/// ```moonbit
/// test "diff_central" {
///   let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
///   let (derivative, error) = diff_central(f, 2.0)
///   inspect!((derivative - 4.0).abs() < error, content="true")
/// }
/// ```
/// @coverage.skip
pub fn diff_central(f : @basic.Func_Math, x : Double) -> (Double, Double) {
  let a : Array[Double] = [-2, -1, 0, 1]
  fn q(n : Double) {
    n * @internal.machine_dbl_epsilon + x
  }

  a.map_inplace(q)
  let d = a.map(f)
  for k = 1; k < 5; k = k + 1 {
    for i = 0; i < 4 - k; i = i + 1 {
      d[i] = (d[i + 1] - d[i]) / (a[i + k] - a[i])
    }
  }
  let mut a3 = @luna_utils.arr_sum_dbl(d).abs()
  let c = 100.0 * @internal.machine_sqrt_dbl_epsilon
  a3 = @luna_utils.max(a3, c)
  let mut h = (@internal.machine_sqrt_dbl_epsilon * 0.5 / a3).pow(1.0 / 3.0)
  h = @luna_utils.min(h, c)
  ((f(x + h) - f(x - h)) * 0.5 / h, (100.0 * a3 * h * h).abs())
}
