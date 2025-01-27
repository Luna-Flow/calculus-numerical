///|
test "max" {
  assert_true!(max(3, 5) == 5)
  assert_true!(max(2.5, 1.5) == 2.5)
  assert_true!(max("abc", "def") == "def")
}

///|
test "min" {
  assert_true!(min(3, 5) == 3)
  assert_true!(min(2.5, 1.5) == 1.5)
  assert_true!(min("abc", "def") == "abc")
}

///|
test "clamp" {
  assert_true!(clamp(3, 5, 7) == 5)
  assert_true!(clamp(2.5, 1.5, 3.5) == 2.5)
  assert_true!(clamp("abc", "def", "ghi") == "def")
  assert_true!(clamp("xxx", "def", "ghi") == "ghi")
}

///|
test "is_between" {
  assert_true!(is_between(5, 5, 7))
  assert_true!(is_between(7, 5, 7))
  assert_false!(is_between(3, 5, 7))
}
