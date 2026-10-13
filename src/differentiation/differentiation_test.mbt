///|
test "Fornberg stencil differentiates a quadratic exactly" {
  let nodes : ReadOnlyArray[Double] = [-1.0, 0.0, 1.0]
  let weights = @differentiation.fornberg_weights(nodes, 0.0, 1).unwrap()
  let first = weights.map(fn(row) { row[1] })
  inspect(
    @differentiation.apply_stencil(fn(x) { x * x + 3.0 * x }, nodes, first).unwrap(),
    content="3",
  )
}

///|
test "Ridders differentiates sine" {
  let result = @differentiation.ridders(@math.sin, 0.0)
  inspect((result.value - 1.0).abs() < 1.0e-10, content="true")
}

///|
test "Fornberg weights reproduce the classical central second difference" {
  let nodes : ReadOnlyArray[Double] = [-1.0, 0.0, 1.0]
  let weights = @differentiation.fornberg_weights(nodes, 0.0, 2).unwrap()
  let second = weights.map(fn(row) { row[2] })
  inspect(second[0], content="1")
  inspect(second[1], content="-2")
  inspect(second[2], content="1")
}

///|
test "Fornberg weights reproduce the five-point first derivative" {
  let nodes : ReadOnlyArray[Double] = [-2.0, -1.0, 0.0, 1.0, 2.0]
  let weights = @differentiation.fornberg_weights(nodes, 0.0, 1).unwrap()
  let first = weights.map(fn(row) { row[1] })
  let expected = [1.0 / 12.0, -8.0 / 12.0, 0.0, 8.0 / 12.0, -1.0 / 12.0]
  for index in 0..<5 {
    inspect((first[index] - expected[index]).abs() < 1.0e-14, content="true")
  }
}

///|
test "Fornberg weights reject degenerate input" {
  let repeated : ReadOnlyArray[Double] = [0.0, 1.0, 1.0]
  inspect(
    @differentiation.fornberg_weights(repeated, 0.0, 1) is None,
    content="true",
  )
  let few : ReadOnlyArray[Double] = [0.0, 1.0]
  inspect(
    @differentiation.fornberg_weights(few, 0.0, 2) is None,
    content="true",
  )
  inspect(
    @differentiation.fornberg_weights(few, 0.0, -1) is None,
    content="true",
  )
}

///|
test "apply_stencil rejects mismatched lengths" {
  let nodes : ReadOnlyArray[Double] = [0.0, 1.0]
  inspect(
    @differentiation.apply_stencil(fn(x) { x }, nodes, [1.0]) is None,
    content="true",
  )
}

///|
test "Ridders reports invalid arguments" {
  let result = @differentiation.ridders(@math.sin, 0.0, initial_step=0.0)
  inspect(result.status == @core.NumericalStatus::InvalidInput, content="true")
}

///|
test "Ridders with a single iteration returns the first central difference" {
  let result = @differentiation.ridders(fn(x) { x * x }, 3.0, max_iterations=1)
  inspect((result.value - 6.0).abs() < 1.0e-12, content="true")
  inspect(result.status == @core.NumericalStatus::MaxIterations, content="true")
}

///|
test "Ridders differentiates exp at a nonzero point" {
  let result = @differentiation.ridders(@math.exp, 1.0)
  inspect((result.value - @math.exp(1.0)).abs() < 1.0e-9, content="true")
}
