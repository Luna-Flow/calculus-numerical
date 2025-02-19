# API 参考手册
## @Luna-Flow/calculus-numerical/basic 基础
### 常量

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

## 类型别名

**`Func_Math`**:`(Double) -> Double`

- 用来表示数学上的一元函数

<br>

**`Quad_GK`**:`(Func_Math, Double, Double) -> (Double, Double, Double, Double,)`

- 用来表示Gauss-Kronrod数值积分函数，例如`@integration.kronrod_r15()`

<br>


### 代数数据类型
**`Integer`**:
- __构造器__:
  - `IntegerInt(Int)`: 从`Int`构造一个`Integer`对象。
  - `IntegerInt64(Int64)`: 从`Int64`构造一个`Integer`对象。
  - `Integer(BigInt)`: 从`BigInt`构造一个`Integer`对象。
- __常量__:
  - `integer_zero`: 0的`Integer`表示。
  - `integer_one`: 1的`Integer`表示。

<br>

### 特征接口
**`Integral`**:
- __方法__:
  - `to_integer(self) -> Integer`: 将实现了`Integral`特征的类型转换为`Integer`类型，在这一转换过程中会根据数据大小自动收缩到不同的Integer构造器（未来可能会将shrink功能分离）。

<br>

### 函数
#### 基本数学函数

**`hypot(x : Double, y : Double) -> Double`**:
- 返回`x`和`y`的欧几里得范数。

<br>

**`pow_integer_exp(base : Double, exp : Integer) -> Double`**:
- 使用快速幂运算计算`base`的任意整数类型指数的幂。
