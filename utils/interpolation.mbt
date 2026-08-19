///|
/// Interpolation and response-surface utilities used by calibration and simulation.
pub struct InterpolationSample {
  x : Double
  y : Double
}

///|
pub struct InterpolationInterval {
  left : Int
  right : Int
  fraction : Double
}

///|
pub struct CubicSplineSegment {
  x0 : Double
  x1 : Double
  a : Double
  b : Double
  c : Double
  d : Double
}

///|
pub struct SplineModel {
  segments : Array[CubicSplineSegment]
  extrapolate : Bool
}

///|
pub struct InterpolationReport {
  value : Double
  slope : Double
  curvature : Double
  interval : Int
  extrapolated : Bool
}

///|
pub fn interpolation_sample(x : Double, y : Double) -> InterpolationSample {
  { x, y }
}

///|
pub fn interpolation_interval(
  x : Double,
  xs : Array[Double],
) -> InterpolationInterval {
  if xs.length() < 2 {
    return { left: 0, right: 0, fraction: 0.0 }
  }
  if x <= xs[0] {
    let width = xs[1] - xs[0]
    return {
      left: 0,
      right: 1,
      fraction: if width == 0.0 {
        0.0
      } else {
        (x - xs[0]) / width
      },
    }
  }
  for i in 1..<xs.length() {
    if x <= xs[i] {
      let width = xs[i] - xs[i - 1]
      return {
        left: i - 1,
        right: i,
        fraction: if width == 0.0 {
          0.0
        } else {
          (x - xs[i - 1]) / width
        },
      }
    }
  }
  let last = xs.length() - 1
  let width = xs[last] - xs[last - 1]
  {
    left: last - 1,
    right: last,
    fraction: if width == 0.0 {
      1.0
    } else {
      (x - xs[last - 1]) / width
    },
  }
}

///|
pub fn interpolation_interval_value(
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
  let interval = interpolation_interval(x, xs)
  ys[interval.left] +
  interval.fraction * (ys[interval.right] - ys[interval.left])
}

///|
pub fn interpolation_interval_slope(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if xs.length() < 2 || xs.length() != ys.length() {
    return 0.0
  }
  let interval = interpolation_interval(x, xs)
  let width = xs[interval.right] - xs[interval.left]
  if width == 0.0 {
    0.0
  } else {
    (ys[interval.right] - ys[interval.left]) / width
  }
}

