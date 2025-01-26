test "Integer" {
  let a : Integer = IntegerInt(42)
  let b : Integer = IntegerInt64(9223372036854775807L)
  let c : Integer = Integer(9223372036854775808N)
  let d : Integer = Integral::to_integer(17520)
  let e : Integer = Integral::to_integer(0N)
  inspect!(a, content="IntegerInt(42)")
  inspect!(b, content="IntegerInt64(9223372036854775807)")
  inspect!(c, content="Integer(9223372036854775808)")
  inspect!(d, content="IntegerInt(17520)")
  inspect!(e, content="IntegerInt(0)")
}
