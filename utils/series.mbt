///|
/// Polynomial coefficients are stored from the constant term upward.
pub fn polynomial_value(coefficients : Array[Double], x : Double) -> Double {
  let mut value = 0.0
  for i = coefficients.length() - 1; i >= 0; i = i - 1 {
    value = value * x + coefficients[i]
  }
  value
}

///|
pub fn polynomial_derivative(
  coefficients : Array[Double],
  x : Double,
) -> Double {
  if coefficients.length() < 2 {
    return 0.0
  }
  let mut value = 0.0
  for i = coefficients.length() - 1; i >= 1; i = i - 1 {
    value = value * x + i.to_double() * coefficients[i]
  }
  value
}

///|
pub fn polynomial_integral(
  coefficients : Array[Double],
  lower : Double,
  upper : Double,
) -> Double {
  let mut upper_value = 0.0
  let mut lower_value = 0.0
  for i in 0..<coefficients.length() {
    let factor = coefficients[i] / (i + 1).to_double()
    upper_value = upper_value + factor * @math.pow(upper, (i + 1).to_double())
    lower_value = lower_value + factor * @math.pow(lower, (i + 1).to_double())
  }
  upper_value - lower_value
}

///|
pub fn convolution(
  left : Array[Double],
  right : Array[Double],
) -> Array[Double] {
  if left.length() == 0 || right.length() == 0 {
    return []
  }
  let output = Array::make(left.length() + right.length() - 1, 0.0)
  for i in 0..<left.length() {
    for j in 0..<right.length() {
      output[i + j] = output[i + j] + left[i] * right[j]
    }
  }
  output
}

///|
pub fn first_difference(values : Array[Double]) -> Array[Double] {
  if values.length() < 2 {
    return []
  }
  let result = Array::make(values.length() - 1, 0.0)
  for i in 1..<values.length() {
    result[i - 1] = values[i] - values[i - 1]
  }
  result
}

///|
pub fn second_difference(values : Array[Double]) -> Array[Double] {
  first_difference(first_difference(values))
}

///|
pub fn exponential_smoothing(
  values : Array[Double],
  alpha : Double,
) -> Array[Double] {
  if values.length() == 0 {
    return []
  }
  let result = Array::make(values.length(), 0.0)
  let a = clamp(alpha, 0.0, 1.0)
  result[0] = values[0]
  for i in 1..<values.length() {
    result[i] = a * values[i] + (1.0 - a) * result[i - 1]
  }
  result
}

///|
pub fn linear_interpolate(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if xs.length() == 0 || xs.length() != ys.length() {
    return 0.0
  }
  if xs.length() == 1 {
    return ys[0]
  }
  if x <= xs[0] {
    return ys[0]
  }
  for i in 1..<xs.length() {
    if x <= xs[i] {
      let width = xs[i] - xs[i - 1]
      if width == 0.0 {
        return ys[i]
      }
      return ys[i - 1] + (x - xs[i - 1]) * (ys[i] - ys[i - 1]) / width
    }
  }
  ys[ys.length() - 1]
}

///|
pub fn resample_uniform(
  xs : Array[Double],
  ys : Array[Double],
  count : Int,
) -> Array[Point] {
  if xs.length() == 0 || xs.length() != ys.length() || count <= 0 {
    return []
  }
  let targets = linspace(xs[0], xs[xs.length() - 1], count)
  let result = []
  for x in targets {
    result.push(Point::{ x, y: linear_interpolate(x, xs, ys) })
  }
  result
}

///|
pub fn trapezoid_area(xs : Array[Double], ys : Array[Double]) -> Double {
  let cumulative = cumulative_trapezoid(xs, ys)
  if cumulative.length() == 0 {
    0.0
  } else {
    cumulative[cumulative.length() - 1]
  }
}

///|
pub fn simpson_area(xs : Array[Double], ys : Array[Double]) -> Double {
  if xs.length() != ys.length() || xs.length() < 3 {
    return trapezoid_area(xs, ys)
  }
  let mut area = 0.0
  let mut i = 0
  while i + 2 < xs.length() {
    let h = (xs[i + 2] - xs[i]) / 6.0
    area = area + h * (ys[i] + 4.0 * ys[i + 1] + ys[i + 2])
    i = i + 2
  }
  if i + 1 < xs.length() {
    area = area + 0.5 * (xs[i + 1] - xs[i]) * (ys[i + 1] + ys[i])
  }
  area
}
