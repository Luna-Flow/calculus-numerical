///|
/// Represents a double-precision floating-point vector with stride capability.
/// The stride feature allows for flexible memory access patterns, enabling
/// operations on subsequences of the vector without creating new memory
/// allocations.
///
/// Parameters:
///
/// * `data` : An array of double-precision floating-point numbers storing the
/// vector elements.
/// * `size` : The logical size of the vector (number of accessible elements).
/// * `stride` : The step size between consecutive elements in the vector. A
/// stride of 1 means elements are contiguous, while a stride of n means there
/// are n-1 elements skipped between each accessed element.
///
/// Example:
///
/// ```moonbit
/// test "VectorDbl" {
///   let v = VectorDbl::{ data: [1.0, 2.0, 3.0, 4.0], size: 2, stride: 2 }
///   // v effectively represents [1.0, 3.0] with stride 2
///   inspect!(v.at(0), content="1.0")
///   inspect!(v.at(1), content="3.0")
/// }
/// ```
pub(all) struct VectorDbl {
  data : Array[Double]
  size : Int
  mut stride : Int
}

//oper

///|
pub fn VectorDbl::map(self : VectorDbl, f : (Double) -> Double) -> VectorDbl {
  let data = self.data.map(f)
  { data, size: self.size, stride: self.stride }
}

///|
pub fn VectorDbl::map_inplace(self : VectorDbl, f : (Double) -> Double) -> Unit {
  self.data.map_inplace(f)
}

///|
pub fn VectorDbl::scale(self : VectorDbl, scalar : Double) -> VectorDbl {
  self.map(fn(x) -> Double { x * scalar })
}

///|
pub fn VectorDbl::scale_inplace(self : VectorDbl, scalar : Double) -> Unit {
  self.map_inplace(fn(x) -> Double { x * scalar })
}

///|
pub fn VectorDbl::add_constant(
  self : VectorDbl,
  constant : Double
) -> VectorDbl {
  self.map(fn(x) -> Double { x + constant })
}

///|
pub fn VectorDbl::add_constant_inplace(
  self : VectorDbl,
  constant : Double
) -> Unit {
  self.map_inplace(fn(x) -> Double { x + constant })
}

///|
pub fn VectorDbl::ax_plus_by(
  self : VectorDbl,
  x : VectorDbl,
  a : Double,
  b : Double
) -> VectorDbl {
  let n = self.size
  guard n == x.size
  let stride_self = self.stride
  let stride_x = x.stride
  let vector_ax_plus_by = VectorDbl::new(n)
  for i = 0; i < n; i = i + 1 {
    vector_ax_plus_by.data.push(
      a * self.data[i * stride_self] + b * x.data[i * stride_x],
    )
  }
  vector_ax_plus_by
}

///|
pub fn VectorDbl::ax_plus_by_inplace(
  self : VectorDbl,
  x : VectorDbl,
  a : Double,
  b : Double
) -> Unit {
  let n = self.size
  guard n == x.size
  let stride_self = self.stride
  let stride_x = x.stride
  for i = 0; i < n; i = i + 1 {
    self.data[i * stride_self] = a * self.data[i * stride_self] +
      b * x.data[i * stride_x]
  }
}

///|
pub fn VectorDbl::sum(self : VectorDbl) -> Double {
  @basic.arr_sum_dbl(self.data)
}

///|
pub fn VectorDbl::add_inplace(self : VectorDbl, other : VectorDbl) -> Unit {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < n; i = i + 1 {
    self.data[i * stride_self] = self.data[i * stride_self] +
      other.data[i * stride_other]
  }
}

///|
pub fn VectorDbl::sub_inplace(self : VectorDbl, other : VectorDbl) -> Unit {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < n; i = i + 1 {
    self.data[i * stride_self] = self.data[i * stride_self] -
      other.data[i * stride_other]
  }
}

///|
pub fn VectorDbl::mul_inplace(self : VectorDbl, other : VectorDbl) -> Unit {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < n; i = i + 1 {
    self.data[i * stride_self] = self.data[i * stride_self] *
      other.data[i * stride_other]
  }
}

///|
pub fn VectorDbl::div_inplace(self : VectorDbl, other : VectorDbl) -> Unit {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < n; i = i + 1 {
    self.data[i * stride_self] = self.data[i * stride_self] /
      other.data[i * stride_other]
  }
}

///|
pub fn op_add(self : VectorDbl, other : VectorDbl) -> VectorDbl {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  let vector_add = VectorDbl::new(n)
  for i = 0; i < n; i = i + 1 {
    vector_add.data.push(
      self.data[i * stride_self] + other.data[i * stride_other],
    )
  }
  vector_add
}

///|
pub fn op_sub(self : VectorDbl, other : VectorDbl) -> VectorDbl {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  let vector_sub = VectorDbl::new(n)
  for i = 0; i < n; i = i + 1 {
    vector_sub.data.push(
      self.data[i * stride_self] - other.data[i * stride_other],
    )
  }
  vector_sub
}

