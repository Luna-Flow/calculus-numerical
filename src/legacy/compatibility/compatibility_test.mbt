///|
test "legacy derivative remains usable" {
  let function = fn(value : Double) { value * value }
  let legacy = @legacy_deriv.deriv_central(function, 2.0, 0.1)
  inspect((legacy.0 - 4.0).abs() < 1.0e-10, content="true")
}

///|
test "legacy automatic difference remains usable" {
  let function = fn(value : Double) { value * value }
  let legacy = @legacy_diff.diff_central(function, 2.0)
  inspect((legacy.0 - 4.0).abs() < legacy.1, content="true")
}

///|
test "legacy integration remains usable" {
  let function = fn(value : Double) { value * value }
  let legacy = @legacy_integration.kronrod_r21(function, 0.0, 1.0)
  inspect((legacy.0 - 1.0 / 3.0).abs() < 1.0e-14, content="true")
}

///|
test "legacy integration error type remains available" {
  let status : @legacy_integration.ErrCode = @legacy_integration.ErrCode::OK
  inspect(status == @legacy_integration.ErrCode::OK, content="true")
}

///|
test "new Gauss-Kronrod 21 agrees with the legacy kronrod_r21 value" {
  let functions : Array[(Double) -> Double] = [
    fn(x) { x * x },
    fn(x) { 1.0 / (1.0 + 25.0 * x * x) },
    fn(x) { x.abs().sqrt() },
    fn(x) { x * x * x * x * x - 3.0 * x + 1.0 },
  ]
  for function in functions {
    let (legacy_value, _, _, _) = @legacy_integration.kronrod_r21(
      function, -1.0, 2.0,
    )
    let (value, _, evaluations) = @integration.gauss_kronrod_21(
      function, -1.0, 2.0,
    )
    inspect(
      (value - legacy_value).abs() <= 1.0e-14 * (1.0 + value.abs()),
      content="true",
    )
    inspect(evaluations, content="21")
  }
}

///|
test "every legacy Kronrod rule integrates exp on [0, 1] to machine precision" {
  let exact = 1.718281828459045 // e - 1
  let rules : Array[
    ((Double) -> Double, Double, Double) -> (Double, Double, Double, Double),
  ] = [
    @legacy_integration.kronrod_r15, @legacy_integration.kronrod_r21, @legacy_integration.kronrod_r31,
    @legacy_integration.kronrod_r41, @legacy_integration.kronrod_r51, @legacy_integration.kronrod_r61,
  ]
  for rule in rules {
    let (value, _, _, _) = rule(fn(x) { @math.exp(x) }, 0.0, 1.0)
    inspect((value - exact).abs() < 1.0e-14, content="true")
  }
}

///|
test "legacy adaptive integration meets the requested tolerance" {
  let result = @legacy_integration.adap_quad_gk(
    fn(x) { 1.0 / (1.0 + 25.0 * x * x) },
    @legacy_integration.kronrod_r21,
    -1.0,
    1.0,
    1.0e-10,
    1.0e-10,
    100,
  )
  match result {
    Ok((value, error, _)) => {
      inspect((value - 0.5493603067780064).abs() < 1.0e-9, content="true")
      inspect(error < 1.0e-9, content="true")
    }
    Err(_) => fail("adaptive integration failed")
  }
}

///|
test "legacy non-adaptive integration meets the requested tolerance" {
  match
    @legacy_integration.non_adap_quad_gk(
      fn(x) { x * x },
      0.0,
      1.0,
      1.0e-10,
      1.0e-10,
    ) {
    Ok((value, _, _)) =>
      inspect((value - 1.0 / 3.0).abs() < 1.0e-12, content="true")
    Err(_) => fail("non-adaptive integration failed")
  }
}

///|
test "legacy adaptive integration rejects an impossible tolerance" {
  let result = @legacy_integration.adap_quad_gk(
    fn(x) { x },
    @legacy_integration.kronrod_r21,
    0.0,
    1.0,
    0.0,
    0.0,
    10,
  )
  inspect(result is Err(_), content="true")
}

///|
test "legacy derivatives agree with the exact derivative of exp" {
  let exact = 1.0
  let central = @legacy_deriv.deriv_central(fn(x) { @math.exp(x) }, 0.0, 0.1)
  let forward = @legacy_deriv.deriv_forward(fn(x) { @math.exp(x) }, 0.0, 0.1)
  let backward = @legacy_deriv.deriv_backward(fn(x) { @math.exp(x) }, 0.0, 0.1)
  inspect((central.0 - exact).abs() < 1.0e-6, content="true")
  inspect((forward.0 - exact).abs() < 1.0e-4, content="true")
  inspect((backward.0 - exact).abs() < 1.0e-4, content="true")
  let auto_forward = @legacy_diff.diff_forward(fn(x) { @math.exp(x) }, 0.0)
  let auto_backward = @legacy_diff.diff_backward(fn(x) { @math.exp(x) }, 0.0)
  inspect((auto_forward.0 - exact).abs() < 1.0e-5, content="true")
  inspect((auto_backward.0 - exact).abs() < 1.0e-5, content="true")
}
