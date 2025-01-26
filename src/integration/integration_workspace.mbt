///|
/// Represents a workspace for adaptive numerical integration algorithms. Stores
/// intermediate results and manages the subdivision process during integration.
///
/// Parameters:
///
/// * `limit` : Maximum number of subintervals allowed in the subdivision
/// process.
/// * `size` : Current number of subintervals in use.
/// * `i` : Current index being processed.
/// * `maximum_level` : Maximum subdivision level reached.
/// * `a_list` : Array of left endpoints of subintervals.
/// * `b_list` : Array of right endpoints of subintervals.
/// * `r_list` : Array of integral approximations for each subinterval.
/// * `e_list` : Array of error estimates for each subinterval.
/// * `order` : Array maintaining the ordering of subintervals based on their
/// error estimates.
/// * `level` : Array storing the subdivision level of each subinterval.
///
/// Example:
///
/// ```moonbit
/// test "IntegrationWorkspace" {
///   let workspace = IntegrationWorkspace::new(100)
///   workspace.init(0.0, 1.0, 0.5, 0.1)
///   let (a, b, result, error) = workspace.retrieve()
///   inspect!(result, content="0.5")
///   inspect!(error, content="0.1")
/// }
/// ```
struct IntegrationWorkspace {
  limit : Int
  mut size : Int
  mut i : Int
  mut maximum_level : Int
  a_list : Array[Double]
  b_list : Array[Double]
  r_list : Array[Double]
  e_list : Array[Double]
  order : Array[Int]
  level : Array[Int]
}

///|
/// Creates a new integration workspace with the specified maximum number of
/// subintervals. The workspace is used to store intermediate results and manage
/// the subdivision process during adaptive numerical integration.
///
/// Parameters:
///
/// * `limit` : Maximum number of subintervals allowed in the subdivision
/// process. This determines the size of internal arrays used to store
/// intermediate results.
///
/// Returns a new `IntegrationWorkspace` with initialized fields:
///
/// * All numeric fields (`size`, `i`, `maximum_level`) are set to 0
/// * All array fields (`a_list`, `b_list`, `r_list`, `e_list`, `order`, `level`)
/// are empty
///
/// Example:
///
/// ```moonbit
/// test "IntegrationWorkspace::new" {
///   let workspace = IntegrationWorkspace::new(100)
///   inspect!(workspace.limit, content="100")
///   inspect!(workspace.size, content="0")
/// }
/// ```
fn IntegrationWorkspace::new(limit : Int) -> IntegrationWorkspace {
  {
    limit,
    size: 0,
    i: 0,
    maximum_level: 0,
    a_list: [],
    b_list: [],
    r_list: [],
    e_list: [],
    order: [],
    level: [],
  }
}

///|
/// Initializes a workspace for adaptive numerical integration with initial
/// values. Resets all internal counters and arrays, then adds the first
/// subinterval with its corresponding result and error estimate.
///
/// Parameters:
///
/// * `workspace` : The integration workspace to be initialized.
/// * `lower_bound` : The lower bound of the initial integration interval.
/// * `upper_bound` : The upper bound of the initial integration interval.
/// * `result` : The initial estimate of the integral over the interval.
/// * `error` : The initial error estimate.
///
/// Example:
///
/// ```moonbit
/// test "IntegrationWorkspace::init" {
///   let workspace = IntegrationWorkspace::new(100)
///   workspace.init(0.0, 1.0, 0.5, 0.1)
///   let (a, b, result, error) = workspace.retrieve()
///   inspect!(result, content="0.5")
///   inspect!(error, content="0.1")
/// }
/// ```
fn IntegrationWorkspace::init(
  workspace : IntegrationWorkspace,
  a : Double,
  b : Double,
  result : Double,
  error : Double
) -> Unit {
  workspace.size = 1
  workspace.i = 0
  workspace.maximum_level = 0
  workspace.a_list.push(a)
  workspace.b_list.push(b)
  workspace.r_list.push(result)
  workspace.e_list.push(error)
  workspace.order.push(0)
  workspace.level.push(0)
}