///|
pub fn op_mul(self : VectorDbl, other : VectorDbl) -> VectorDbl {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  let vector_mul = VectorDbl::new(n)
  for i = 0; i < n; i = i + 1 {
    vector_mul.data.push(
      self.data[i * stride_self] * other.data[i * stride_other],
    )
  }
  vector_mul
}

///|
pub fn op_div(self : VectorDbl, other : VectorDbl) -> VectorDbl {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  let vector_div = VectorDbl::new(n)
  for i = 0; i < n; i = i + 1 {
    vector_div.data.push(
      self.data[i * stride_self] / other.data[i * stride_other],
    )
  }
  vector_div
}

//init
///|
pub fn VectorDbl::new(size : Int, stride~ : Int = 1) -> VectorDbl {
  guard size > 0 && stride > 0
  let data = []
  { data, size, stride }
}

///|
pub fn VectorDbl::at(self : VectorDbl, index : Int) -> Double {
  guard index < self.size && index >= 0
  self.data[index * self.stride]
}

///|
pub fn VectorDbl::filled_vector(size : Int, num : Double) -> VectorDbl {
  let data = (fn() -> Array[Double] {
    let filled_vector = []
    for i = 0; i < size; i = i + 1 {
      filled_vector.push(num)
    }
    filled_vector
  })()
  { data, size, stride: 1 }
}

///|
pub fn VectorDbl::zero_vector(size : Int) -> VectorDbl {
  VectorDbl::filled_vector(size, 0.0)
}

///|
pub fn op_get(self : VectorDbl, index : Int) -> Double {
  self.data[index * self.stride]
}

///|
pub fn VectorDbl::set_all(self : VectorDbl, num : Double) -> Unit {
  self.map_inplace(fn(_) -> Double { num })
}

///|
pub fn VectorDbl::set_zero(self : VectorDbl) -> Unit {
  self.set_all(0.0)
}

///|
pub fn VectorDbl::set_at(self : VectorDbl, index : Int, num : Double) -> Unit {
  guard index < self.size && index >= 0
  self.data[index * self.stride] = num
}

///|
pub fn VectorDbl::set_basis(self : VectorDbl, index : Int) -> Unit {
  self.set_zero()
  self.set_at(index, 1.0)
}

///|
pub fn VectorDbl::copy(self : VectorDbl) -> VectorDbl {
  let data = self.data.copy()
  { data, size: self.size, stride: self.stride }
}

//prop

///|
pub impl Eq for VectorDbl with op_equal(self, other) {
  let n = self.size
  guard n == other.size
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < n; i = i + 1 {
    if self.data[i * stride_self] != other.data[i * stride_other] {
      return false
    }
  }
  true
}

///|
pub fn VectorDbl::is_null(self : VectorDbl) -> Bool {
  let n = self.size
  let stride = self.stride
  for i = 0; i < n; i = i + 1 {
    if self.data[i * stride] != 0.0 {
      return false
    }
  }
  true
}

///|
pub fn VectorDbl::is_pos(self : VectorDbl) -> Bool {
  let n = self.size
  let stride = self.stride
  for i = 0; i < n; i = i + 1 {
    if self.data[i * stride] <= 0.0 {
      return false
    }
  }
  true
}

///|
pub fn VectorDbl::is_neg(self : VectorDbl) -> Bool {
  let n = self.size
  let stride = self.stride
  for i = 0; i < n; i = i + 1 {
    if self.data[i * stride] >= 0.0 {
      return false
    }
  }
  true
}

///|
pub fn VectorDbl::is_non_neg(self : VectorDbl) -> Bool {
  let n = self.size
  let stride = self.stride
  for i = 0; i < n; i = i + 1 {
    if self.data[i * stride] < 0.0 {
      return false
    }
  }
  true
}

///|
pub fn VectorDbl::swap(self : VectorDbl, other : VectorDbl) -> Unit {
  let n = self.size
  let m = other.size
  guard n == m
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < n; i = i + 1 {
    let temp = self.data[i * stride_self]
    self.data[i * stride_self] = other.data[i * stride_other]
    other.data[i * stride_other] = temp
  }
}

///|
pub fn VectorDbl::swap_elements(self : VectorDbl, i : Int, j : Int) -> Unit {
  guard i < self.size && j < self.size
  let stride = self.stride
  let temp = self.data[i * stride]
  self.data[i * stride] = self.data[j * stride]
  self.data[j * stride] = temp
}

///|
pub fn VectorDbl::reverse(self : VectorDbl) -> VectorDbl {
  let n = self.size
  let stride = self.stride
  let reversed_vector = VectorDbl::new(n)
  for i = n - 1; i >= 0; i = i - 1 {
    reversed_vector.data.push(self.data[i * stride])
  }
  reversed_vector
}

///|
pub fn VectorDbl::reverse_inplace(self : VectorDbl) -> Unit {
  let n = self.size
  let stride = self.stride
  let mut left = 0
  let mut right = n - stride
  while left < right {
    let temp = self.data[left]
    self.data[left] = self.data[right]
    self.data[right] = temp
    left = left + stride
    right = right - stride
  }
}
