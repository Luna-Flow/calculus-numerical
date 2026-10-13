///|
pub fn naive_sum(values : ReadOnlyArray[Double]) -> Double {
  let mut sum = 0.0
  for value in values {
    sum += value
  }
  sum
}

///|
fn pairwise_range(
  values : ReadOnlyArray[Double],
  start : Int32,
  end : Int32,
) -> Double {
  let length = end - start
  if length <= 16 {
    let mut sum = 0.0
    for index in start..<end {
      sum += values[index]
    }
    return sum
  }
  let midpoint = start + length / 2
  pairwise_range(values, start, midpoint) +
  pairwise_range(values, midpoint, end)
}

///|
pub fn pairwise_sum(values : ReadOnlyArray[Double]) -> Double {
  pairwise_range(values, 0, values.length())
}

///|
pub fn kahan_sum(values : ReadOnlyArray[Double]) -> Double {
  let mut sum = 0.0
  let mut compensation = 0.0
  for value in values {
    let corrected = value - compensation
    let next = sum + corrected
    compensation = next - sum - corrected
    sum = next
  }
  sum
}

///|
pub fn neumaier_sum(values : ReadOnlyArray[Double]) -> Double {
  let mut sum = 0.0
  let mut compensation = 0.0
  for value in values {
    let next = sum + value
    if sum.abs() >= value.abs() {
      compensation += sum - next + value
    } else {
      compensation += value - next + sum
    }
    sum = next
  }
  sum + compensation
}
