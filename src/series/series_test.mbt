///|
test "compensated sums recover a cancelled unit" {
  let values : ReadOnlyArray[Double] = [1.0e16, 1.0, -1.0e16]
  inspect(@series.naive_sum(values), content="0")
  inspect(@series.neumaier_sum(values), content="1")
}

///|
test "Wynn epsilon accelerates the alternating harmonic series" {
  let result = @series.wynn_epsilon(fn(index) {
    let denominator = (index + 1).to_double()
    if index % 2 == 0 {
      1.0 / denominator
    } else {
      -1.0 / denominator
    }
  })
  inspect((result.value - 0.6931471805599453).abs() < 1.0e-10, content="true")
}

///|
test "pairwise, Kahan and Neumaier sums handle more than one pairwise block" {
  // 40 terms exceed the 16-term leaf of the pairwise recursion.
  let view : ReadOnlyArray[Double] = [
    0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
    0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
    0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
  ]
  inspect((@series.pairwise_sum(view) - 4.0).abs() < 1.0e-14, content="true")
  inspect((@series.kahan_sum(view) - 4.0).abs() < 1.0e-15, content="true")
  inspect((@series.neumaier_sum(view) - 4.0).abs() < 1.0e-15, content="true")
}

///|
test "sums of an empty array are zero" {
  let values : ReadOnlyArray[Double] = []
  inspect(@series.naive_sum(values), content="0")
  inspect(@series.pairwise_sum(values), content="0")
  inspect(@series.kahan_sum(values), content="0")
  inspect(@series.neumaier_sum(values), content="0")
}

///|
test "Wynn epsilon sums the Leibniz series for pi" {
  let result = @series.wynn_epsilon(fn(index) {
    let sign = if index % 2 == 0 { 1.0 } else { -1.0 }
    sign / (2 * index + 1).to_double()
  })
  inspect((result.value - 0.7853981633974483).abs() < 1.0e-9, content="true")
}

///|
test "Wynn epsilon rejects too few terms" {
  let result = @series.wynn_epsilon(fn(_) { 1.0 }, max_terms=2)
  inspect(result.status == @core.NumericalStatus::InvalidInput, content="true")
}
