///|
/// Represents a complex number with real and imaginary parts.
///
/// A complex number is a combination of a real number and an imaginary number in
/// the form `a + bi`, where `a` is the real part, `b` is the imaginary part, and
/// `i` is the imaginary unit defined by `i² = -1`. Both parts are stored as
/// double-precision floating-point numbers.
///
/// Parameters:
///
/// * `re` : The real part of the complex number.
/// * `im` : The imaginary part of the complex number.
///
/// Example:
///
/// ```moonbit
/// test "Complex/construction" {
///   let z = Complex::new(3.0, 4.0)
///   inspect!(z.re, content="3")
///   inspect!(z.im, content="4")
/// }
/// ```
pub(all) struct Complex {
  mut re : Double
  mut im : Double
}

//init

///|
pub fn Complex::new(re : Double, im : Double) -> Complex {
  Complex::{ re, im }
}

//oper

///|
pub fn Complex::set(self : Complex, re : Double, im : Double) -> Unit {
  self.re = re
  self.im = im
}

///|
pub fn Complex::set_re(self : Complex, re : Double) -> Unit {
  self.re = re
}

///|
pub fn Complex::set_im(self : Complex, im : Double) -> Unit {
  self.im = im
}

///|
pub fn Complex::native_pack(
  re : Double,
  im : Double,
  arr : Array[Double],
  offset : Int
) -> Unit {
  guard offset >= 0 && offset < arr.length() / 2
  arr[2 * offset] = re
  arr[2 * offset + 1] = im
}

///|
pub fn Complex::pack(self : Complex, arr : Array[Double], offset : Int) -> Unit {
  Complex::native_pack(self.re, self.im, arr, offset)
}

//math

///|
pub fn Complex::polar(r : Double, theta : Double) -> Complex {
  Complex::new(r * @math.cos(theta), r * @math.sin(theta))
}

///|
pub fn Complex::arg(self : Complex) -> Double {
  guard self.re != 0.0 || self.im != 0.0 else { 0.0 }
  @math.atan2(self.im, self.re)
}

///|
pub fn Complex::abs(self : Complex) -> Double {
  @basic.hypot(self.re, self.im)
}

///|
pub fn Complex::abs_sqr(self : Complex) -> Double {
  self.re * self.re + self.im * self.im
}

///|
pub fn Complex::abs_log(self : Complex) -> Double {
  let re_abs = self.re.abs()
  let im_abs = self.im.abs()
  let mut t = 0.0
  if re_abs >= im_abs {
    t = im_abs / re_abs
  } else {
    t = re_abs / im_abs
  }
  @math.ln(@basic.max(re_abs, im_abs)) + 0.5 * @math.ln(1.0 + t * t)
}

///|
pub fn Complex::op_add(self : Complex, other : Complex) -> Complex {
  Complex::new(self.re + other.re, self.im + other.im)
}

///|
pub fn Complex::add(self : Complex, other : Complex) -> Unit {
  self.re = self.re + other.re
  self.im = self.im + other.im
}

///|
pub fn Complex::add_real(self : Complex, other : Double) -> Complex {
  Complex::new(self.re + other, self.im)
}

///|
pub fn Complex::add_real_inplace(self : Complex, other : Double) -> Unit {
  self.re = self.re + other
}

///|
pub fn Complex::add_imag(self : Complex, other : Double) -> Complex {
  Complex::new(self.re, self.im + other)
}

///|
pub fn Complex::add_imag_inplace(self : Complex, other : Double) -> Unit {
  self.im = self.im + other
}

///|
pub fn Complex::op_sub(self : Complex, other : Complex) -> Complex {
  Complex::new(self.re - other.re, self.im - other.im)
}

///|
pub fn Complex::sub(self : Complex, other : Complex) -> Unit {
  self.re = self.re - other.re
  self.im = self.im - other.im
}

///|
pub fn Complex::sub_real(self : Complex, other : Double) -> Complex {
  Complex::new(self.re - other, self.im)
}

///|
pub fn Complex::sub_real_inplace(self : Complex, other : Double) -> Unit {
  self.re = self.re - other
}

