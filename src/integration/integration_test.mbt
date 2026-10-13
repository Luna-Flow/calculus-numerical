///|
test "Gauss-Kronrod integrates a polynomial" {
  let result = @integration.adaptive_gauss_kronrod(fn(x) { x * x }, 0.0, 1.0)
  inspect((result.value - 1.0 / 3.0).abs() < 1.0e-12, content="true")
}

///|
test "Tanh-Sinh integrates an endpoint singularity" {
  let result = @integration.tanh_sinh(fn(x) { 1.0 / x.sqrt() }, 0.0, 1.0)
  inspect((result.value - 2.0).abs() < 1.0e-6, content="true")
}

///|
test "convergence reached by the last permitted subdivision is reported" {
  // One split of the Runge function brings the error estimate below 1e-6.
  let f = fn(x : Double) { 1.0 / (1.0 + 25.0 * x * x) }
  let result = @integration.adaptive_gauss_kronrod(
    f,
    -1.0,
    1.0,
    max_intervals=2,
    absolute_tolerance=1.0e-6,
    relative_tolerance=0.0,
  )
  inspect(result.status == @core.NumericalStatus::Converged, content="true")
  inspect((result.value - 0.5493603067780064).abs() < 1.0e-6, content="true")
}

///|
test "too small an interval budget is reported as MaxIterations" {
  let f = fn(x : Double) { 1.0 / (1.0 + 25.0 * x * x) }
  let result = @integration.adaptive_gauss_kronrod(
    f,
    -1.0,
    1.0,
    max_intervals=1,
    absolute_tolerance=1.0e-12,
    relative_tolerance=0.0,
  )
  inspect(result.status == @core.NumericalStatus::MaxIterations, content="true")
}

///|
test "invalid integration arguments are rejected" {
  let f = fn(x : Double) { x }
  inspect(
    @integration.adaptive_gauss_kronrod(f, 1.0, 1.0).status ==
    @core.NumericalStatus::InvalidInput,
    content="true",
  )
  inspect(
    @integration.adaptive_gauss_kronrod(f, 0.0, 1.0, max_intervals=0).status ==
    @core.NumericalStatus::InvalidInput,
    content="true",
  )
  inspect(
    @integration.tanh_sinh(f, 0.0, 1.0, step=0.0).status ==
    @core.NumericalStatus::InvalidInput,
    content="true",
  )
}

///|
test "reversed bounds negate the integral" {
  let f = fn(x : Double) { x * x }
  let forward = @integration.adaptive_gauss_kronrod(f, 0.0, 2.0)
  let backward = @integration.adaptive_gauss_kronrod(f, 2.0, 0.0)
  inspect((forward.value + backward.value).abs() < 1.0e-14, content="true")
  let ts_forward = @integration.tanh_sinh(f, 0.0, 2.0)
  let ts_backward = @integration.tanh_sinh(f, 2.0, 0.0)
  inspect(
    (ts_forward.value + ts_backward.value).abs() < 1.0e-12,
    content="true",
  )
  inspect((ts_forward.value - 8.0 / 3.0).abs() < 1.0e-10, content="true")
}
