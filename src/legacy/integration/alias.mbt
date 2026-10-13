///|
using @basic {type Func_Math}

///|
using @basic {type Quad_GK}

///|
using @legacy_support {arr_sum, zero_arr}

///|
fn max(left : Double, right : Double) -> Double {
  @cmp.maximum(left, right)
}

///|
using @lm {sqrt}
