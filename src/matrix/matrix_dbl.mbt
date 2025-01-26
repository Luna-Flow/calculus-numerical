///|
/// Represents a matrix of double-precision floating-point numbers with optimized
/// stride-based memory layout.
///
/// Fields:
///
/// * `data` : The array storing matrix elements in row-major order.
/// * `col` : Number of columns in the matrix.
/// * `row` : Number of rows in the matrix.
/// * `stride` : The distance between the start of consecutive rows in memory.
/// Usually equals to the number of columns but can be larger to optimize memory
/// alignment and operations.
///
/// Example:
///
/// ```moonbit
/// test "MatrixDbl" {
///   let m = MatrixDbl::new(2, 3) // Creates a 2x3 matrix
///   inspect!(m.row, content="2")
///   inspect!(m.col, content="3")
/// }
/// ```
pub(all) struct MatrixDbl {
  data : Array[Double]
  col : Int
  row : Int
  stride : Int
} derive(Show)

//oper

///|
pub fn MatrixDbl::new(row : Int, col : Int, stride~ : Int = col) -> MatrixDbl {
  guard row > 0 && col > 0
  let data : Array[Double] = []
  { data, col, row, stride }
}

///|
pub fn MatrixDbl::at(self : MatrixDbl, row : Int, col : Int) -> Double {
  guard row < self.row && col < self.col && row >= 0 && col >= 0
  let index = row * self.stride + col
  guard index < self.data.length()
  self.data[index]
}

///|
pub fn MatrixDbl::map(self : MatrixDbl, f : (Double) -> Double) -> MatrixDbl {
  let stride = self.stride
  let data = self.data.map(f)
  { data, col: self.col, row: self.row, stride }
}

///|
pub fn MatrixDbl::map_inplace(self : MatrixDbl, f : (Double) -> Double) -> Unit {
  self.data.map_inplace(f)
}

///|
pub fn MatrixDbl::scale(self : MatrixDbl, scalar : Double) -> MatrixDbl {
  self.map(fn(x) -> Double { x * scalar })
}

///|
pub fn MatrixDbl::scale_inplace(self : MatrixDbl, scalar : Double) -> Unit {
  self.map_inplace(fn(x) -> Double { x * scalar })
}

///|
pub fn MatrixDbl::add_constant(
  self : MatrixDbl,
  constant : Double
) -> MatrixDbl {
  self.map(fn(x) -> Double { x + constant })
}

///|
pub fn MatrixDbl::add_constant_inplace(
  self : MatrixDbl,
  constant : Double
) -> Unit {
  self.map_inplace(fn(x) -> Double { x + constant })
}

///|
pub fn MatrixDbl::add_diagonal(
  self : MatrixDbl,
  constant : Double
) -> MatrixDbl {
  guard self.row == self.col
  let stride = self.stride
  let data = self.data.copy()
  for i = 0; i < self.row; i = i + 1 {
    data[i * stride + i] = data[i * stride + i] + constant
  }
  { data, col: self.col, row: self.row, stride }
}

///|
pub fn MatrixDbl::add_diagonal_inplace(
  self : MatrixDbl,
  constant : Double
) -> Unit {
  guard self.row == self.col
  let stride = self.stride
  for i = 0; i < self.row; i = i + 1 {
    self.data[i * stride + i] = self.data[i * stride + i] + constant
  }
}

///|
pub fn MatrixDbl::scale_col_inplace(
  self : MatrixDbl,
  scalar : @vector.VectorDbl
) -> Unit {
  guard self.col == scalar.size
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      self.data[i * self.stride + j] = self.data[i * self.stride + j] *
        scalar.data[j]
    }
  }
}

///|
pub fn MatrixDbl::scale_row_inplace(
  self : MatrixDbl,
  scalar : @vector.VectorDbl
) -> Unit {
  guard self.row == scalar.size
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      self.data[i * self.stride + j] = self.data[i * self.stride + j] *
        scalar.data[i]
    }
  }
}