///|
/// Performs quicksort-like partitioning of error estimates in the integration
/// workspace to maintain an ordered list of subintervals based on their error
/// contributions. This is an internal function used by the adaptive integration
/// algorithms to determine which subinterval should be subdivided next.
///
/// Parameters:
///
/// * `workspace` : The integration workspace containing arrays of interval
/// bounds, results, and error estimates. The workspace must be properly
/// initialized with at least one subinterval.
///
/// Example:
///
/// ```moonbit
/// test "qpsrt" {
///   let workspace = IntegrationWorkspace::new(100)
///   workspace.init(0.0, 1.0, 0.5, 0.1)
///   workspace.qpsrt()
///   let (_, _, _, error) = workspace.retrieve()
///   inspect!(error, content="0.1")
/// }
/// ```
fn qpsrt(workspace : IntegrationWorkspace) -> Unit {
  let last = workspace.size - 1
  let i_maxerr = workspace.order[0]
  if last < 2 {
    workspace.order[0] = 0
    if workspace.order.length() > 1 {
      workspace.order[1] = 1
    } else {
      workspace.order.push(1)
    }
    workspace.i = workspace.order[0]
  }
  let errmax = workspace.e_list[i_maxerr]
  let mut top = 0
  if last < workspace.limit / 2 + 2 {
    top = last
  } else {
    top = workspace.limit - last + 1
  }
  let mut i = 1
  let mut k = top - 1
  while i < top && errmax < workspace.e_list[workspace.order[i]] {
    workspace.order[i - 1] = workspace.order[i]
    i = i + 1
  }
  workspace.order[i - 1] = i_maxerr
  let errmin = workspace.e_list[last]
  while k > i - 2 && errmin >= workspace.e_list[workspace.order[k]] {
    if workspace.order.length() <= k + 1 {
      workspace.order.push(workspace.order[k])
    } else {
      workspace.order[k + 1] = workspace.order[k]
    }
    k = k - 1
  }
  if workspace.order.length() <= k + 1 {
    workspace.order.push(last)
  } else {
    workspace.order[k + 1] = last
  }
  workspace.i = workspace.order[0]
}

///|
/// Updates the integration workspace with two new subintervals obtained from
/// subdivision. Manages the storage of interval bounds, results, and error
/// estimates, while maintaining proper ordering of subintervals based on their
/// error contributions.
///
/// Parameters:
///
/// * `workspace` : The integration workspace to be updated.
/// * `first_interval` : The left subinterval's information:
///  * `lower_bound` : Lower bound of the first subinterval.
///  * `upper_bound` : Upper bound of the first subinterval.
///  * `result` : Estimated integral value for the first subinterval.
///  * `error` : Error estimate for the first subinterval.
/// * `second_interval` : The right subinterval's information:
///  * `lower_bound` : Lower bound of the second subinterval.
///  * `upper_bound` : Upper bound of the second subinterval.
///  * `result` : Estimated integral value for the second subinterval.
///  * `error` : Error estimate for the second subinterval.
///
/// Example:
///
/// ```moonbit
/// test "IntegrationWorkspace::update" {
///   let workspace = IntegrationWorkspace::new(100)
///   workspace.init(0.0, 1.0, 0.5, 0.1)
///   workspace.update(0.0, 0.5, 0.2, 0.05, 0.5, 1.0, 0.3, 0.06)
///   let (_, _, result, error) = workspace.retrieve()
///   inspect!(result, content="0.3")
///   inspect!(error, content="0.06")
/// }
/// ```
fn IntegrationWorkspace::update(
  workspace : IntegrationWorkspace,
  a_1 : Double,
  b_1 : Double,
  area_1 : Double,
  error_1 : Double,
  a_2 : Double,
  b_2 : Double,
  area_2 : Double,
  error_2 : Double
) -> Unit {
  let i_max = workspace.i
  let new_level = workspace.level[i_max] + 1
  if error_2 > error_1 {
    workspace.a_list[i_max] = a_2
    workspace.r_list[i_max] = area_2
    workspace.e_list[i_max] = error_2
    workspace.level[i_max] = new_level
    workspace.a_list.push(a_1)
    workspace.b_list.push(b_1)
    workspace.r_list.push(area_1)
    workspace.e_list.push(error_1)
    workspace.level.push(new_level)
  } else {
    workspace.b_list[i_max] = b_1
    workspace.r_list[i_max] = area_1
    workspace.e_list[i_max] = error_1
    workspace.level[i_max] = new_level
    workspace.a_list.push(a_2)
    workspace.b_list.push(b_2)
    workspace.r_list.push(area_2)
    workspace.e_list.push(error_2)
    workspace.level.push(new_level)
  }
  workspace.size = workspace.size + 1
  if new_level > workspace.maximum_level {
    workspace.maximum_level = new_level
  }
  qpsrt(workspace)
}

///|
/// Retrieves the current state of integration from the workspace, including the
/// interval bounds, result, and error estimate for the subinterval being
/// processed.
///
/// Parameters:
///
/// * `workspace` : The integration workspace containing the current state of
/// adaptive integration process.
///
/// Returns a tuple containing:
///
/// * The lower bound of the current subinterval
/// * The upper bound of the current subinterval
/// * The estimated integral value for the current subinterval
/// * The error estimate for the current subinterval
///
/// Example:
///
/// ```moonbit
/// test "IntegrationWorkspace::retrieve" {
///   let workspace = IntegrationWorkspace::new(100)
///   workspace.init(0.0, 1.0, 0.5, 0.1)
///   let (a, b, result, error) = workspace.retrieve()
///   inspect!(result, content="0.5")
///   inspect!(error, content="0.1")
/// }
/// ```
fn IntegrationWorkspace::retrieve(
  workspace : IntegrationWorkspace
) -> (Double, Double, Double, Double) {
  (
    workspace.a_list[workspace.i],
    workspace.b_list[workspace.i],
    workspace.r_list[workspace.i],
    workspace.e_list[workspace.i],
  )
}
