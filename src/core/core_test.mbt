///|
test "Estimate::new defaults to empty diagnostics" {
  let estimate = @core.Estimate::new(
    1.0,
    0.5,
    3,
    1,
    @core.NumericalStatus::Converged,
  )
  inspect(estimate.value, content="1")
  inspect(estimate.evaluations, content="3")
  inspect(estimate.status == @core.NumericalStatus::Converged, content="true")
  inspect(
    estimate ==
    @core.Estimate::new(1.0, 0.5, 3, 1, @core.NumericalStatus::Converged),
    content="true",
  )
}