///|
pub fn MatrixDbl::mul_elements(
  self : MatrixDbl,
  other : MatrixDbl
) -> MatrixDbl {
  guard self.col == other.col && self.row == other.row
  let stride_self = self.stride
  let stride_other = other.stride
  let matrix_mul = MatrixDbl::new(self.row, self.col)
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      matrix_mul.data.push(
        self.data[i * stride_self + j] * other.data[i * stride_other + j],
      )
    }
  }
  matrix_mul
}

///|
pub fn MatrixDbl::mul_elements_inplace(
  self : MatrixDbl,
  other : MatrixDbl
) -> Unit {
  guard self.col == other.col && self.row == other.row
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      self.data[i * stride_self + j] = self.data[i * stride_self + j] *
        other.data[i * stride_other + j]
    }
  }
}

///|
pub fn MatrixDbl::div_elements(
  self : MatrixDbl,
  other : MatrixDbl
) -> MatrixDbl {
  guard self.col == other.col && self.row == other.row
  let stride_self = self.stride
  let stride_other = other.stride
  let matrix_div = MatrixDbl::new(self.row, self.col)
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      matrix_div.data.push(
        self.data[i * stride_self + j] / other.data[i * stride_other + j],
      )
    }
  }
  matrix_div
}

///|
pub fn MatrixDbl::div_elements_inplace(
  self : MatrixDbl,
  other : MatrixDbl
) -> Unit {
  guard self.col == other.col && self.row == other.row
  let stride_self = self.stride
  let stride_other = other.stride
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      self.data[i * stride_self + j] = self.data[i * stride_self + j] /
        other.data[i * stride_other + j]
    }
  }
}

///|
fn MatrixDbl::std_mul(self : MatrixDbl, other : MatrixDbl) -> MatrixDbl {
  let stride_self = self.stride
  let stride_other = other.stride
  let matrix_mul = MatrixDbl::new(self.row, other.col)
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < other.col; j = j + 1 {
      let mut sum = 0.0
      for k = 0; k < self.col; k = k + 1 {
        sum = sum +
          self.data[i * stride_self + k] * other.data[k * stride_other + j]
      }
      matrix_mul.data.push(sum)
    }
  }
  matrix_mul
}

///|
pub fn MatrixDbl::op_add(self : MatrixDbl, other : MatrixDbl) -> MatrixDbl {
  guard self.col == other.col && self.row == other.row
  let stride_self = self.stride
  let stride_other = other.stride
  let matrix_add = MatrixDbl::new(self.row, self.col)
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      matrix_add.data.push(
        self.data[i * stride_self + j] + other.data[i * stride_other + j],
      )
    }
  }
  matrix_add
}

///|
pub fn MatrixDbl::op_sub(self : MatrixDbl, other : MatrixDbl) -> MatrixDbl {
  guard self.col == other.col && self.row == other.row
  let stride_self = self.stride
  let stride_other = other.stride
  let matrix_sub = MatrixDbl::new(self.row, self.col)
  for i = 0; i < self.row; i = i + 1 {
    for j = 0; j < self.col; j = j + 1 {
      matrix_sub.data.push(
        self.data[i * stride_self + j] - other.data[i * stride_other + j],
      )
    }
  }
  matrix_sub
}

///|
pub fn MatrixDbl::op_mul(self : MatrixDbl, other : MatrixDbl) -> MatrixDbl {
  guard self.col == other.row
  MatrixDbl::std_mul(self, other)
}

//init

///|
pub fn MatrixDbl::filled_matrix(
  row : Int,
  col : Int,
  num : Double
) -> MatrixDbl {
  let stride = col
  let data : Array[Double] = (fn() -> Array[Double] {
    let filled_matrix = []
    for i = 0; i < row * col; i = i + 1 {
      filled_matrix.push(num)
    }
    filled_matrix
  })()
  { data, col, row, stride }
}

///|
pub fn MatrixDbl::zero_matrix(row : Int, col : Int) -> MatrixDbl {
  MatrixDbl::filled_matrix(row, col, 0.0)
}

//prop
///|
pub impl Eq for MatrixDbl with op_equal(self : MatrixDbl, other : MatrixDbl) -> Bool {
  self.row == other.row && self.col == other.col && self.data == other.data
}

///|
pub fn MatrixDbl::is_null(self : MatrixDbl) -> Bool {
  let n = self.row * self.col
  for i = 0; i < n; i = i + 1 {
    if self.data[i] != 0.0 {
      return false
    }
  }
  true
}

