///|
pub struct PowerSeries[T] {
  coefficients : Array[T]
}

///|
pub fn[T] PowerSeries::from_coefficients(
  coefficients : Array[T],
) -> PowerSeries[T] {
  { coefficients, }
}

///|
pub fn[T] PowerSeries::order(self : PowerSeries[T]) -> Int32 {
  self.coefficients.length() - 1
}

///|
pub fn[T] PowerSeries::coefficient(self : PowerSeries[T], order : Int32) -> T? {
  self.coefficients.get(order)
}

///|
pub fn[T : @lf_alg.AddMonoid + Mul] PowerSeries::evaluate(
  self : PowerSeries[T],
  value : T,
) -> T {
  let mut result = @lf_alg.Zero::zero()
  for index = self.coefficients.length() - 1; index >= 0; index = index - 1 {
    result = result * value + self.coefficients[index]
  }
  result
}

///|
pub fn[T : @lf_alg.FromNat + @lf_alg.Zero + Mul] PowerSeries::derivative(
  self : PowerSeries[T],
) -> PowerSeries[T] {
  if self.coefficients.length() <= 1 {
    return PowerSeries::from_coefficients([@lf_alg.Zero::zero()])
  }
  PowerSeries::from_coefficients(
    Array::makei(self.coefficients.length() - 1, fn(index) {
      @lf_alg.FromNat::from_natural(BigInt::from_int(index + 1)) *
      self.coefficients[index + 1]
    }),
  )
}

///|
pub fn[T : @lf_alg.FromInteger + @lf_alg.Zero + @lf_arith.DivContextual] PowerSeries::antiderivative(
  self : PowerSeries[T],
  context : @lf_arith.ArithmeticContext,
) -> Result[PowerSeries[T], @lf_arith.ArithmeticError] {
  let coefficients = Array::make(
    self.coefficients.length() + 1,
    @lf_alg.Zero::zero(),
  )
  for index in 0..<self.coefficients.length() {
    let denominator : T = @lf_alg.FromInteger::from_integer(
      BigInt::from_int(index + 1),
    )
    match
      @lf_arith.DivContextual::div_contextual(
        self.coefficients[index],
        denominator,
        context,
      ) {
      Err(error) => return Err(error)
      Ok(outcome) => coefficients[index + 1] = outcome.value
    }
  }
  Ok(PowerSeries::from_coefficients(coefficients))
}

///|
pub fn[T : @lf_alg.FromInteger + @lf_alg.One + Mul + @lf_arith.DivContextual] taylor_from_derivatives(
  derivative : (Int32) -> T,
  order : Int32,
  context : @lf_arith.ArithmeticContext,
) -> Result[PowerSeries[T], @lf_arith.ArithmeticError] {
  guard order >= 0 else {
    return Err(@lf_arith.ArithmeticError::domain_error("negative Taylor order"))
  }
  let coefficients = Array::make(order + 1, @lf_alg.One::one())
  let mut factorial = @lf_alg.One::one()
  for index in 0..<=order {
    if index > 1 {
      let factor : T = @lf_alg.FromInteger::from_integer(
        BigInt::from_int(index),
      )
      factorial = factorial * factor
    }
    match
      @lf_arith.DivContextual::div_contextual(
        derivative(index),
        factorial,
        context,
      ) {
      Err(error) => return Err(error)
      Ok(outcome) => coefficients[index] = outcome.value
    }
  }
  Ok(PowerSeries::from_coefficients(coefficients))
}

///|
pub fn[T : @lf_alg.FromInteger + @lf_alg.One + Mul + @lf_arith.DivContextual] maclaurin_from_derivatives(
  derivative : (Int32) -> T,
  order : Int32,
  context : @lf_arith.ArithmeticContext,
) -> Result[PowerSeries[T], @lf_arith.ArithmeticError] {
  taylor_from_derivatives(derivative, order, context)
}
