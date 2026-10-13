///|
test "Maclaurin oracle approximates exp at one" {
  let series = @power_series.maclaurin_from_derivatives(
    fn(_) { 1.0 },
    12,
    @lf_arith.ArithmeticContext::new(53),
  ).unwrap()
  inspect(
    (series.evaluate(1.0) - 2.718281828459045).abs() < 1.0e-8,
    content="true",
  )
}

///|
test "derivative and antiderivative preserve coefficients" {
  let source = @power_series.PowerSeries::from_coefficients([1.0, 2.0, 3.0])
  let restored = source
    .derivative()
    .antiderivative(@lf_arith.ArithmeticContext::new(53))
    .unwrap()
  inspect(restored.coefficient(1).unwrap(), content="2")
  inspect(restored.coefficient(2).unwrap(), content="3")
}

///|
test "Decimal Maclaurin coefficients use contextual division" {
  let context = @lf_arith.ArithmeticContext::decimal64()
  let series = @power_series.maclaurin_from_derivatives(
    fn(_) { @decimal.Decimal::one(precision=16) },
    5,
    context,
  ).unwrap()
  inspect(
    series.coefficient(3).unwrap().to_string(),
    content="0.1666666666666667",
  )
}

///|
test "evaluate uses Horner's scheme" {
  // 1 + 2x + 3x^2 at x = 2 is 17.
  let series = @power_series.PowerSeries::from_coefficients([1.0, 2.0, 3.0])
  inspect(series.evaluate(2.0), content="17")
  inspect(series.order(), content="2")
  inspect(series.coefficient(3) is None, content="true")
}

///|
test "derivative of a constant series is zero" {
  let series = @power_series.PowerSeries::from_coefficients([5.0])
  let derivative = series.derivative()
  inspect(derivative.coefficient(0).unwrap(), content="0")
}

///|
test "Taylor coefficients about a point come from the derivative oracle" {
  // For f = x^3 all derivatives at 1 are 1, 3, 6, 6, 0.
  let derivatives = [1.0, 3.0, 6.0, 6.0, 0.0]
  let series = @power_series.taylor_from_derivatives(
    fn(index) { derivatives[index] },
    4,
    @lf_arith.ArithmeticContext::new(53),
  ).unwrap()
  inspect(series.coefficient(0).unwrap(), content="1")
  inspect(series.coefficient(1).unwrap(), content="3")
  inspect(series.coefficient(2).unwrap(), content="3")
  inspect(series.coefficient(3).unwrap(), content="1")
}

///|
test "negative Taylor order is a domain error" {
  let result = @power_series.taylor_from_derivatives(
    fn(_) { 1.0 },
    -1,
    @lf_arith.ArithmeticContext::new(53),
  )
  inspect(result is Err(_), content="true")
}