///|
pub fn interpolation_report(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> InterpolationReport {
  let interval = interpolation_interval(x, xs)
  let value = interpolation_interval_value(x, xs, ys)
  let slope = interpolation_interval_slope(x, xs, ys)
  let curvature = if xs.length() < 3 || xs.length() != ys.length() {
    0.0
  } else {
    let h = if interval.left == 0 {
      xs[2] - xs[0]
    } else if interval.right == xs.length() - 1 {
      xs[xs.length() - 1] - xs[xs.length() - 3]
    } else {
      xs[interval.right + 1] - xs[interval.left - 1]
    }
    if h == 0.0 {
      0.0
    } else {
      let left = if interval.left == 0 { 0 } else { interval.left - 1 }
      let right = if interval.right == xs.length() - 1 {
        xs.length() - 1
      } else {
        interval.right + 1
      }
      let span = xs[right] - xs[left]
      if span == 0.0 {
        0.0
      } else {
        2.0 *
        (
          (ys[right] - ys[interval.right]) / (xs[right] - xs[interval.right]) -
          (ys[interval.left] - ys[left]) / (xs[interval.left] - xs[left])
        ) /
        span
      }
    }
  }
  {
    value,
    slope,
    curvature,
    interval: interval.left,
    extrapolated: x < xs[0] || x > xs[xs.length() - 1],
  }
}

///|
pub fn nearest_sample(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if xs.length() == 0 || xs.length() != ys.length() {
    return 0.0
  }
  let mut index = 0
  let mut distance = (x - xs[0]).abs()
  for i in 1..<xs.length() {
    let candidate = (x - xs[i]).abs()
    if candidate < distance {
      distance = candidate
      index = i
    }
  }
  ys[index]
}

///|
pub fn step_interpolate(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if xs.length() == 0 || xs.length() != ys.length() {
    return 0.0
  }
  let mut index = 0
  for i in 0..<xs.length() {
    if xs[i] <= x {
      index = i
    }
  }
  ys[index]
}

///|
pub fn monotone_slopes(xs : Array[Double], ys : Array[Double]) -> Array[Double] {
  let n = xs.length()
  if n == 0 || n != ys.length() {
    return []
  }
  if n == 1 {
    return [0.0]
  }
  let slopes = Array::make(n - 1, 0.0)
  for i in 0..<(n - 1) {
    let h = xs[i + 1] - xs[i]
    slopes[i] = if h == 0.0 { 0.0 } else { (ys[i + 1] - ys[i]) / h }
  }
  let result = Array::make(n, 0.0)
  result[0] = slopes[0]
  result[n - 1] = slopes[n - 2]
  for i in 1..<(n - 1) {
    if slopes[i - 1] * slopes[i] <= 0.0 {
      result[i] = 0.0
    } else {
      let h0 = xs[i] - xs[i - 1]
      let h1 = xs[i + 1] - xs[i]
      let w0 = (2.0 * h1 + h0) / (h1 + h0)
      let w1 = (h1 + 2.0 * h0) / (h1 + h0)
      result[i] = (w0 + w1) / (w0 / slopes[i - 1] + w1 / slopes[i])
    }
  }
  result
}

///|
pub fn monotone_cubic_interpolate(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if xs.length() < 2 || xs.length() != ys.length() {
    return if ys.length() == 0 { 0.0 } else { ys[0] }
  }
  let interval = interpolation_interval(x, xs)
  let slopes = monotone_slopes(xs, ys)
  let h = xs[interval.right] - xs[interval.left]
  if h == 0.0 {
    return ys[interval.left]
  }
  let t = interval.fraction
  let h00 = (1.0 + 2.0 * t) * (1.0 - t) * (1.0 - t)
  let h10 = t * (1.0 - t) * (1.0 - t)
  let h01 = t * t * (3.0 - 2.0 * t)
  let h11 = t * t * (t - 1.0)
  h00 * ys[interval.left] +
  h10 * h * slopes[interval.left] +
  h01 * ys[interval.right] +
  h11 * h * slopes[interval.right]
}

///|
pub fn divided_differences(
  xs : Array[Double],
  ys : Array[Double],
) -> Array[Double] {
  if xs.length() == 0 || xs.length() != ys.length() {
    return []
  }
  let coefficients = ys.copy()
  for order in 1..<xs.length() {
    for i = xs.length() - 1; i >= order; i = i - 1 {
      let denominator = xs[i] - xs[i - order]
      coefficients[i] = if denominator == 0.0 {
        0.0
      } else {
        (coefficients[i] - coefficients[i - 1]) / denominator
      }
    }
  }
  coefficients
}

///|
pub fn newton_interpolate(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  let coefficients = divided_differences(xs, ys)
  if coefficients.length() == 0 {
    return 0.0
  }
  let mut value = coefficients[coefficients.length() - 1]
  for i = coefficients.length() - 2; i >= 0; i = i - 1 {
    value = value * (x - xs[i]) + coefficients[i]
  }
  value
}

///|
pub fn lagrange_interpolate(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if xs.length() == 0 || xs.length() != ys.length() {
    return 0.0
  }
  let mut value = 0.0
  for i in 0..<xs.length() {
    let mut basis = 1.0
    for j in 0..<xs.length() {
      if i != j {
        let denominator = xs[i] - xs[j]
        if denominator == 0.0 {
          basis = 0.0
        } else {
          basis = basis * (x - xs[j]) / denominator
        }
      }
    }
    value = value + basis * ys[i]
  }
  value
}

///|
pub fn barycentric_weights(xs : Array[Double]) -> Array[Double] {
  let weights = Array::make(xs.length(), 0.0)
  for i in 0..<xs.length() {
    let mut product = 1.0
    for j in 0..<xs.length() {
      if i != j {
        product = product * (xs[i] - xs[j])
      }
    }
    weights[i] = if product == 0.0 { 0.0 } else { 1.0 / product }
  }
  weights
}

///|
pub fn barycentric_interpolate(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
  weights : Array[Double],
) -> Double {
  if xs.length() == 0 ||
    xs.length() != ys.length() ||
    xs.length() != weights.length() {
    return 0.0
  }
  for i in 0..<xs.length() {
    if x == xs[i] {
      return ys[i]
    }
  }
  let mut numerator = 0.0
  let mut denominator = 0.0
  for i in 0..<xs.length() {
    let term = weights[i] / (x - xs[i])
    numerator = numerator + term * ys[i]
    denominator = denominator + term
  }
  if denominator == 0.0 {
    0.0
  } else {
    numerator / denominator
  }
}

///|
pub fn fit_natural_cubic_spline(
  xs : Array[Double],
  ys : Array[Double],
  extrapolate : Bool,
) -> SplineModel {
  let n = xs.length()
  if n < 2 || n != ys.length() {
    return { segments: [], extrapolate }
  }
  let h = Array::make(n - 1, 0.0)
  for i in 0..<(n - 1) {
    h[i] = xs[i + 1] - xs[i]
  }
  let alpha = Array::make(n, 0.0)
  for i in 1..<(n - 1) {
    let h0 = h[i - 1]
    let h1 = h[i]
    alpha[i] = if h0 == 0.0 || h1 == 0.0 {
      0.0
    } else {
      3.0 / h1 * (ys[i + 1] - ys[i]) - 3.0 / h0 * (ys[i] - ys[i - 1])
    }
  }
  let lower = Array::make(n, 0.0)
  let diagonal = Array::make(n, 0.0)
  let upper = Array::make(n, 0.0)
  let rhs = Array::make(n, 0.0)
  diagonal[0] = 1.0
  diagonal[n - 1] = 1.0
  rhs[0] = 0.0
  rhs[n - 1] = 0.0
  for i in 1..<(n - 1) {
    lower[i] = h[i - 1]
    diagonal[i] = 2.0 * (h[i - 1] + h[i])
    upper[i] = h[i]
    rhs[i] = alpha[i]
  }
  for i in 1..<n {
    let pivot = if diagonal[i - 1].abs() < 1.0e-30 {
      1.0e-30
    } else {
      diagonal[i - 1]
    }
    let factor = lower[i] / pivot
    diagonal[i] = diagonal[i] - factor * upper[i - 1]
    rhs[i] = rhs[i] - factor * rhs[i - 1]
  }
  let c = Array::make(n, 0.0)
  c[n - 1] = if diagonal[n - 1] == 0.0 {
    0.0
  } else {
    rhs[n - 1] / diagonal[n - 1]
  }
  for i = n - 2; i >= 0; i = i - 1 {
    let pivot = if diagonal[i].abs() < 1.0e-30 { 1.0e-30 } else { diagonal[i] }
    c[i] = (rhs[i] - upper[i] * c[i + 1]) / pivot
  }
  let segments = Array::make(n - 1, {
    x0: 0.0,
    x1: 0.0,
    a: 0.0,
    b: 0.0,
    c: 0.0,
    d: 0.0,
  })
  for i in 0..<(n - 1) {
    let width = h[i]
    let a = ys[i]
    let b = if width == 0.0 {
      0.0
    } else {
      (ys[i + 1] - ys[i]) / width - width * (2.0 * c[i] + c[i + 1]) / 3.0
    }
    let d = if width == 0.0 { 0.0 } else { (c[i + 1] - c[i]) / (3.0 * width) }
    segments[i] = { x0: xs[i], x1: xs[i + 1], a, b, c: c[i], d }
  }
  { segments, extrapolate }
}

///|
fn spline_segment(
  model : SplineModel,
  x : Double,
) -> (CubicSplineSegment, Int, Bool) {
  let n = model.segments.length()
  if n == 0 {
    return ({ x0: 0.0, x1: 0.0, a: 0.0, b: 0.0, c: 0.0, d: 0.0 }, 0, true)
  }
  if x < model.segments[0].x0 {
    return (model.segments[0], 0, true)
  }
  for i in 0..<n {
    if x <= model.segments[i].x1 {
      return (model.segments[i], i, false)
    }
  }
  (model.segments[n - 1], n - 1, true)
}

///|
pub fn spline_value(model : SplineModel, x : Double) -> Double {
  if model.segments.length() == 0 {
    return 0.0
  }
  let (segment, _, outside) = spline_segment(model, x)
  if outside && !model.extrapolate {
    if x < segment.x0 {
      return segment.a
    }
    let width = segment.x1 - segment.x0
    return segment.a +
      segment.b * width +
      segment.c * width * width +
      segment.d * width * width * width
  }
  let dx = x - segment.x0
  segment.a + dx * (segment.b + dx * (segment.c + dx * segment.d))
}

///|
pub fn spline_slope(model : SplineModel, x : Double) -> Double {
  if model.segments.length() == 0 {
    return 0.0
  }
  let (segment, _, _) = spline_segment(model, x)
  let dx = x - segment.x0
  segment.b + dx * (2.0 * segment.c + 3.0 * dx * segment.d)
}

///|
pub fn spline_curvature(model : SplineModel, x : Double) -> Double {
  if model.segments.length() == 0 {
    return 0.0
  }
  let (segment, _, _) = spline_segment(model, x)
  let dx = x - segment.x0
  2.0 * segment.c + 6.0 * dx * segment.d
}

///|
pub fn spline_report(model : SplineModel, x : Double) -> InterpolationReport {
  if model.segments.length() == 0 {
    return {
      value: 0.0,
      slope: 0.0,
      curvature: 0.0,
      interval: 0,
      extrapolated: true,
    }
  }
  let (_, index, outside) = spline_segment(model, x)
  {
    value: spline_value(model, x),
    slope: spline_slope(model, x),
    curvature: spline_curvature(model, x),
    interval: index,
    extrapolated: outside,
  }
}

///|
pub fn resample_linear(
  source_x : Array[Double],
  source_y : Array[Double],
  target_x : Array[Double],
) -> Array[Double] {
  let output = Array::make(target_x.length(), 0.0)
  for i in 0..<target_x.length() {
    output[i] = interpolation_interval_value(target_x[i], source_x, source_y)
  }
  output
}

///|
pub fn resample_monotone(
  source_x : Array[Double],
  source_y : Array[Double],
  target_x : Array[Double],
) -> Array[Double] {
  let output = Array::make(target_x.length(), 0.0)
  for i in 0..<target_x.length() {
    output[i] = monotone_cubic_interpolate(target_x[i], source_x, source_y)
  }
  output
}

///|
pub fn resample_spline(
  model : SplineModel,
  target_x : Array[Double],
) -> Array[Double] {
  let output = Array::make(target_x.length(), 0.0)
  for i in 0..<target_x.length() {
    output[i] = spline_value(model, target_x[i])
  }
  output
}

///|
pub fn interpolation_integral(xs : Array[Double], ys : Array[Double]) -> Double {
  if xs.length() < 2 || xs.length() != ys.length() {
    return 0.0
  }
  let mut area = 0.0
  for i in 0..<(xs.length() - 1) {
    area = area + 0.5 * (ys[i] + ys[i + 1]) * (xs[i + 1] - xs[i])
  }
  area
}

///|
pub fn interpolation_weighted_mean(
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  let area = interpolation_integral(xs, ys)
  if xs.length() < 2 || xs[xs.length() - 1] == xs[0] {
    0.0
  } else {
    area / (xs[xs.length() - 1] - xs[0])
  }
}

///|
pub fn crossing_locations(
  xs : Array[Double],
  ys : Array[Double],
  level : Double,
) -> Array[Double] {
  if xs.length() < 2 || xs.length() != ys.length() {
    return []
  }
  let result : Array[Double] = []
  for i in 0..<(xs.length() - 1) {
    let left = ys[i] - level
    let right = ys[i + 1] - level
    if left == 0.0 {
      result.push(xs[i])
    } else if left * right < 0.0 {
      let width = xs[i + 1] - xs[i]
      if right == left {
        result.push(xs[i])
      } else {
        result.push(xs[i] - left * width / (right - left))
      }
    }
  }
  if ys[ys.length() - 1] == level {
    result.push(xs[xs.length() - 1])
  }
  result
}

///|
pub fn monotonicity_violations(
  values : Array[Double],
  increasing : Bool,
) -> Int {
  let mut violations = 0
  for i in 1..<values.length() {
    if increasing && values[i] < values[i - 1] {
      violations = violations + 1
    }
    if !increasing && values[i] > values[i - 1] {
      violations = violations + 1
    }
  }
  violations
}

///|
pub fn enforce_monotone(
  values : Array[Double],
  increasing : Bool,
) -> Array[Double] {
  let result = values.copy()
  for i in 1..<result.length() {
    if increasing && result[i] < result[i - 1] {
      result[i] = result[i - 1]
    }
    if !increasing && result[i] > result[i - 1] {
      result[i] = result[i - 1]
    }
  }
  result
}

///|
pub fn interpolate_log_x(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  let log_x = @math.ln(x)
  let log_xs = Array::make(xs.length(), 0.0)
  for i in 0..<xs.length() {
    log_xs[i] = if xs[i] <= 0.0 { 0.0 } else { @math.ln(xs[i]) }
  }
  interpolation_interval_value(log_x, log_xs, ys)
}

///|
pub fn interpolate_log_y(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if xs.length() != ys.length() {
    return 0.0
  }
  let log_ys = Array::make(ys.length(), 0.0)
  for i in 0..<ys.length() {
    log_ys[i] = if ys[i] <= 0.0 { 0.0 } else { @math.ln(ys[i]) }
  }
  @math.exp(interpolation_interval_value(x, xs, log_ys))
}

///|
pub fn interpolate_log_log(
  x : Double,
  xs : Array[Double],
  ys : Array[Double],
) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  let log_xs = Array::make(xs.length(), 0.0)
  let log_ys = Array::make(ys.length(), 0.0)
  for i in 0..<xs.length() {
    log_xs[i] = if xs[i] <= 0.0 { 0.0 } else { @math.ln(xs[i]) }
    log_ys[i] = if ys[i] <= 0.0 { 0.0 } else { @math.ln(ys[i]) }
  }
  @math.exp(interpolation_interval_value(@math.ln(x), log_xs, log_ys))
}
