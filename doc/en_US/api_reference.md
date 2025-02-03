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
#### Basic Mathematical Functions

**`hypot(x : Double, y : Double) -> Double`**:
- Returns the Euclidean norm of `x` and `y`.

<br>

**`pow_integer_exp(base : Double, exp : Integer) -> Double`**:
- Computes `base` raised to the power of any integer exponent using fast exponentiation.
