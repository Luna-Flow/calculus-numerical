test "arr_sum_dbl" {
  let arr = [1.0, 2.0, 3.0, 4.0]
  inspect!(arr_sum_dbl(arr), content=10.0.to_string())
  inspect!(arr_sum_dbl([]), content=0.0.to_string())
}

test "zero_arr_dbl" {
  let arr = zero_arr_dbl(3)
  inspect!(arr, content="[0, 0, 0]")
  inspect!(arr.length(), content="3")
}

test "reverse" {
  let arr = [1, 2, 3, 4]
  inspect!(reverse(arr), content="[4, 3, 2, 1]")
  inspect!(reverse([1]), content="[1]")
}

test "reverse_inplace" {
  let mut arr = [1, 2, 3, 4]
  reverse_inplace(arr)
  inspect!(arr, content="[4, 3, 2, 1]")
  arr = [1]
  reverse_inplace(arr)
  inspect!(arr, content="[1]")
}

test "find" {
  let arr = [1, 2, 3, 4]
  inspect!(find(arr, 3), content="Some(2)")
  inspect!(find(arr, 5), content="None")
}
