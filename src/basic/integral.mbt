///|
/// Defines a trait for types that can be converted to arbitrary-precision
/// integers. Requires the implementing type to also implement `Eq`, `Compare`,
/// and `Show` traits.
///
/// The trait provides a method `to_integer` that converts values of the
/// implementing type to the `Integer` type, which can represent numbers of
/// arbitrary size through its variants: `IntegerInt` (32-bit), `IntegerInt64`
/// (64-bit), and `Integer` (arbitrary precision).
///
/// Parameters:
///
/// * `Self` : The type implementing this trait. Must be comparable for equality
/// (`Eq`), orderable (`Compare`), and convertible to string representation
/// (`Show`).
///
/// Returns an `Integer` value representing the original number with appropriate
/// precision.
///
/// Example:
///
/// ```moonbit
/// test "Integral" {
///   let x : Int = 42
///   let y : Int64 = 9223372036854775807L
///   inspect!(Integral::to_integer(x), content="IntegerInt(42)")
///   inspect!(Integral::to_integer(y), content="IntegerInt64(9223372036854775807)")
/// }
/// ```
pub(open) trait Integral: Eq + Compare + Show {
  to_integer(Self) -> Integer
}

///|
/// Implements the `Integral` trait for the 32-bit integer type `Int`, providing
/// a conversion to the `Integer` type using the `IntegerInt` variant.
///
/// Parameters:
///
/// * `value` : A 32-bit integer value to be converted to `Integer`.
///
/// Returns an `Integer` value using the `IntegerInt` variant to store the
/// original 32-bit integer value.
///
/// Example:
///
/// ```moonbit
/// test "Integral::to_integer/int" {
///   let x : Int = 42
///   inspect!(Integral::to_integer(x), content="IntegerInt(42)")
/// }
/// ```
pub impl Integral for Int with to_integer(self) { IntegerInt(self) }

///|
/// Implements the `Integral` trait for the 64-bit integer type `Int64`,
/// providing a conversion to the `Integer` type. Chooses the most efficient
/// representation based on the value's range.
///
/// Parameters:
///
/// * `value` : A 64-bit integer to be converted to `Integer`. Values within
/// 32-bit range are stored using `IntegerInt`, while larger values use
/// `IntegerInt64`.
///
/// Returns an `Integer` value using either `IntegerInt` or `IntegerInt64`
/// variant based on the input value's range.
///
/// Example:
///
/// ```moonbit
/// test "Integral::to_integer/int64" {
///   let small : Int64 = 42L
///   let large : Int64 = 9223372036854775807L
///   inspect!(Integral::to_integer(small), content="IntegerInt(42)")
///   inspect!(
///     Integral::to_integer(large),
///     content="IntegerInt64(9223372036854775807)",
///   )
/// }
/// ```
pub impl Integral for Int64 with to_integer(self) {
  if self >= @int.min_value.to_int64() && self <= @int.max_value.to_int64() {
    IntegerInt(self.to_int())
  } else {
    IntegerInt64(self)
  }
}

///|
/// Provides implementation of the `Integral` trait for `BigInt` type, converting
/// arbitrary-precision integers to the most efficient `Integer` representation
/// based on their magnitude.
///
/// Parameters:
///
/// * `self` : The `BigInt` value to be converted.
///
/// Returns an `Integer` variant that best fits the value:
///
/// * `integer_zero` for zero
/// * `integer_one` for one
/// * `IntegerInt` for values within 32-bit range
/// * `IntegerInt64` for values within 64-bit range
/// * `Integer` for larger values
///
/// Example:
///
/// ```moonbit
/// test "BigInt::to_integer" {
///   let small = BigInt::from_int(42)
///   let large = BigInt::from_string("9223372036854775808").unwrap()
///   inspect!(Integral::to_integer(small), content="IntegerInt(42)")
///   inspect!(Integral::to_integer(large), content="Integer(9223372036854775808)")
/// }
/// ```
pub impl Integral for BigInt with to_integer(self) {
  if self.is_zero() {
    integer_zero
  } else if self == 1 {
    integer_one
  } else if self <= 2147483647N && self >= -2147483648N {
    IntegerInt(self.to_int())
  } else if self <= 9223372036854775807N && self >= -9223372036854775808N {
    IntegerInt64(self.to_int64())
  } else {
    Integer(self)
  }
}
