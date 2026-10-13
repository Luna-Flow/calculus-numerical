///|
using @basic {type Func_Math}

///|
using @lm {pow, sqrt}

///|
using @legacy_support {arr_sum}

///|
fn max(left : Double, right : Double) -> Double {
  @cmp.maximum(left, right)
}

///|
fn min(left : Double, right : Double) -> Double {
  @cmp.minimum(left, right)
}
