///|
enum ErrCode {
  OK
  E_ROUND
  E_SINGULARITY
  E_MAX_ITER
  E_FAILED
  E_BAD_TOL
} derive(Eq)

///|
impl Show for ErrCode with to_string(self : ErrCode) -> String {
  match self {
    OK => "OK"
    E_ROUND => "Error: unexpected roundoff error"
    E_SINGULARITY =>
      "Error: possible singularity or highly oscillatory integrand exists"
    E_MAX_ITER => "Error: maximum number of subdivisions reached"
    E_FAILED => "Error: failed"
    E_BAD_TOL => "Error: invalid tolerance parameters"
  }
}

///|
impl Show for ErrCode with output(self : ErrCode, logger) -> Unit {
  logger.write_string(self.to_string())
}
