///|
/// Internal workspace for adaptive numerical integration algorithms, managing
/// subdivision intervals and their associated computational data.
///
/// Fields:
///
/// * `limit` : Maximum number of subdivision intervals allowed in the
///   workspace.
/// * `size` : Current number of active intervals stored in the workspace.
/// * `i` : Index of the interval with the largest error estimate, used for next
///   subdivision.
/// * `maximum_level` : Highest subdivision level reached during the integration
///   process.
/// * `a_list` : Left endpoints of all subdivision intervals.
/// * `b_list` : Right endpoints of all subdivision intervals.
/// * `r_list` : Numerical integration results for each interval.
/// * `e_list` : Error estimates for each interval.
/// * `order` : Priority ordering of intervals based on error magnitude.
/// * `level` : Subdivision level of each interval (0 for original interval).
///
priv struct IntegrationWorkspace {
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
/// Creates a new integration workspace with the specified limit for adaptive
/// numerical integration algorithms.
///
/// Parameters:
///
/// * `limit` : The maximum number of subintervals that can be stored in the
///   workspace.
///
/// Returns a new `IntegrationWorkspace` instance initialized with empty arrays
/// and default values.
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
/// Initializes the integration workspace with the first integration interval
/// and its computational results.
///
/// Parameters:
///
/// * `workspace` : The integration workspace to initialize.
/// * `a` : The left endpoint of the initial integration interval.
/// * `b` : The right endpoint of the initial integration interval.
/// * `result` : The computed integral result for the initial interval.
/// * `error` : The estimated error for the initial interval.
///
fn IntegrationWorkspace::init(
  workspace : IntegrationWorkspace,
  a : Double,
  b : Double,
  result : Double,
  error : Double,
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
/// Sorts and manages the priority queue of integration subintervals based on
/// their error estimates.
///
/// This function maintains a sorted order of integration subintervals in the
/// workspace, prioritizing those with the largest errors for further
/// subdivision. It implements a partial sorting algorithm that keeps track of
/// the most error-prone intervals while managing memory efficiently by limiting
/// the number of actively tracked intervals.
///
/// Parameters:
///
/// * `workspace` : The integration workspace containing the arrays of interval
///   bounds, results, errors, and ordering information to be sorted.
///
/// Panics if the workspace arrays are accessed with invalid indices during the
/// sorting process.
///
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
/// Updates the integration workspace with two new subinterval results after
/// subdivision.
///
/// Parameters:
///
/// * `workspace` : The integration workspace to update.
/// * `a_1` : Left endpoint of the first subinterval.
/// * `b_1` : Right endpoint of the first subinterval.
/// * `area_1` : Computed area estimate for the first subinterval.
/// * `error_1` : Error estimate for the first subinterval.
/// * `a_2` : Left endpoint of the second subinterval.
/// * `b_2` : Right endpoint of the second subinterval.
/// * `area_2` : Computed area estimate for the second subinterval.
/// * `error_2` : Error estimate for the second subinterval.
///
/// Updates the workspace by replacing the interval with the largest error with
/// one of the two new subintervals and adding the other as a new entry. The
/// subinterval with the larger error replaces the current interval, while the
/// one with smaller error is appended. Also increments the subdivision level,
/// updates the workspace size, tracks the maximum subdivision level, and
/// reorders the intervals by error magnitude.
///
fn IntegrationWorkspace::update(
  workspace : IntegrationWorkspace,
  a_1 : Double,
  b_1 : Double,
  area_1 : Double,
  error_1 : Double,
  a_2 : Double,
  b_2 : Double,
  area_2 : Double,
  error_2 : Double,
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
/// Retrieves the integration interval and results for the current
/// highest-priority subinterval.
///
/// Parameters:
///
/// * `workspace` : The integration workspace containing the stored intervals
///   and results.
///
/// Returns a tuple containing the left endpoint, right endpoint, integral
/// result, and error estimate of the current highest-priority subinterval.
///
fn IntegrationWorkspace::retrieve(
  workspace : IntegrationWorkspace,
) -> (Double, Double, Double, Double) {
  (
    workspace.a_list[workspace.i],
    workspace.b_list[workspace.i],
    workspace.r_list[workspace.i],
    workspace.e_list[workspace.i],
  )
}
