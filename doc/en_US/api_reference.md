# API Reference Manual
## @KCN-judu/calculus-numerical/basic - Basic
### Constants

**`math_e`**:  
$$
  e
$$

**`math_log_2_e`**:  
$$
  \log_2(e)
$$

**`math_log_10_e`**:  
$$
  \log_{10}(e)
$$

**`math_sqrt_2`**:    
$$
  \sqrt{2}
$$

**`math_sqrt_1_2`**:   
$$
  \sqrt{\frac{1}{2}}
$$

**`math_sqrt_3`**:  
$$
  \sqrt{3}
$$

**`math_pi`**:  
$$
  \pi
$$

**`math_pi_2`**:  
$$
  \frac{\pi}{2}
$$

**`math_pi_4`**:  
$$
  \frac{\pi}{4}
$$

**`math_sqrt_pi`**: 
$$
  \sqrt{\pi}
$$

**`math_2_sqrt_pi`**: 
$$
  \frac{2}{\sqrt{\pi}}
$$

**`math_1_pi`**: 
$$
  \frac{1}{\pi}
$$

**`math_2_pi`**: 
$$
  \frac{2}{\pi}
$$

**`math_ln_10`**:  
$$
  \ln(10)
$$

**`math_ln_2`**: 
$$
  \ln(2)
$$

**`math_ln_pi`**:    
$$
  \ln(\pi)
$$

**`math_euler`**:  
$$
  \gamma = \lim_{n \to \infty} \left( \sum_{k=1}^n \frac{1}{k} - \ln(n) \right)
$$

## Type Aliases

**`Func_Math`**:`(Double) -> Double`

- Represents a unary mathematical function.

<br>

**`Quad_GK`**:`(Func_Math, Double, Double) -> (Double, Double, Double, Double,)`

- Represents a Gauss-Kronrod numerical integration function, such as `@integration.kronrod_r15()`

<br>

### Algebraic Data Types
**`Integer`**:
- __Constructors__:
  - `IntegerInt(Int)`: Constructs an `Integer` object from an `Int`.
  - `IntegerInt64(Int64)`: Constructs an `Integer` object from an `Int64`.
  - `Integer(BigInt)`: Constructs an `Integer` object from a `BigInt`.
- __Constants__:
  - `integer_zero`: The `Integer` representation of 0.
  - `integer_one`: The `Integer` representation of 1.

<br>

### Traits
**`Integral`**:
- __Methods__:
  - `to_integer(self) -> Integer`: Converts a type implementing the `Integral` trait to an `Integer`. The conversion will automatically shrink to different `Integer` constructors depending on the data size (this shrink functionality may be separated in the future).

<br>

### Functions

#### Array Utility Functions
##### General Functions
**`reverse[T](array : Array[T]) -> Array[T]`**:
- Returns a new array with the same elements as the input array, but with the order reversed.

<br>

**`reverse_inplace[T](array : Array[T]) -> Array[T]`**:

- Reverses the order of the elements in the input array in place.

<br>

**`find[T : Eq](array : Array[T], value : T) -> Int?`**:
- Returns the index of the first element equal to `value` in the array, in the form of `Some(index)`. If no such element exists, returns `None`.

<br>

##### `Array[Double]` Functions

**`arr_sum_dbl(arr : Array[Double]) -> Double`**:
- Returns the sum of all elements in the array.

<br>

**`zero_arr_dbl(n : Int) -> Array[Double]`**:
- Returns an array of length `n`, filled with zeros, of type `Double`.

<br>

#### Basic Mathematical Functions

**`sqrt(x : Double) -> Double`**:
- Computes the square root of `x` using Newton's method with a precision of `1e-7`.

<br>

**`hypot(x : Double, y : Double) -> Double`**:
- Returns the Euclidean norm of `x` and `y`.

<br>

**`pow_integer_exp(base : Double, exp : Integer) -> Double`**:
- Computes `base` raised to the power of any integer exponent using fast exponentiation.

#### Comparison Functions

**`max[T : Compare](a : T, b : T) -> T`**:
- Returns the larger of `a` and `b`.

<br>

**`min[T : Compare](a : T, b : T) -> T`**:
- Returns the smaller of `a` and `b`.

<br>

**`clamp[T : Compare](value : T, min : T, max : T) -> T`**:
- Returns `value`. If it is outside the range defined by `min` and `max`, it will be clamped to the nearest boundary (either `min` or `max`).

<br>

**`is_between[T : Compare](value : T, min : T, max : T) -> Bool`**:
- Checks if `value` is between `min` and `max`.

<br>
