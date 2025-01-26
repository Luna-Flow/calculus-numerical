///|
/// Represents arbitrary-precision integers with different internal
/// representations for efficient storage and computation.
///
/// Provides three variants for different integer sizes:
///
/// * `IntegerInt`: For 32-bit integers
/// * `IntegerInt64`: For 64-bit integers
/// * `Integer`: For arbitrary-precision integers using BigInt
///
/// This type is primarily used as an intermediate representation in numerical
/// computations where the size of integers may vary significantly.
///
/// Parameters:
///
/// * `Int` : A 32-bit signed integer value for the `IntegerInt` variant
/// * `Int64` : A 64-bit signed integer value for the `IntegerInt64` variant
/// * `BigInt` : An arbitrary-precision integer value for the `Integer` variant
///
/// Example:
///
/// ```moonbit
/// test "Integer" {
///   let a = IntegerInt(42)
///   let b = IntegerInt64(9223372036854775807L)
///   let c = Integer(9223372036854775808N)
///   inspect!(a, content="IntegerInt(42)")
///   inspect!(b, content="IntegerInt64(9223372036854775807)")
///   inspect!(c, content="Integer(9223372036854775808)")
/// }
/// ```
pub(all) enum Integer {
  IntegerInt(Int)
  IntegerInt64(Int64)
  Integer(BigInt)
}

///|
pub let integer_zero : Integer = IntegerInt(0)

///|
pub let integer_one : Integer = IntegerInt(1)
