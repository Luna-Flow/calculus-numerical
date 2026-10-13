///|
pub fn ridders(
  function : (Double) -> Double,
  point : Double,
  initial_step~ : Double = 0.1,
  max_iterations~ : Int32 = 10,
) -> @core.Estimate[Double] {
  guard initial_step > 0.0 && max_iterations > 0 else {
    return @core.Estimate::new(
      0.0,
      0.0,
      0,
      0,
      @core.NumericalStatus::InvalidInput,
    )
  }
  let contraction = 1.4
  let contraction_squared = contraction * contraction
  let table = Array::makei(max_iterations, fn(_) {
    Array::make(max_iterations, 0.0)
  })
  let mut step = initial_step
  let mut best = 0.0
  let mut best_error = @double.infinity
  let mut evaluations = 0
  for level in 0..<max_iterations {
    table[0][level] = (function(point + step) - function(point - step)) /
      (2.0 * step)
    evaluations += 2
    if level == 0 {
      best = table[0][0]
    }
    let mut factor = contraction_squared
    for order in 1..<=level {
      table[order][level] = (
          factor * table[order - 1][level] - table[order - 1][level - 1]
        ) /
        (factor - 1.0)
      let error = @cmp.maximum(
        (table[order][level] - table[order - 1][level]).abs(),
        (table[order][level] - table[order - 1][level - 1]).abs(),
      )
      if error < best_error {
        best_error = error
        best = table[order][level]
      }
      factor *= contraction_squared
    }
    if level > 0 &&
      (table[level][level] - table[level - 1][level - 1]).abs() >=
      2.0 * best_error {
      return @core.Estimate::new(
        best,
        best_error,
        evaluations,
        level + 1,
        @core.NumericalStatus::Converged,
      )
    }
    step /= contraction
  }
  @core.Estimate::new(
    best,
    best_error,
    evaluations,
    max_iterations,
    @core.NumericalStatus::MaxIterations,
  )
}
