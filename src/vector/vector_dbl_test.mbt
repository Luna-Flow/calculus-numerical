///|
test "new" {
  let v = VectorDbl::new(2)
  inspect!(v, content="{data: [], size: 2, stride: 1}")
}

///|
test "map" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = v.map(fn(x) -> Double { x + 1.0 })
  assert_eq!(v2.data, [2.0, 2.0])
}

///|
test "map_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.map_inplace(fn(x) -> Double { x + 1.0 })
  assert_eq!(v.data, [2.0, 2.0])
}

test "scale" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = v.scale(2.0)
  assert_eq!(v2.data, [2.0, 2.0])
}

test "scale_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.scale_inplace(2.0)
  assert_eq!(v.data, [2.0, 2.0])
}

test "add_constant" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = v.add_constant(2.0)
  assert_eq!(v2.data, [3.0, 3.0])
}

test "add_constant_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.add_constant_inplace(2.0)
  assert_eq!(v.data, [3.0, 3.0])
}

test "ax_plus_by" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  let v3 = v.ax_plus_by(v2, 2.0, 3.0)
  assert_eq!(v3.data, [8.0, 8.0])
}

test "ax_plus_by_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  v.ax_plus_by_inplace(v2, 2.0, 3.0)
  assert_eq!(v.data, [8.0, 8.0])
}

test "sum" {
  let v = VectorDbl::filled_vector(2, 1.0)
  assert_eq!(v.sum(), 2.0)
}

test "add_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  v.add_inplace(v2)
  assert_eq!(v.data, [3.0, 3.0])
}

test "sub_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  v.sub_inplace(v2)
  assert_eq!(v.data, [-1.0, -1.0])
}

test "mul_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  v.mul_inplace(v2)
  assert_eq!(v.data, [2.0, 2.0])
}

test "div_inplace" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  v.div_inplace(v2)
  assert_eq!(v.data, [0.5, 0.5])
}

test "op_add" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  let v3 = v + v2
  assert_eq!(v3.data, [3.0, 3.0])
}

test "op_sub" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  let v3 = v - v2
  assert_eq!(v3.data, [-1.0, -1.0])
}

test "op_mul" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  let v3 = v * v2
  assert_eq!(v3.data, [2.0, 2.0])
}

test "op_div" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  let v3 = v / v2
  assert_eq!(v3.data, [0.5, 0.5])
}

test "at" {
  let v = VectorDbl::filled_vector(2, 1.0)
  assert_eq!(v.at(0), 1.0)
}

test "filled_vector" {
  let v = VectorDbl::filled_vector(2, 1.0)
  assert_eq!(v.data, [1.0, 1.0])
}

test "zero_vector" {
  let v = VectorDbl::zero_vector(2)
  assert_eq!(v.data, [0.0, 0.0])
}

test "op_get" {
  let v = VectorDbl::filled_vector(2, 1.0)
  assert_eq!(v[0], 1.0)
}

test "set_all" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.set_all(2.0)
  assert_eq!(v.data, [2.0, 2.0])
}

test "set_zero" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.set_zero()
  assert_eq!(v.data, [0.0, 0.0])
}

test "set_at" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.set_at(0, 2.0)
  assert_eq!(v.data, [2.0, 1.0])
}

test "set_basis" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.set_basis(0)
  assert_eq!(v.data, [1.0, 0.0])
}

test "copy" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = v.copy()
  assert_eq!(v2, v)
}

test "op_eq" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 1.0)
  let v3 = VectorDbl::filled_vector(2, 2.0)
  assert_true!(v2 == v)
  assert_false!(v3 == v)
}

test "is_null" {
  let v = VectorDbl::filled_vector(2, 1.0)
  assert_false!(v.is_null())
  let v3 = VectorDbl::filled_vector(2, 0.0)
  assert_true!(v3.is_null())
}

test "is_pos" {
  let v = VectorDbl::filled_vector(2, 1.0)
  assert_true!(v.is_pos())
  let v2 = VectorDbl::filled_vector(2, -1.0)
  assert_false!(v2.is_pos())
  let v3 = VectorDbl::filled_vector(2, 0.0)
  assert_false!(v3.is_pos())
}

test "is_neg" {
  let v = VectorDbl::filled_vector(2, -1.0)
  assert_true!(v.is_neg())
  let v2 = VectorDbl::filled_vector(2, 1.0)
  assert_false!(v2.is_neg())
  let v3 = VectorDbl::filled_vector(2, 0.0)
  assert_false!(v3.is_neg())
}

test "is_non_neg" {
  let v = VectorDbl::filled_vector(2, 1.0)
  assert_true!(v.is_non_neg())
  let v2 = VectorDbl::filled_vector(2, -1.0)
  assert_false!(v2.is_non_neg())
  let v3 = VectorDbl::filled_vector(2, 0.0)
  assert_true!(v3.is_non_neg())
}

test "swap" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(2, 2.0)
  v.swap(v2)
  assert_eq!(v.data, [2.0, 2.0])
  assert_eq!(v2.data, [1.0, 1.0])
}

test "swap_elements" {
  let v = VectorDbl::new(2)
  v.data.push(1.0)
  v.data.push(2.0)
  v.swap_elements(0, 1)
  assert_eq!(v.data, [2.0, 1.0])
}

test "reverse" {
  let v = VectorDbl::new(2)
  v.data.push(1.0)
  v.data.push(2.0)
  assert_eq!(v.reverse().data, [2.0, 1.0])
}

test "reverse_inplace" {
  let v = VectorDbl::new(2)
  v.data.push(1.0)
  v.data.push(2.0)
  v.reverse_inplace()
  assert_eq!(v.data, [2.0, 1.0])
}
