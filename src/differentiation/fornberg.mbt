///|
pub fn fornberg_weights(
  nodes : ReadOnlyArray[Double],
  center : Double,
  derivative_order : Int32,
) -> Array[Array[Double]]? {
  guard nodes.length() > derivative_order && derivative_order >= 0 else {
    return None
  }
  let count = nodes.length()
  let weights = Array::makei(count, fn(_) {
    Array::make(derivative_order + 1, 0.0)
  })
  weights[0][0] = 1.0
  let mut previous_product = 1.0
  let mut current_offset = nodes[0] - center
  for i in 1..<count {
    let max_order = @cmp.minimum(i, derivative_order)
    let previous_offset = current_offset
    current_offset = nodes[i] - center
    let mut product = 1.0
    for j in 0..<i {
      let difference = nodes[i] - nodes[j]
      guard difference != 0.0 else { return None }
      product *= difference
      if j == i - 1 {
        for order = max_order; order >= 1; order = order - 1 {
          weights[i][order] = previous_product *
            (
              order.to_double() * weights[i - 1][order - 1] -
              previous_offset * weights[i - 1][order]
            ) /
            product
        }
        weights[i][0] = -previous_product *
          previous_offset *
          weights[i - 1][0] /
          product
      }
      for order = max_order; order >= 1; order = order - 1 {
        weights[j][order] = (
            current_offset * weights[j][order] -
            order.to_double() * weights[j][order - 1]
          ) /
          difference
      }
      weights[j][0] = current_offset * weights[j][0] / difference
    }
    previous_product = product
  }
  Some(weights)
}

///|
pub fn apply_stencil(
  function : (Double) -> Double,
  nodes : ReadOnlyArray[Double],
  weights : Array[Double],
) -> Double? {
  guard nodes.length() == weights.length() else { return None }
  let mut result = 0.0
  for index in 0..<nodes.length() {
    result += weights[index] * function(nodes[index])
  }
  Some(result)
}
