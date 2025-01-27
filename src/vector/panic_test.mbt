///|
test "panic_new" {
  VectorDbl::new(0) |> ignore()
  VectorDbl::new(1, stride=0) |> ignore()
}

test "panic_calc" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(3, 2.0)
  v.add_inplace(v2) |> ignore()
  v.sub_inplace(v2) |> ignore()
  v.mul_inplace(v2) |> ignore()
  v.div_inplace(v2) |> ignore()
  v + v2 |> ignore()
  v - v2 |> ignore()
  v * v2 |> ignore()
  v / v2 |> ignore()
}

test "panic_at" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.at(2) |> ignore()
  v.at(-1) |> ignore()
}

test "panic_op_get" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v[2] |> ignore()
  v[-1] |> ignore()
}

test "panic_set_at" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.set_at(2, 1.0) |> ignore()
  v.set_at(-1, 1.0) |> ignore()
}

test "panic_set_basis" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.set_basis(2) |> ignore()
  v.set_basis(-1) |> ignore()
}

test "panic_op_eq" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(3, 2.0)
  v == v2 |> ignore()
}

test "panic_swap" {
  let v = VectorDbl::filled_vector(2, 1.0)
  let v2 = VectorDbl::filled_vector(3, 2.0)
  v.swap(v2) |> ignore()
}

test "panic_swap_elements" {
  let v = VectorDbl::filled_vector(2, 1.0)
  v.swap_elements(0, 2) |> ignore()
  v.swap_elements(-1, 0) |> ignore()
}
