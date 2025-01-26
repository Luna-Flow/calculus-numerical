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

///|
/// Computes the result of raising a floating-point base to an integer exponent
/// using an efficient divide-and-conquer algorithm. Handles positive, negative,
/// and zero exponents correctly, including special cases for minimum integer
/// values.
///
/// Parameters:
///
/// * `base` : The floating-point number to be raised to a power.
/// * `exp` : The integer exponent, which can be a regular integer (`Int`), a
/// 64-bit integer (`Int64`), or an arbitrary-precision integer (`BigInt`).
///
/// Returns the result of `base` raised to the power of `exp`. Returns 1.0 when
/// `exp` is 0, and 1.0/result when `exp` is negative.
///
/// Example:
///
/// ```moonbit
/// test "pow_integer_exp" {
///   inspect!(pow_integer_exp(2.0, IntegerInt(3)), content="8.0")
///   inspect!(pow_integer_exp(2.0, IntegerInt(-2)), content="0.25")
///   inspect!(pow_integer_exp(2.0, IntegerInt(0)), content="1.0")
/// }
/// ```
pub fn pow_integer_exp(base : Double, exp : Integer) -> Double {
  match exp {
    IntegerInt(exp_int) =>
      if exp_int == 0 {
        1.0
      } else if exp_int == 1 {
        base
      } else if exp_int < 0 {
        if exp_int == @int.min_value {
          1.0 / pow_integer_exp(base, (-Int::to_int64(exp_int)).to_integer())
        } else {
          1.0 / pow_integer_exp(base, (-exp_int).to_integer())
        }
      } else if exp_int % 2 == 0 {
        let half_pow = pow_integer_exp(base, IntegerInt(exp_int / 2))
        half_pow * half_pow
      } else {
        let half_pow = pow_integer_exp(base, IntegerInt((exp_int - 1) / 2))
        half_pow * half_pow * base
      }
    IntegerInt64(exp_int64) =>
      if exp_int64 == 0 {
        1.0
      } else if exp_int64 == 1 {
        base
      } else if exp_int64 < 0 {
        if exp_int64 == @int64.min_value {
          1.0 /
          pow_integer_exp(base, (-BigInt::from_int64(exp_int64)).to_integer())
        } else {
          1.0 / pow_integer_exp(base, (-exp_int64).to_integer())
        }
      } else if exp_int64 % 2 == 0 {
        let half_pow = pow_integer_exp(base, (exp_int64 / 2).to_integer())
        half_pow * half_pow
      } else {
        let half_pow = pow_integer_exp(base, ((exp_int64 - 1) / 2).to_integer())
        half_pow * half_pow * base
      }
    Integer(exp_big_int) =>
      if exp_big_int == 0 {
        1.0
      } else if exp_big_int == 1 {
        base
      } else if exp_big_int < 0 {
        1.0 / pow_integer_exp(base, (-exp_big_int).to_integer())
      } else if exp_big_int % 2 == 0 {
        let half_pow = pow_integer_exp(base, (exp_big_int / 2).to_integer())
        half_pow * half_pow
      } else {
        let half_pow = pow_integer_exp(
          base,
          ((exp_big_int - 1) / 2).to_integer(),
        )
        half_pow * half_pow * base
      }
  }
}