///|
pub fn MatrixDbl::is_pos(self : MatrixDbl) -> Bool {
  let n = self.row * self.col
  for i = 0; i < n; i = i + 1 {
    if self.data[i] <= 0.0 {
      return false
    }
  }
  true
}

///|
pub fn MatrixDbl::is_neg(self : MatrixDbl) -> Bool {
  let n = self.row * self.col
  for i = 0; i < n; i = i + 1 {
    if self.data[i] >= 0.0 {
      return false
    }
  }
  true
}

///|
pub fn MatrixDbl::is_non_neg(self : MatrixDbl) -> Bool {
  let n = self.row * self.col
  for i = 0; i < n; i = i + 1 {
    if self.data[i] < 0.0 {
      return false
    }
  }
  true
}

///|
pub fn MatrixDbl::norm_1(self : MatrixDbl) -> Double {
  let mut max_sum = 0.0
  for j = 0; j < self.col; j = j + 1 {
    let mut sum = 0.0
    for i = 0; i < self.row; i = i + 1 {
      sum = sum + self.data[i * self.stride + j]
    }
    max_sum = @basic.max(max_sum, sum)
  }
  max_sum
}

//vectorize
///|
pub fn MatrixDbl::row_vec(self : MatrixDbl, row : Int) -> @vector.VectorDbl {
  guard row < self.row && row >= 0
  let size_vec = self.col
  let vec = @vector.VectorDbl::new(size_vec)
  for i = 0; i < size_vec; i = i + 1 {
    vec.data.push(self.data[row * self.stride + i])
  }
  vec
}

///|
pub fn MatrixDbl::col_vec(self : MatrixDbl, col : Int) -> @vector.VectorDbl {
  guard col < self.col && col >= 0
  let size_vec = self.row
  let vec = @vector.VectorDbl::new(size_vec)
  for i = 0; i < size_vec; i = i + 1 {
    vec.data.push(self.data[i * self.stride + col])
  }
  vec
}

///|
pub fn MatrixDbl::diagonal_vec(self : MatrixDbl) -> @vector.VectorDbl {
  let short_side = @basic.min(self.row, self.col)
  let vec = @vector.VectorDbl::new(short_side)
  for i = 0; i < short_side; i = i + 1 {
    vec.data.push(self.data[i * self.stride + i])
  }
  vec
}

///|
pub fn MatrixDbl::subdiagonal_vec(self : MatrixDbl) -> @vector.VectorDbl {
  let short_side = @basic.min(self.row, self.col)
  let vec = @vector.VectorDbl::new(short_side - 1)
  for i = 0; i < short_side - 1; i = i + 1 {
    vec.data.push(self.data[(i + 1) * self.stride + i])
  }
  vec
}

///|
pub fn MatrixDbl::superdiagonal_vec(self : MatrixDbl) -> @vector.VectorDbl {
  let short_side = @basic.min(self.row, self.col)
  let vec = @vector.VectorDbl::new(short_side - 1)
  for i = 0; i < short_side - 1; i = i + 1 {
    vec.data.push(self.data[i * self.stride + (i + 1)])
  }
  vec
}

///|
pub fn MatrixDbl::subrow_vec(
  self : MatrixDbl,
  row : Int,
  start : Int,
  num : Int
) -> @vector.VectorDbl {
  guard row < self.row && row >= 0
  guard start >= 0 && num > 0 && start + num <= self.col
  let vec = @vector.VectorDbl::new(num)
  for i = 0; i < num; i = i + 1 {
    vec.data.push(self.data[row * self.stride + start + i])
  }
  vec
}

///|
pub fn MatrixDbl::subcol_vec(
  self : MatrixDbl,
  col : Int,
  start : Int,
  num : Int
) -> @vector.VectorDbl {
  guard col < self.col && col >= 0
  guard start >= 0 && num > 0 && start + num <= self.row
  let vec = @vector.VectorDbl::new(num)
  for i = 0; i < num; i = i + 1 {
    vec.data.push(self.data[(start + i) * self.stride + col])
  }
  vec
}

//view

