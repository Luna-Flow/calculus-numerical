///|
pub fn wynn_epsilon(
  term : (Int32) -> Double,
  max_terms~ : Int32 = 32,
  tolerance~ : Double = 1.0e-12,
) -> @core.Estimate[Double] {
  guard max_terms >= 3 && tolerance >= 0.0 else {
    return @core.Estimate::new(
      0.0,
      0.0,
      0,
      0,
      @core.NumericalStatus::InvalidInput,
    )
  }
  let table = Array::makei(max_terms + 1, fn(_) {
    Array::make(max_terms + 1, 0.0)
  })
  let mut partial = 0.0
  for index in 0..<max_terms {
    partial += term(index)
    table[1][index] = partial
  }
  let mut best = table[1][max_terms - 1]
  let mut previous = best
  let mut error = @double.infinity
  for column in 1..<max_terms {
    for row in 0..<(max_terms - column) {
      let difference = table[column][row + 1] - table[column][row]
      table[column + 1][row] = if difference == 0.0 {
        table[column - 1][row + 1]
      } else {
        table[column - 1][row + 1] + 1.0 / difference
      }
    }
    if column % 2 == 0 {
      best = table[column + 1][0]
      error = (best - previous).abs()
      if error <= tolerance {
        return @core.Estimate::new(
          best,
          error,
          max_terms,
          column,
          @core.NumericalStatus::Converged,
        )
      }
      previous = best
    }
  }
  @core.Estimate::new(
    best,
    error,
    max_terms,
    max_terms - 1,
    @core.NumericalStatus::MaxIterations,
  )
}
