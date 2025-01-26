///|
/// Calculates the sum of all elements in an array of double-precision
/// floating-point numbers.
///
/// Parameters:
///
/// * `array` : An array of double-precision floating-point numbers
/// (`Array[Double]`) to be summed.
///
/// Returns the sum of all elements in the array. Returns 0.0 if the array is
/// empty.
///
/// Example:
///
/// ```moonbit
/// test "arr_sum_dbl" {
///   let arr = [1.5, 2.5, 3.0]
///   inspect!(arr_sum_dbl(arr), content="7.0")
///   inspect!(arr_sum_dbl([]), content="0.0")
/// }
/// ```
pub fn arr_sum_dbl(arr : Array[Double]) -> Double {
  let mut sum = 0.0
  for x in arr {
    sum = sum + x
  }
  sum
}

///|
/// Creates a new array of double-precision floating-point numbers initialized
/// with zeros.
///
/// Parameters:
///
/// * `length` : The desired length of the array. Must be a non-negative integer.
///
/// Returns an array of type `Array[Double]` with the specified length, where all
/// elements are initialized to 0.0.
///
/// Example:
///
/// ```moonbit
/// test "zero_arr_dbl" {
///   let arr = zero_arr_dbl(3)
///   inspect!(arr, content="[0.0, 0.0, 0.0]")
///   inspect!(arr.length(), content="3")
/// }
/// ```
pub fn zero_arr_dbl(n : Int) -> Array[Double] {
  let arr = []
  for i = 0; i < n; i = i + 1 {
    arr.push(0.0)
  }
  arr
}

///|
/// Reverses the order of elements in an array.
///
/// Parameters:
/// * `array` : An array of any type.
///
/// Returns a new array with elements in reverse order.
///
/// Example:
/// ```moonbit
/// test "reverse" {
///   let arr = [1, 2, 3, 4]
///   inspect!(reverse(arr), content="[4, 3, 2, 1]")
///   inspect!(reverse([]), content="[]")
/// }
/// ```
pub fn reverse[T](array : Array[T]) -> Array[T] {
  let result = []
  for i = array.length() - 1; i >= 0; i = i - 1 {
    result.push(array[i])
  }
  result
}

///|
/// Reverses the order of elements in an array in-place.
///
/// Parameters:
/// * `array` : A mutable array of any type.
///
/// This function modifies the original array and does not return a new array.
///
/// Example:
/// ```moonbit
/// test "reverse_inplace" {
///   let arr = [1, 2, 3, 4]
///   reverse_inplace(arr)
///   inspect!(arr, content="[4, 3, 2, 1]")
///   let empty = []
///   reverse_inplace(empty)
///   inspect!(empty, content="[]")
/// }
/// ```
pub fn reverse_inplace[T](arr : Array[T]) -> Unit {
  let mut left = 0
  let mut right = arr.length() - 1
  while left < right {
    arr.swap(left, right)
    left = left + 1
    right = right - 1
  }
}

///|
/// Finds the index of the first occurrence of a value in an array.
///
/// Parameters:
/// * `array` : An array of any type.
/// * `value` : The value to search for.
///
/// Returns the index of the value if found, otherwise -1.
///
/// Example:
/// ```moonbit
/// test "find" {
///   let arr = [1, 2, 3, 4]
///   inspect!(find(arr, 3), content="2")
///   inspect!(find(arr, 5), content="-1")
/// }
/// ```
pub fn find[T : Eq](array : Array[T], value : T) -> Int? {
  for i = 0; i < array.length(); i = i + 1 {
    if array[i] == value {
      return Some(i)
    }
  }
  None
}

