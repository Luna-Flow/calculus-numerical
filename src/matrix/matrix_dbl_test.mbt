///|
test "new" {
  let m = MatrixDbl::new(2, 3)
  inspect!(m, content="{data: [], col: 3, row: 2, stride: 3}")
}

///|
test "at" {
  let m = MatrixDbl::zero_matrix(2, 3)
  assert_eq!(m.at(0, 0), 0.0)
}

///|
test "map & map_inplace" {
  let f = fn(x : Double) -> Double { x + 1.0 }
  let m = MatrixDbl::zero_matrix(2, 3)
  let m2 = m.map(f)
  assert_eq!(m2.data, [1.0, 1.0, 1.0, 1.0, 1.0, 1.0])
  m.map_inplace(f)
  assert_eq!(m.data, [1.0, 1.0, 1.0, 1.0, 1.0, 1.0])
}

///|
test "scale & scale_inplace" {
  let m = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m2 = m.scale(2.0)
  m.scale_inplace(2.0)
  assert_eq!(m2.data, [2.0, 2.0, 2.0, 2.0, 2.0, 2.0])
  assert_eq!(m.data, [2.0, 2.0, 2.0, 2.0, 2.0, 2.0])
}

///|
test "add_constant & add_constant_inplace" {
  let m = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m2 = m.add_constant(2.0)
  m.add_constant_inplace(2.0)
  assert_eq!(m2.data, [3.0, 3.0, 3.0, 3.0, 3.0, 3.0])
  assert_eq!(m.data, [3.0, 3.0, 3.0, 3.0, 3.0, 3.0])
}

///|
test "add_diagonal & add_diagonal_inplace" {
  let m = MatrixDbl::zero_matrix(2, 2)
  let m2 = m.add_diagonal(2.0)
  m.add_diagonal_inplace(2.0)
  assert_eq!(m2.data, [2.0, 0.0, 0.0, 2.0])
  assert_eq!(m.data, [2.0, 0.0, 0.0, 2.0])
}

///|
test "scale_col_inplace & scale_row_inplace" {
  let m = MatrixDbl::filled_matrix(3, 3, 1.0)
  let v = @vector.VectorDbl::new(3)
  v.data.push(1.0)
  v.data.push(2.0)
  v.data.push(3.0)
  m.scale_col_inplace(v)
  assert_eq!(m.data, [1.0, 2.0, 3.0, 1.0, 2.0, 3.0, 1.0, 2.0, 3.0])
  m.scale_row_inplace(v)
  assert_eq!(m.data, [1.0, 2.0, 3.0, 2.0, 4.0, 6.0, 3.0, 6.0, 9.0])
}

///|
test "mul_elements&mul_elements_inplace" {
  let m1 = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m2 = MatrixDbl::filled_matrix(2, 3, 2.0)
  let m3 = m1.mul_elements(m2)
  m1.mul_elements_inplace(m2)
  assert_eq!(m1.data, [2.0, 2.0, 2.0, 2.0, 2.0, 2.0])
  assert_eq!(m3.data, [2.0, 2.0, 2.0, 2.0, 2.0, 2.0])
}

///|
test "div_elements&div_elements_inplace" {
  let m1 = MatrixDbl::filled_matrix(2, 3, 2.0)
  let m2 = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m3 = m1.div_elements(m2)
  m1.div_elements_inplace(m2)
  assert_eq!(m1.data, [2.0, 2.0, 2.0, 2.0, 2.0, 2.0])
  assert_eq!(m3.data, [2.0, 2.0, 2.0, 2.0, 2.0, 2.0])
}

///|
test "op_add" {
  let m1 = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m2 = MatrixDbl::filled_matrix(2, 3, 2.0)
  let m3 = m1 + m2
  assert_eq!(m3.data, [3.0, 3.0, 3.0, 3.0, 3.0, 3.0])
}

