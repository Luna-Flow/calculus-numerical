///|
/// Error codes for numerical integration operations.
///
/// Constructors:
///
/// * `OK` - Operation completed successfully
/// * `E_ROUND` - Unexpected roundoff error occurred during computation
/// * `E_SINGULARITY` - Possible singularity or highly oscillatory integrand
///   detected
/// * `E_MAX_ITER` - Maximum number of subdivisions reached without convergence
/// * `E_FAILED` - General failure in the integration process
/// * `E_BAD_TOL` - Invalid tolerance parameters provided
///
/// Example:
///
/// ```moonbit
/// let result_code = ErrCode::OK
/// match result_code {
///   OK => println("Integration successful")
///   E_ROUND => println("Roundoff error detected")
///   E_SINGULARITY => println("Singularity encountered")
///   E_MAX_ITER => println("Too many iterations")
///   E_FAILED => println("Integration failed")
///   E_BAD_TOL => println("Bad tolerance")
/// }
/// ```
///
pub(all) enum ErrCode {
  OK
  E_ROUND
  E_SINGULARITY
  E_MAX_ITER
  E_FAILED
  E_BAD_TOL
} derive(Eq)

///|
/// Converts an error code to its string representation.
///
/// Parameters:
///
/// * `self` : The error code to convert.
///
/// Returns a string describing the error code, with "OK" for success and
/// descriptive error messages for failure cases.
///
/// Example:
///
/// ```moonbit
/// let err = ErrCode::E_MAX_ITER
/// inspect(err.to_string(), content="Error: maximum number of subdivisions reached")
/// ```
///
pub impl Show for ErrCode with to_string(self : ErrCode) -> String {
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
/// Writes the string representation of the error code to the provided logger.
///
/// Parameters:
///
/// * `self` : The error code to output.
/// * `logger` : The logger to write the string representation to.
pub impl Show for ErrCode with output(self : ErrCode, logger) -> Unit {
  logger.write_string(self.to_string())
}