///|
pub enum ViewMode {
  Row
  Col
  Diagonal
  SubDiagonal
  SuperDiagonal
  SubRow
  SubCol
} derive(Show, Eq)

///|
pub(all) struct MatrixViewDbl {
  matrix : MatrixDbl
  index : Int
  start : Int
  num : Int
  view_mode : ViewMode
}

///|
pub fn MatrixDbl::op_as_view(
  self : MatrixDbl,
  index~ : Int = 0,
  view_mode : ViewMode
) -> MatrixViewDbl {
  guard view_mode == ViewMode::SuperDiagonal ||
    view_mode == ViewMode::SubDiagonal ||
    view_mode == ViewMode::Diagonal ||
    (index >= 0 && index < self.row && view_mode == ViewMode::Row) ||
    (index >= 0 && index < self.col && view_mode == ViewMode::Col)
  MatrixViewDbl::{ matrix: self, index, start: 0, num: 0, view_mode }
}

///|
pub fn MatrixDbl::view(
  self : MatrixDbl,
  index~ : Int = 0,
  start~ : Int = 0,
  num~ : Int = 0,
  view_mode : ViewMode
) -> MatrixViewDbl {
  guard (
      index >= 0 &&
      (
        (
          num > 0 &&
          start >= 0 &&
          (
            (view_mode == ViewMode::SubRow && num < self.col) ||
            (view_mode == ViewMode::SubCol && num < self.row)
          )
        ) ||
        view_mode == ViewMode::Row ||
        view_mode == ViewMode::Col
      )
    ) ||
    view_mode == ViewMode::Diagonal ||
    view_mode == ViewMode::SubDiagonal ||
    view_mode == ViewMode::SuperDiagonal
  MatrixViewDbl::{ matrix: self, index, start, num, view_mode }
}

//view oper

///|
pub fn MatrixViewDbl::map_inplace(
  self : MatrixViewDbl,
  f : (Double) -> Double
) -> Unit {
  match self.view_mode {
    ViewMode::Row =>
      for i = 0; i < self.matrix.col; i = i + 1 {
        self.matrix.data[self.index * self.matrix.stride + i] = f(
          self.matrix.data[self.index * self.matrix.stride + i],
        )
      }
    ViewMode::Col =>
      for i = 0; i < self.matrix.row; i = i + 1 {
        self.matrix.data[i * self.matrix.stride + self.index] = f(
          self.matrix.data[i * self.matrix.stride + self.index],
        )
      }
    ViewMode::Diagonal => {
      let short_side = @basic.min(self.matrix.row, self.matrix.col)
      for i = 0; i < short_side; i = i + 1 {
        self.matrix.data[i * self.matrix.stride + i] = f(
          self.matrix.data[i * self.matrix.stride + i],
        )
      }
    }
    ViewMode::SubDiagonal => {
      let short_side = @basic.min(self.matrix.row, self.matrix.col)
      for i = 0; i < short_side - 1; i = i + 1 {
        self.matrix.data[(i + 1) * self.matrix.stride + i] = f(
          self.matrix.data[(i + 1) * self.matrix.stride + i],
        )
      }
    }
    ViewMode::SuperDiagonal => {
      let short_side = @basic.min(self.matrix.row, self.matrix.col)
      for i = 0; i < short_side - 1; i = i + 1 {
        self.matrix.data[i * self.matrix.stride + (i + 1)] = f(
          self.matrix.data[i * self.matrix.stride + (i + 1)],
        )
      }
    }
    ViewMode::SubRow =>
      for i = 0; i < self.num; i = i + 1 {
        self.matrix.data[self.index * self.matrix.stride + self.start + i] = f(
          self.matrix.data[self.index * self.matrix.stride + self.start + i],
        )
      }
    ViewMode::SubCol =>
      for i = 0; i < self.num; i = i + 1 {
        self.matrix.data[(self.start + i) * self.matrix.stride + self.index] = f(
          self.matrix.data[(self.start + i) * self.matrix.stride + self.index],
        )
      }
  }
}

///|
pub fn MatrixViewDbl::scale_view(
  self : MatrixViewDbl,
  scalar : Double
) -> MatrixViewDbl {
  self.map_inplace(fn(x) -> Double { x * scalar })
  self
}
