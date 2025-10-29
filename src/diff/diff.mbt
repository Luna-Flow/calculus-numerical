///|
/// Computes the numerical derivative of a function at a given point using
/// backward difference method with adaptive step size optimization.
///
/// Parameters:
///
/// * `f` : The mathematical function to be differentiated, taking a `Double`
///   input and returning a `Double` output.
/// * `x` : The point at which to compute the derivative.
///
/// Returns a tuple containing the estimated derivative value and the estimated
/// absolute error of the computation.
///
/// Example:
///
/// ```moonbit
/// test "diff_backward" {
///   let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
///   let (derivative, error) = diff_backward(f, 2.0)
///   inspect((derivative - 4.0).abs() < error, content="true")
/// }
/// ```
///
pub fn diff_backward(f : Func_Math, x : Double) -> (Double, Double) {
  // Define backward difference offsets
  let shifted_points : Array[Double] = [-2, -1, 0]

  // Function to compute perturbed x values
  fn perturb_x(n : Double) {
    n * @internal.machine_dbl_epsilon + x
  }

  shifted_points.map_inplace(perturb_x)

  // Evaluate function at perturbed points
  let function_values = shifted_points.map(f)

  // Compute divided differences using Neville’s recursion
  for k in 1..<4 {
    for i in 0..<(3 - k) {
      function_values[i] = (function_values[i + 1] - function_values[i]) /
        (shifted_points[i + k] - shifted_points[i])
    }
  }

  // Estimate the range of the derivative
  let mut deriv_estimate = arr_sum(function_values).abs()
  let error_threshold = 100.0 * @internal.machine_sqrt_dbl_epsilon
  deriv_estimate = max(deriv_estimate, error_threshold)

  // Compute optimal step size h
  let optimal_h = sqrt(
    @internal.machine_sqrt_dbl_epsilon * 0.5 / deriv_estimate,
  )
  let optimal_h = min(optimal_h, error_threshold)

  // Compute derivative and estimated error
  let derivative = (f(x) - f(x - optimal_h)) / optimal_h
  let estimated_error = (10.0 * deriv_estimate * optimal_h).abs()
  (derivative, estimated_error)
}

///|
/// Computes the numerical derivative of a function at a given point using
/// forward difference method with adaptive step size.
///
/// Parameters:
///
/// * `f` : A function that takes a `Double` and returns a `Double`. The
///   function to be differentiated.
/// * `x` : The point at which to compute the derivative.
///
/// Returns a tuple containing:
///
/// * The estimated derivative value using forward difference approximation
/// * The estimated absolute error of the computation
pub fn diff_forward(f : Func_Math, x : Double) -> (Double, Double) {
  // Define perturbation steps for forward difference calculation
  let perturbation_steps : Array[Double] = [0, 1, 2]

  // Perturb the input x by small multiples of machine epsilon
  fn perturb_x(perturb : Double) {
    perturb * @internal.machine_dbl_epsilon + x
  }

  // Apply the perturbation to all steps in the array
  perturbation_steps.map_inplace(perturb_x)

  // Compute the function values at the perturbed steps
  let function_values = perturbation_steps.map(f)

  // Apply finite difference formulas to approximate the derivative
  for step_size in 1..<4 {
    for i in 0..<(3 - step_size) {
      function_values[i] = (function_values[i + 1] - function_values[i]) /
        (perturbation_steps[i + step_size] - perturbation_steps[i])
    }
  }

  // Calculate the magnitude of the accumulated finite differences
  let absolute_sum = arr_sum(function_values).abs()

  // Use a constant threshold to control the error propagation
  let error_threshold = 100.0 * @internal.machine_sqrt_dbl_epsilon
  let absolute_sum = max(absolute_sum, error_threshold)

  // Determine the step size for numerical differentiation
  let optimal_step_size = sqrt(
    @internal.machine_sqrt_dbl_epsilon * 0.5 / absolute_sum,
  )
  let final_step_size = min(optimal_step_size, error_threshold)

  // Calculate the forward difference derivative and error estimate
  (
    (f(x + final_step_size) - f(x)) / final_step_size,
    @double.abs(10.0 * absolute_sum * final_step_size),
  )
}

///|
/// Computes the numerical derivative of a function at a given point using
/// central difference method with adaptive step size. 
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
///   inspect((derivative - 4.0).abs() < error, content="true")
/// }
/// ```
/// @coverage.skip
pub fn diff_central(f : Func_Math, x : Double) -> (Double, Double) {
  // Define perturbation steps for central difference calculation
  let perturbation_steps : Array[Double] = [-2, -1, 0, 1]

  // Perturb the input x by small multiples of machine epsilon
  fn perturb_x(perturb : Double) {
    perturb * @internal.machine_dbl_epsilon + x
  }

  // Apply the perturbation to all steps in the array
  perturbation_steps.map_inplace(perturb_x)

  // Compute the function values at the perturbed steps
  let function_values = perturbation_steps.map(f)

  // Apply finite difference formulas to approximate the derivative
  for step_size in 1..<5 {
    for i in 0..<(4 - step_size) {
      function_values[i] = (function_values[i + 1] - function_values[i]) /
        (perturbation_steps[i + step_size] - perturbation_steps[i])
    }
  }

  // Calculate the magnitude of the accumulated finite differences
  let absolute_sum = arr_sum(function_values).abs()

  // Use a constant threshold to control the error propagation
  let error_threshold = 100.0 * @internal.machine_sqrt_dbl_epsilon
  let absolute_sum = max(absolute_sum, error_threshold)

  // Determine the optimal step size for central difference method
  let optimal_step_size = pow(
    @internal.machine_sqrt_dbl_epsilon * 0.5 / absolute_sum,
    1.0 / 3.0,
  )

  // Control the step size with the error threshold
  let final_step_size = min(optimal_step_size, error_threshold)

  // Calculate the central difference derivative and the error estimate
  (
    (f(x + final_step_size) - f(x - final_step_size)) * 0.5 / final_step_size,
    (100.0 * absolute_sum * final_step_size * final_step_size).abs(),
  )
}
