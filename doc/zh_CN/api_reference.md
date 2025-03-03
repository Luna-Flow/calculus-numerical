# API 参考手册

## @Luna-Flow/calculus-numerical/basic

### 类型别名

#### `Func_Math` : `(Double) -> Double`

表示单变量数学函数。

---

#### `Quad_GK` : `(Func_Math, Double, Double) -> (Double, Double, Double, Double)`

表示高斯-克朗罗德（Gauss-Kronrod）数值积分函数，例如 `@integration.kronrod_r15()`。

---

## @Luna-Flow/calculus-numerical/deriv

### 求导方法

#### `deriv_central` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

**描述：**  
使用**自适应中心差分法**计算函数 `f` 在点 `x` 处的导数，通过平衡截断误差和舍入误差提高精度。

**参数：**

- `f: Func_Math` — 输入 `Double` 类型值并返回 `Double` 的数学函数。
- `x: Double` — 求导点的位置。
- `h: Double` — 数值微分的初始步长，必要时会自动调整。

**返回值**  
元组 `(Double, Double)`：

- 第一个值为 `x` 处的导数估计值。
- 第二个值为总估计误差（包含截断误差和舍入误差）。

**示例：**

```moonbit
test "deriv_central" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_central(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

**注意事项：**

- 方法**自动调整步长**以优化精度。
- 对平滑函数效果良好，但在不连续点附近**精度可能下降**。
- 相比简单的两点法，此方法显著降低了数值误差。

---

#### `deriv_forward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

**描述：**  
使用**自适应前向差分法**计算函数 `f` 在点 `x` 处的导数，通过优化步长最小化截断和舍入误差。

**参数：**

- `f: Func_Math` — 输入 `Double` 类型值并返回 `Double` 的数学函数。
- `x: Double` — 求导点的位置。
- `h: Double` — 数值微分的初始步长，必要时会自动调整。

**返回值：**  
元组 `(Double, Double)`：

- 第一个值为导数估计值。
- 第二个值为总估计误差。

**示例：**

```moonbit
test "deriv_forward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_forward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

**注意事项：**

- 方法**自动优化步长**以提高精度。
- 相比基础前向差分法，此方法**显著减少数值误差**。
- 适用于边界点求导（此时中心差分法不可用）。

---

#### `deriv_backward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

**描述：**  
使用**自适应后向差分法**计算函数 `f` 在点 `x` 处的导数，原理与前向差分法相同但步长为负。

**参数：**

- `f: Func_Math` — 输入 `Double` 类型值并返回 `Double` 的数学函数。
- `x: Double` — 求导点的位置。
- `h: Double` — 数值微分的初始步长，必要时会自动调整。

**返回值：**  
元组 `(Double, Double)`：

- 第一个值为导数估计值。
- 第二个值为总估计误差。

**示例：**

```moonbit
test "deriv_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_backward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

**注意事项：**

- 方法**自动优化步长**以提高精度。
- 适用于数据集的**上边界附近求导**。
- 与前向差分法共享相同的数值优势。

---

## @Luna-Flow/calculus-numerical/diff

### 微分方法

#### `diff_backward` : `(f : Func_Math, x : Double) -> (Double, Double)`

**描述：**  
使用自适应步长的后向差分法计算函数在给定点的数值导数。

**参数：**

- `f: Func_Math` — 输入 `Double` 类型值并返回 `Double` 的数学函数。
- `x: Double` — 求导点的位置。

**返回值：**  
元组 `(Double, Double)`：

- 第一个值为后向差分导数估计值。
- 第二个值为计算的绝对误差估计值。

**示例：**

```moonbit
test "diff_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (derivative, error) = diff_backward(f, 2.0)
  inspect!((derivative - 4.0).abs() < error, content="true")
}
```

**注意事项：**

- 方法使用三个后向点自适应计算导数。
- 应用 Neville 递归法计算差分并估计误差。
- 步长 `h` 过大可能降低精度，过小可能导致数值精度问题。

---
