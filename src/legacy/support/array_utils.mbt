///|
pub fn arr_sum(values : Array[Double]) -> Double {
  let mut sum = 0.0
  for value in values {
    sum += value
  }
  sum
}

///|
pub fn zero_arr(length : Int32) -> Array[Double] {
  Array::make(length, 0.0)
}
