///|
pub(all) enum NumericalStatus {
  Converged
  MaxIterations
  InvalidInput
  RoundoffStagnation
} derive(Eq, Debug)

///|
pub struct Estimate[T] {
  value : T
  estimated_error : T
  evaluations : Int32
  iterations : Int32
  status : NumericalStatus
  diagnostics : @lf_arith.ArithmeticDiagnostics
} derive(Eq, Debug)

///|
pub fn[T] Estimate::new(
  value : T,
  estimated_error : T,
  evaluations : Int32,
  iterations : Int32,
  status : NumericalStatus,
  diagnostics~ : @lf_arith.ArithmeticDiagnostics = @lf_arith.ArithmeticDiagnostics::empty(),
) -> Estimate[T] {
  { value, estimated_error, evaluations, iterations, status, diagnostics, }
}

///|
pub extend NumericalStatus with Eq::{not_equal, equal}

///|
pub extend NumericalStatus with @debug.Debug::{to_repr}

///|
pub extend Estimate with Eq::{not_equal, equal}

///|
pub extend Estimate with @debug.Debug::{to_repr}
