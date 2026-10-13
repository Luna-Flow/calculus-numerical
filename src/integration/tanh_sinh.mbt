///|
pub fn tanh_sinh(
  function : (Double) -> Double,
  lower : Double,
  upper : Double,
  step~ : Double = 0.125,
  tolerance~ : Double = 1.0e-12,
  max_terms~ : Int32 = 64,
) -> @core.Estimate[Double] {
  guard step > 0.0 && tolerance >= 0.0 && max_terms > 0 else {
    return @core.Estimate::new(
      0.0,
      0.0,
      0,
      0,
      @core.NumericalStatus::InvalidInput,
    )
  }
  let midpoint = 0.5 * (lower + upper)
  let half_length = 0.5 * (upper - lower)
  let half_pi = @math.PI * 0.5
  let mut sum = 0.0
  let mut last_pair = 0.0
  let mut evaluations = 0
  let mut iterations = 0
  for index in 0..<max_terms {
    let t = index.to_double() * step
    let sinh_t = @math.sinh(t)
    let transformed = @math.tanh(half_pi * sinh_t)
    if transformed >= 1.0 {
      return @core.Estimate::new(
        sum * step,
        last_pair,
        evaluations,
        iterations,
        @core.NumericalStatus::Converged,
      )
    }
    let denominator = @math.cosh(half_pi * sinh_t)
    let weight = half_length *
      half_pi *
      @math.cosh(t) /
      (denominator * denominator)
    let pair = if index == 0 {
      evaluations += 1
      weight * function(midpoint)
    } else {
      evaluations += 2
      weight *
      (
        function(midpoint - half_length * transformed) +
        function(midpoint + half_length * transformed)
      )
    }
    sum += pair
    last_pair = pair.abs() * step
    iterations += 1
    if index > 0 && last_pair <= tolerance {
      return @core.Estimate::new(
        sum * step,
        last_pair,
        evaluations,
        iterations,
        @core.NumericalStatus::Converged,
      )
    }
  }
  @core.Estimate::new(
    sum * step,
    last_pair,
    evaluations,
    iterations,
    @core.NumericalStatus::MaxIterations,
  )
}
