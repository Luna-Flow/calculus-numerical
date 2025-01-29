///|
test "hypot" {
  assert_true!(hypot(3.0, 4.0) - 5.0 < 1.0e-7)
  assert_true!(hypot(1.0, 1.0) - 1.4142135623730951 < 1.0e-7)
  inspect!(hypot(@double.infinity, 1.0), content="Infinity")
}

///|
test "pow_integer_exp" {
  assert_true!(pow_integer_exp(2.0, IntegerInt(3)) - 8.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, IntegerInt(-2)) - 0.25 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, IntegerInt(0)) - 1.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, IntegerInt(1)) - 2.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, IntegerInt64(3)) - 8.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, IntegerInt64(-2)) - 0.25 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, IntegerInt64(0)) - 1.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, IntegerInt64(1)) - 2.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, Integer(3)) - 8.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, Integer(-2)) - 0.25 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, Integer(0)) - 1.0 < 1.0e-20)
  assert_true!(pow_integer_exp(2.0, Integer(1)) - 2.0 < 1.0e-20)
  assert_true!(
    pow_integer_exp(1.0 + 1.0e-20, IntegerInt(@int.min_value)) - 1.0 < 1.0e-20,
  )
  assert_true!(
    pow_integer_exp(1.0 + 1.0e-20, IntegerInt64(@int64.min_value)) - 1.0 <
    1.0e-20,
  )
}
