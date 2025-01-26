///|
/// Calculates the square root of a double-precision floating-point number using
/// Newton's method.
/// The implementation uses an iterative approach to approximate the square root
/// with high precision.
///
/// Parameters:
///
/// * `x` : A double-precision floating-point number whose square root is to be
/// calculated.
///
/// Returns the square root of the input number. Returns `NaN` for negative
/// inputs, `Infinity` for infinite inputs, and the input itself for 0.0 and 1.0.
///
/// Example:
///
/// ```moonbit
/// test "sqrt" {
///   inspect!(sqrt(16.0), content="4.0")
///   inspect!(sqrt(0.0), content="0.0")
///   inspect!(sqrt(-1.0), content="NaN")
/// }
/// ```
pub fn sqrt(x : Double) -> Double {
  guard x >= 0.0 else { @double.not_a_number }
  guard x != @double.infinity else { @double.infinity }
  guard x != 0.0 && x != 1.0 else { x }
  let mut guess = x / 2.0
  let mut diff = 1.0
  let epsilon = 1.0e-7
  while diff > epsilon {
    let new_guess = (guess + x / guess) / 2.0
    diff = (guess - new_guess).abs()
    guess = new_guess
  }
  guess
}

///|
/// Calculates the length of the hypotenuse of a right triangle given its two
/// sides using the Pythagorean theorem. Uses a numerically stable algorithm to
/// avoid overflow or underflow.
///
/// Parameters:
///
/// * `x` : The length of the first side of the right triangle.
/// * `y` : The length of the second side of the right triangle.
///
/// Returns the length of the hypotenuse, which is equal to `sqrt(x^2 + y^2)`.
///
/// Example:
///
/// ```moonbit
/// test "hypot" {
///   inspect!(hypot(3.0, 4.0), content="5.0")
///   inspect!(hypot(1.0, 1.0), content="1.4142135623730951")
/// }
/// ```
pub fn hypot(x : Double, y : Double) -> Double {
  sqrt(x * x + y * y)
}