///|
pub fn Complex::sub_imag(self : Complex, other : Double) -> Complex {
  Complex::new(self.re, self.im - other)
}

///|
pub fn Complex::sub_imag_inplace(self : Complex, other : Double) -> Unit {
  self.im = self.im - other
}

///|
pub fn Complex::op_mul(self : Complex, other : Complex) -> Complex {
  Complex::new(
    self.re * other.re - self.im * other.im,
    self.re * other.im + self.im * other.re,
  )
}

///|
pub fn Complex::mul(self : Complex, other : Complex) -> Unit {
  let re = self.re * other.re - self.im * other.im
  let im = self.re * other.im + self.im * other.re
  self.re = re
  self.im = im
}

///|
pub fn Complex::mul_real(self : Complex, other : Double) -> Complex {
  Complex::new(self.re * other, self.im * other)
}

///|
pub fn Complex::mul_real_inplace(self : Complex, other : Double) -> Unit {
  self.re = self.re * other
  self.im = self.im * other
}

///|
pub fn Complex::mul_imag(self : Complex, other : Double) -> Complex {
  Complex::new(-self.im * other, self.re * other)
}

///|
pub fn Complex::mul_imag_inplace(self : Complex, other : Double) -> Unit {
  let re = -self.im * other
  let im = self.re * other
  self.re = re
  self.im = im
}

///|
pub fn Complex::op_div(self : Complex, other : Complex) -> Complex {
  let s = 1.0 / other.abs()
  let sbr = s * other.re
  let sbi = s * other.im
  let re = (self.re * sbr + self.im * sbi) * s
  let im = (self.im * sbr - self.re * sbi) * s
  Complex::new(re, im)
}

///|
pub fn Complex::div(self : Complex, other : Complex) -> Unit {
  let s = 1.0 / other.abs()
  let sbr = s * other.re
  let sbi = s * other.im
  let re = (self.re * sbr + self.im * sbi) * s
  let im = (self.im * sbr - self.re * sbi) * s
  self.re = re
  self.im = im
}

///|
pub fn Complex::div_real(self : Complex, other : Double) -> Complex {
  Complex::new(self.re / other, self.im / other)
}

///|
pub fn Complex::div_real_inplace(self : Complex, other : Double) -> Unit {
  self.re = self.re / other
  self.im = self.im / other
}

///|
pub fn Complex::div_imag(self : Complex, other : Double) -> Complex {
  Complex::new(self.im / other, -self.re / other)
}

///|
pub fn Complex::div_imag_inplace(self : Complex, other : Double) -> Unit {
  let re = self.im / other
  let im = -self.re / other
  self.re = re
  self.im = im
}

///|
pub fn Complex::conjugate(self : Complex) -> Complex {
  Complex::new(self.re, -self.im)
}

///|
pub fn Complex::conjugate_inplace(self : Complex) -> Unit {
  self.im = -self.im
}

///|
pub fn Complex::op_neg(self : Complex) -> Complex {
  Complex::new(-self.re, -self.im)
}

///|
pub fn Complex::neg(self : Complex) -> Unit {
  self.re = -self.re
  self.im = -self.im
}

///|
pub fn Complex::sqrt(self : Complex) -> Complex {
  guard self.re != 0 || self.im != 0 else { Complex::new(0.0, 0.0) }
  let re_abs = self.re.abs()
  let im_abs = self.im.abs()
  let mut w = 0.0
  if re_abs >= im_abs {
    let t = im_abs / re_abs
    w = @basic.sqrt(re_abs) * @basic.sqrt(0.5 * (1.0 + @basic.hypot(1.0, t)))
  } else {
    let t = re_abs / im_abs
    w = @basic.sqrt(im_abs) * @basic.sqrt(0.5 * (t + @basic.hypot(1.0, t)))
  }
  if self.re >= 0.0 {
    Complex::new(w, self.im / (2.0 * w))
  } else {
    let im = if self.im >= 0.0 { w } else { -w }
    Complex::new(self.im / (2.0 * im), im)
  }
}

//prop

///|
pub impl Eq for Complex with op_equal(self : Complex, other : Complex) -> Bool {
  self.re == other.re && self.im == other.im
}