///|
test "op_sub" {
  let m1 = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m2 = MatrixDbl::filled_matrix(2, 3, 2.0)
  let m3 = m1 - m2
  assert_eq!(m3.data, [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0])
}

///|
test "op_mul" {
  let m1 = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m2 = MatrixDbl::filled_matrix(3, 2, 2.0)
  let m3 = m1 * m2
  assert_eq!(m3.data, [6.0, 6.0, 6.0, 6.0])
}

///|
test "op_eq" {
  let m1 = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m2 = MatrixDbl::filled_matrix(2, 3, 1.0)
  let m3 = MatrixDbl::filled_matrix(2, 3, 2.0)
  let m4 = MatrixDbl::filled_matrix(2, 4, 1.0)
  let m5 = MatrixDbl::filled_matrix(3, 3, 1.0)
  assert_eq!(m1 == m2, true)
  assert_eq!(m1 == m3, false)
  assert_eq!(m1 == m4, false)
  assert_eq!(m1 == m5, false)
}

///|
test "is_null" {
  let m = MatrixDbl::zero_matrix(2, 3)
  assert_eq!(m.is_null(), true)
  let m = MatrixDbl::filled_matrix(2, 3, 1.0)
  assert_eq!(m.is_null(), false)
}

///|
test "is_pos" {
  let m1 = MatrixDbl::zero_matrix(2, 3)
  assert_eq!(m1.is_pos(), false)
  let m2 = MatrixDbl::filled_matrix(2, 3, -1.0)
  assert_eq!(m2.is_pos(), false)
  let m3 = MatrixDbl::filled_matrix(2, 3, 1.0)
  assert_eq!(m3.is_pos(), true)
}

///|
test "is_neg" {
  let m1 = MatrixDbl::zero_matrix(2, 3)
  assert_eq!(m1.is_neg(), false)
  let m2 = MatrixDbl::filled_matrix(2, 3, -1.0)
  assert_eq!(m2.is_neg(), true)
  let m3 = MatrixDbl::filled_matrix(2, 3, 1.0)
  assert_eq!(m3.is_neg(), false)
}

///|
test "is_non_neg" {
  let m1 = MatrixDbl::zero_matrix(2, 3)
  assert_eq!(m1.is_non_neg(), true)
  let m2 = MatrixDbl::filled_matrix(2, 3, -1.0)
  assert_eq!(m2.is_non_neg(), false)
  let m3 = MatrixDbl::filled_matrix(2, 3, 1.0)
  assert_eq!(m3.is_non_neg(), true)
}

///|
test "norm_1" {
  let m = MatrixDbl::filled_matrix(2, 3, 1.0)
  assert_eq!(m.norm_1(), 2.0)
  m.data[2] = 2.0
  assert_eq!(m.norm_1(), 3.0)
}

///|
test "row_vec" {
  let m = MatrixDbl::filled_matrix(2, 3, 1.0)
  let v = m.row_vec(1)
  assert_eq!(v.data, [1.0, 1.0, 1.0])
}

///|
test "col_vec" {
  let m = MatrixDbl::filled_matrix(2, 3, 1.0)
  let v = m.col_vec(1)
  assert_eq!(v.data, [1.0, 1.0])
}

///|
test "diagonal & subdiag & superdiag" {
  let m = MatrixDbl::filled_matrix(3, 3, 1.0)
  let v1 = m.diagonal_vec()
  let v2 = m.subdiagonal_vec()
  let v3 = m.superdiagonal_vec()
  assert_eq!(v1.data, [1.0, 1.0, 1.0])
  assert_eq!(v2.data, [1.0, 1.0])
  assert_eq!(v3.data, [1.0, 1.0])
}

///|
test "subrow & col_vec" {
  let m = MatrixDbl::filled_matrix(3, 3, 1.0)
  let v1 = m.subrow_vec(1, 0, 2)
  let v2 = m.subcol_vec(1, 0, 2)
  assert_eq!(v1.data, [1.0, 1.0])
  assert_eq!(v2.data, [1.0, 1.0])
}
