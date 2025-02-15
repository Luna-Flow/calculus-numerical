# API 参考手册

## @KCN-judu/calculus-numerical/basic

### タイプエイリアス

#### `Func_Math` : `(Double) -> Double`

単変数の数学関数を表現します。

<br>

#### `Quad_GK` : `(Func_Math, Double, Double) -> (Double, Double, Double, Double,)`

`@integration.kronrod_r15()`のようなガウス・クロンロッド型数値積分関数を表現します。

<br>

## @KCN-judu/calculus-numerical/deriv

### 微分係数

#### `deriv_central` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

##### 説明

関数`f`の点`x`における微分係数を、__適応的中心差分法__を使用して計算します。これは、切り捨て誤差と丸め誤差を調和させ、精度を向上させます。

##### パラメーター

- `f: Func_Math` — `Double`を入力とし、`Double`を出力とする数学関数。
- `x: Double` — 微分係数を評価する点。
- `h: Double` — 数値微分の初期ステップサイズ。必要に応じて適応的に調整されます。

##### 戻り値

タプル`(Double, Double)`で、以下の内容を返します：

- 第一値は`x`における推定微分係数。
- 第二値は、切り捨て誤差と丸め誤差を組み合わせた総推定誤差。

##### 例

```moonbit
test "deriv_central" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_central(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

##### メモ

- この方法は、精度を最適化するため、__自動的にステップサイズを調整__します。
- スムーズな関数には効果的ですが、不連続点近傍では__精度が低下する可能性__があります。
- 簡単な2点法と比較して、このアプローチは数値誤差を大きく低減します。

<br>

#### `deriv_forward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

##### 説明

関数`f`の点`x`における微分係数を、__適応的前進差分法__を使用して計算します。これは、ステップサイズを調整して、切り捨て誤差と丸め誤差を最小化します。

##### パラメーター

- `f: Func_Math` — `Double`を入力とし、`Double`を出力とする数学関数。
- `x: Double` — 微分係数を評価する点。
- `h: Double` — 数値微分の初期ステップサイズ。必要に応じて適応的に調整されます。

##### 戻り値

タプル`(Double, Double)`で、以下の内容を返します：

- 第一値は`x`における推定微分係数。
- 第二値は、切り捨て誤差と丸め誤差を組み合わせた総推定誤差。

##### 例

```moonbit
test "deriv_forward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_forward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

##### メモ

- この方法は、精度を最適化するため、__自動的にステップサイズを調整__します。
- 簡単な前進差分法と比較して、このアプローチは数値誤差を大幅に低減します。
- スムーズな関数には効果的ですが、急変や不連続を有する関数では__精度が低下する可能性__があります。
- 中央差分が適用できない境界で微分係数を評価する場合に特に役立ちます。

<br>

#### `deriv_backward` : `(f: Func_Math, x: Double, h: Double) -> (Double, Double)`

##### 説明

関数`f`の点`x`における微分係数を、__適応的後退差分法__を使用して計算します。これは、前進差分微分係数と同様ですが、負のステップサイズを使用します。

##### パラメーター

- `f: Func_Math` — `Double`を入力とし、`Double`を出力とする数学関数。
- `x: Double` — 微分係数を評価する点。
- `h: Double` — 数値微分の初期ステップサイズ。必要に応じて適応的に調整されます。

##### 戻り値

タプル`(Double, Double)`で、以下の内容を返します：

- 第一値は`x`における推定微分係数。
- 第二値は、切り捨て誤差と丸め誤差を組み合わせた総推定誤差。

##### 例

```moonbit
test "deriv_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x², f'(x) = 2x
  let (deriv, error) = deriv_backward(f, 2.0, 0.1)
  inspect!((deriv - 4.0).abs() < error, content="true")
}
```

##### メモ

- この方法は、精度を最適化するため、__自動的にステップサイズを調整__します。
- データセットの上界近傍などで微分を行う場合、__後退差分法__が適していることがあります。
- `deriv_forward`と同様の数値的な利点を持ち、単純な有限差分と比較して数値誤差を大幅に低減します。

<br>

## @KCN-judu/calculus-numerical/diff

### 微分

#### `diff_backward` : `(f : Func_Math, x : Double) -> (Double, Double)`

##### 説明

適応ステップサイズを使用して、与えられた点における関数の数値微分係数を後退差分法を使用して計算します。

##### パラメーター

- `f: Func_Math` — `Double`を入力とし、`Double`を出力とする関数。微分対象の関数。
- `x: Double` — 微分係数を計算する点。

##### 戻り値

タプル`(Double, Double)`で、以下の内容を返します：

- 第一値は後退差分近似を使用した推定微分係数値。
- 第二値は計算の推定絶対誤差。

##### 例

```
test "diff_backward" {
  let f = fn(x : Double) { x * x } // f(x) = x^2, f'(x) = 2x
  let (derivative, error) = diff_backward(f, 2.0)
  inspect!((derivative - 4.0).abs() < error, content="true")
}
```

##### メモ

- この関数は、適応ステップサイズを使用して3つの後方差分点で与えられた関数を評価します。
- 商差を計算し、微分係数の推定にネビルの再帰法を適用します。
- 方法には、2階商差に基づく誤差推定が含まれています。
- `h`が大きすぎると精度が低下する可能性があり、小さすぎると数値精度の問題が発生する可能性があります。