///|
let nodes : ReadOnlyArray[Double] = [
  0.9956571630258081, 0.9739065285171717, 0.9301574913557082, 0.8650633666889845,
  0.7808177265864169, 0.6794095682990244, 0.5627571346686047, 0.4333953941292472,
  0.2943928627014602, 0.14887433898163122, 0.0,
]

///|
let gauss_weights : ReadOnlyArray[Double] = [
  0.06667134430868814, 0.1494513491505806, 0.21908636251598204, 0.26926671930999635,
  0.29552422471475287,
]

///|
let kronrod_weights : ReadOnlyArray[Double] = [
  0.011694638867371874, 0.03255816230796473, 0.054755896574351996, 0.07503967481091995,
  0.09312545458369761, 0.10938715880229764, 0.12349197626206585, 0.13470921731147333,
  0.14277593857706009, 0.1477391049013385, 0.1494455540029169,
]

///|
pub fn gauss_kronrod_21(
  function : (Double) -> Double,
  lower : Double,
  upper : Double,
) -> (Double, Double, Int32) {
  let midpoint = 0.5 * (lower + upper)
  let half_length = 0.5 * (upper - lower)
  let center_value = function(midpoint)
  let mut gauss = 0.0
  let mut kronrod = kronrod_weights[10] * center_value
  for index in 0..<10 {
    let offset = half_length * nodes[index]
    let pair = function(midpoint - offset) + function(midpoint + offset)
    kronrod += kronrod_weights[index] * pair
    if index % 2 == 1 {
      gauss += gauss_weights[index / 2] * pair
    }
  }
  let value = kronrod * half_length
  let error = ((kronrod - gauss) * half_length).abs()
  (value, error, 21)
}

///|
pub fn adaptive_gauss_kronrod(
  function : (Double) -> Double,
  lower : Double,
  upper : Double,
  absolute_tolerance~ : Double = 1.0e-10,
  relative_tolerance~ : Double = 1.0e-10,
  max_intervals~ : Int32 = 256,
) -> @core.Estimate[Double] {
  guard lower != upper &&
    absolute_tolerance >= 0.0 &&
    relative_tolerance >= 0.0 &&
    max_intervals > 0 else {
    return @core.Estimate::new(
      0.0,
      0.0,
      0,
      0,
      @core.NumericalStatus::InvalidInput,
    )
  }
  let (initial_value, initial_error, initial_evaluations) = gauss_kronrod_21(
    function, lower, upper,
  )
  let lowers = [lower]
  let uppers = [upper]
  let values = [initial_value]
  let errors = [initial_error]
  let mut total_value = initial_value
  let mut total_error = initial_error
  let mut evaluations = initial_evaluations
  let mut iterations = 0
  while lowers.length() < max_intervals {
    let tolerance = @cmp.maximum(
      absolute_tolerance,
      relative_tolerance * total_value.abs(),
    )
    if total_error <= tolerance {
      return @core.Estimate::new(
        total_value,
        total_error,
        evaluations,
        iterations,
        @core.NumericalStatus::Converged,
      )
    }
    let mut selected = 0
    for index in 1..<errors.length() {
      if errors[index] > errors[selected] {
        selected = index
      }
    }
    let selected_upper = uppers[selected]
    let midpoint = 0.5 * (lowers[selected] + selected_upper)
    let (left_value, left_error, left_evaluations) = gauss_kronrod_21(
      function,
      lowers[selected],
      midpoint,
    )
    let (right_value, right_error, right_evaluations) = gauss_kronrod_21(
      function, midpoint, selected_upper,
    )
    total_value += left_value + right_value - values[selected]
    total_error += left_error + right_error - errors[selected]
    uppers[selected] = midpoint
    values[selected] = left_value
    errors[selected] = left_error
    lowers.push(midpoint)
    uppers.push(selected_upper)
    values.push(right_value)
    errors.push(right_error)
    evaluations += left_evaluations + right_evaluations
    iterations += 1
  }
  let tolerance = @cmp.maximum(
    absolute_tolerance,
    relative_tolerance * total_value.abs(),
  )
  let status = if total_error <= tolerance {
    @core.NumericalStatus::Converged
  } else {
    @core.NumericalStatus::MaxIterations
  }
  @core.Estimate::new(total_value, total_error, evaluations, iterations, status)
}
