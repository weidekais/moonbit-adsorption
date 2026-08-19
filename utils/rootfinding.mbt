///|
pub(all) struct RootResult {
  root : Double
  value : Double
  iterations : Int
  converged : Bool
  bracketed : Bool
} derive(Debug, Eq)

///|
pub(all) struct Bracket {
  lower : Double
  upper : Double
  lower_value : Double
  upper_value : Double
  valid : Bool
} derive(Debug, Eq)

///|
pub(all) struct ExtremumResult {
  point : Double
  value : Double
  iterations : Int
  converged : Bool
} derive(Debug, Eq)

///|
pub(all) struct RootScanPoint {
  x : Double
  value : Double
  sign_change : Bool
} derive(Debug, Eq)

///|
pub fn make_bracket(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
) -> Bracket {
  let lo = if lower <= upper { lower } else { upper }
  let hi = if lower <= upper { upper } else { lower }
  let flo = f(lo)
  let fhi = f(hi)
  {
    lower: lo,
    upper: hi,
    lower_value: flo,
    upper_value: fhi,
    valid: flo == 0.0 || fhi == 0.0 || flo * fhi < 0.0,
  }
}

///|
pub fn bracket_width(bracket : Bracket) -> Double {
  (bracket.upper - bracket.lower).abs()
}

///|
pub fn bracket_midpoint(bracket : Bracket) -> Double {
  0.5 * (bracket.lower + bracket.upper)
}

///|
pub fn root_residual(result : RootResult) -> Double {
  result.value.abs()
}

///|
pub fn root_success(
  result : RootResult,
  x_tolerance : Double,
  y_tolerance : Double,
) -> Bool {
  result.converged &&
  (result.root.abs() <= x_tolerance || result.value.abs() <= y_tolerance)
}

///|
pub fn bisection(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  max_iterations : Int,
) -> RootResult {
  let bracket = make_bracket(f, lower, upper)
  let max_iter = if max_iterations < 1 { 1 } else { max_iterations }
  let tolerance_value = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  if !bracket.valid {
    let midpoint = bracket_midpoint(bracket)
    return {
      root: midpoint,
      value: f(midpoint),
      iterations: 0,
      converged: false,
      bracketed: false,
    }
  }
  if bracket.lower_value == 0.0 {
    return {
      root: bracket.lower,
      value: 0.0,
      iterations: 0,
      converged: true,
      bracketed: true,
    }
  }
  if bracket.upper_value == 0.0 {
    return {
      root: bracket.upper,
      value: 0.0,
      iterations: 0,
      converged: true,
      bracketed: true,
    }
  }
  let mut lo = bracket.lower
  let mut hi = bracket.upper
  let mut flo = bracket.lower_value
  let mut mid = bracket_midpoint(bracket)
  let mut fmid = f(mid)
  let mut converged = false
  let mut iterations = 0
  for i in 0..<max_iter {
    iterations = i + 1
    mid = 0.5 * (lo + hi)
    fmid = f(mid)
    if fmid.abs() <= tolerance_value || (hi - lo).abs() <= tolerance_value {
      converged = true
      break
    }
    if flo * fmid <= 0.0 {
      hi = mid
    } else {
      lo = mid
      flo = fmid
    }
  }
  { root: mid, value: fmid, iterations, converged, bracketed: true }
}

///|
pub fn regula_falsi(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  max_iterations : Int,
) -> RootResult {
  let bracket = make_bracket(f, lower, upper)
  let max_iter = if max_iterations < 1 { 1 } else { max_iterations }
  let tolerance_value = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  if !bracket.valid {
    let x = bracket_midpoint(bracket)
    return {
      root: x,
      value: f(x),
      iterations: 0,
      converged: false,
      bracketed: false,
    }
  }
  let mut lo = bracket.lower
  let mut hi = bracket.upper
  let mut flo = bracket.lower_value
  let mut fhi = bracket.upper_value
  let mut x = lo
  let mut fx = flo
  let mut previous = x
  let mut converged = false
  let mut iterations = 0
  for i in 0..<max_iter {
    iterations = i + 1
    let denominator = fhi - flo
    if denominator == 0.0 {
      break
    }
    x = (lo * fhi - hi * flo) / denominator
    fx = f(x)
    if fx.abs() <= tolerance_value || (x - previous).abs() <= tolerance_value {
      converged = true
      break
    }
    previous = x
    if flo * fx < 0.0 {
      hi = x
      fhi = fx
    } else {
      lo = x
      flo = fx
    }
  }
  { root: x, value: fx, iterations, converged, bracketed: true }
}

///|
pub fn secant(
  f : (Double) -> Double,
  first : Double,
  second : Double,
  tolerance : Double,
  max_iterations : Int,
) -> RootResult {
  let tolerance_value = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  let max_iter = if max_iterations < 1 { 1 } else { max_iterations }
  let mut x0 = first
  let mut x1 = second
  let mut f0 = f(x0)
  let mut f1 = f(x1)
  let mut converged = false
  let mut iterations = 0
  for i in 0..<max_iter {
    iterations = i + 1
    if f1.abs() <= tolerance_value {
      converged = true
      break
    }
    let denominator = f1 - f0
    if denominator == 0.0 {
      break
    }
    let x2 = x1 - f1 * (x1 - x0) / denominator
    if (x2 - x1).abs() <= tolerance_value {
      x1 = x2
      f1 = f(x1)
      converged = true
      break
    }
    x0 = x1
    f0 = f1
    x1 = x2
    f1 = f(x1)
  }
  { root: x1, value: f1, iterations, converged, bracketed: false }
}

///|
pub fn newton(
  f : (Double) -> Double,
  derivative : (Double) -> Double,
  initial : Double,
  tolerance : Double,
  max_iterations : Int,
) -> RootResult {
  let tolerance_value = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  let max_iter = if max_iterations < 1 { 1 } else { max_iterations }
  let mut x = initial
  let mut fx = f(x)
  let mut converged = false
  let mut iterations = 0
  for i in 0..<max_iter {
    iterations = i + 1
    if fx.abs() <= tolerance_value {
      converged = true
      break
    }
    let slope = derivative(x)
    if slope.abs() <= 1.0e-30 {
      break
    }
    let next = x - fx / slope
    if (next - x).abs() <= tolerance_value {
      x = next
      fx = f(x)
      converged = fx.abs() <= tolerance_value
      break
    }
    x = next
    fx = f(x)
  }
  { root: x, value: fx, iterations, converged, bracketed: false }
}

///|
pub fn safeguarded_newton(
  f : (Double) -> Double,
  derivative : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  max_iterations : Int,
) -> RootResult {
  let bracket = make_bracket(f, lower, upper)
  let max_iter = if max_iterations < 1 { 1 } else { max_iterations }
  let tolerance_value = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  if !bracket.valid {
    let x = bracket_midpoint(bracket)
    return newton(f, derivative, x, tolerance_value, max_iter)
  }
  let mut lo = bracket.lower
  let mut hi = bracket.upper
  let mut flo = bracket.lower_value
  let mut fhi = bracket.upper_value
  let mut x = bracket_midpoint(bracket)
  let mut fx = f(x)
  let mut converged = false
  let mut iterations = 0
  for i in 0..<max_iter {
    iterations = i + 1
    if fx.abs() <= tolerance_value || (hi - lo).abs() <= tolerance_value {
      converged = true
      break
    }
    let slope = derivative(x)
    let candidate = if slope.abs() > 1.0e-30 {
      x - fx / slope
    } else {
      bracket_midpoint({
        lower: lo,
        upper: hi,
        lower_value: flo,
        upper_value: fhi,
        valid: true,
      })
    }
    let safe_candidate = if candidate <= lo || candidate >= hi {
      0.5 * (lo + hi)
    } else {
      candidate
    }
    let fcandidate = f(safe_candidate)
    if flo * fcandidate <= 0.0 {
      hi = safe_candidate
      fhi = fcandidate
    } else {
      lo = safe_candidate
      flo = fcandidate
    }
    x = safe_candidate
    fx = fcandidate
  }
  { root: x, value: fx, iterations, converged, bracketed: true }
}

///|
pub fn fixed_point(
  g : (Double) -> Double,
  initial : Double,
  tolerance : Double,
  max_iterations : Int,
) -> RootResult {
  let tolerance_value = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  let max_iter = if max_iterations < 1 { 1 } else { max_iterations }
  let mut x = initial
  let mut next = g(x)
  let mut iterations = 0
  let mut converged = false
  for i in 0..<max_iter {
    iterations = i + 1
    next = g(x)
    if (next - x).abs() <= tolerance_value {
      x = next
      converged = true
      break
    }
    x = next
  }
  { root: x, value: next - x, iterations, converged, bracketed: false }
}

///|
pub fn bracket_expand(
  f : (Double) -> Double,
  center : Double,
  initial_radius : Double,
  growth : Double,
  max_expansions : Int,
) -> Bracket {
  let radius = if initial_radius <= 0.0 { 1.0 } else { initial_radius }
  let factor = if growth <= 1.0 { 2.0 } else { growth }
  let count = if max_expansions < 0 { 0 } else { max_expansions }
  let mut lower = center - radius
  let mut upper = center + radius
  let mut bracket = make_bracket(f, lower, upper)
  for _ in 0..<count {
    if bracket.valid {
      break
    }
    let width = upper - lower
    lower = center - width * factor
    upper = center + width * factor
    bracket = make_bracket(f, lower, upper)
  }
  bracket
}

///|
pub fn scan_roots(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Array[RootScanPoint] {
  let count = if samples < 2 { 2 } else { samples }
  let xs = linspace(lower, upper, count)
  let points = Array::make(count, { x: 0.0, value: 0.0, sign_change: false })
  for i in 0..<count {
    let value = f(xs[i])
    let changed = if i == 0 {
      value == 0.0
    } else {
      value == 0.0 || value * points[i - 1].value < 0.0
    }
    points[i] = { x: xs[i], value, sign_change: changed }
  }
  points
}

///|
pub fn roots_from_scan(
  f : (Double) -> Double,
  scan : Array[RootScanPoint],
  tolerance : Double,
  max_iterations : Int,
) -> Array[RootResult] {
  let roots = []
  for i in 0..<scan.length() {
    let point = scan[i]
    if point.value == 0.0 {
      roots.push({
        root: point.x,
        value: 0.0,
        iterations: 0,
        converged: true,
        bracketed: true,
      })
    } else if point.sign_change && i > 0 {
      roots.push(
        bisection(f, scan[i - 1].x, point.x, tolerance, max_iterations),
      )
    }
  }
  roots
}

///|
pub fn solve_bracketed(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  max_iterations : Int,
) -> RootResult {
  let bracket = make_bracket(f, lower, upper)
  if bracket.valid {
    safeguarded_newton(
      f,
      fn(x) { (f(x + 1.0e-6) - f(x - 1.0e-6)) / 2.0e-6 },
      lower,
      upper,
      tolerance,
      max_iterations,
    )
  } else {
    secant(f, lower, upper, tolerance, max_iterations)
  }
}

///|
pub fn minimize_golden(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  max_iterations : Int,
) -> ExtremumResult {
  let phi = 0.6180339887498949
  let tolerance_value = if tolerance <= 0.0 { 1.0e-10 } else { tolerance }
  let max_iter = if max_iterations < 1 { 1 } else { max_iterations }
  let mut lo = if lower <= upper { lower } else { upper }
  let mut hi = if lower <= upper { upper } else { lower }
  let mut x1 = hi - phi * (hi - lo)
  let mut x2 = lo + phi * (hi - lo)
  let mut f1 = f(x1)
  let mut f2 = f(x2)
  let mut iterations = 0
  let mut converged = false
  for i in 0..<max_iter {
    iterations = i + 1
    if (hi - lo).abs() <= tolerance_value {
      converged = true
      break
    }
    if f1 < f2 {
      hi = x2
      x2 = x1
      f2 = f1
      x1 = hi - phi * (hi - lo)
      f1 = f(x1)
    } else {
      lo = x1
      x1 = x2
      f1 = f2
      x2 = lo + phi * (hi - lo)
      f2 = f(x2)
    }
  }
  let point = if f1 < f2 { x1 } else { x2 }
  { point, value: f(point), iterations, converged }
}

///|
pub fn maximize_golden(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  max_iterations : Int,
) -> ExtremumResult {
  let result = minimize_golden(
    fn(x) { -f(x) },
    lower,
    upper,
    tolerance,
    max_iterations,
  )
  {
    point: result.point,
    value: f(result.point),
    iterations: result.iterations,
    converged: result.converged,
  }
}

///|
pub fn derivative_central(
  f : (Double) -> Double,
  x : Double,
  step : Double,
) -> Double {
  let h = if step == 0.0 { 1.0e-6 } else { step.abs() }
  (f(x + h) - f(x - h)) / (2.0 * h)
}

///|
pub fn derivative_forward(
  f : (Double) -> Double,
  x : Double,
  step : Double,
) -> Double {
  let h = if step == 0.0 { 1.0e-6 } else { step.abs() }
  (f(x + h) - f(x)) / h
}

///|
pub fn derivative_backward(
  f : (Double) -> Double,
  x : Double,
  step : Double,
) -> Double {
  let h = if step == 0.0 { 1.0e-6 } else { step.abs() }
  (f(x) - f(x - h)) / h
}

///|
pub fn second_derivative(
  f : (Double) -> Double,
  x : Double,
  step : Double,
) -> Double {
  let h = if step == 0.0 { 1.0e-5 } else { step.abs() }
  (f(x + h) - 2.0 * f(x) + f(x - h)) / (h * h)
}

///|
pub fn newton_extremum(
  f : (Double) -> Double,
  initial : Double,
  step : Double,
  tolerance : Double,
  max_iterations : Int,
) -> ExtremumResult {
  let mut x = initial
  let mut iterations = 0
  let mut converged = false
  let h = if step == 0.0 { 1.0e-5 } else { step.abs() }
  for i in 0..<max_iterations {
    iterations = i + 1
    let first = derivative_central(f, x, h)
    let second = second_derivative(f, x, h)
    if second.abs() <= 1.0e-30 {
      break
    }
    let next = x - first / second
    if (next - x).abs() <= tolerance.abs() {
      x = next
      converged = true
      break
    }
    x = next
  }
  { point: x, value: f(x), iterations, converged }
}

///|
pub fn integrate_midpoint(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  slices : Int,
) -> Double {
  let count = if slices < 1 { 1 } else { slices }
  let width = (upper - lower) / count.to_double()
  let mut total = 0.0
  for i in 0..<count {
    total = total + f(lower + (i.to_double() + 0.5) * width) * width
  }
  total
}

///|
pub fn integrate_simpson(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  slices : Int,
) -> Double {
  let count0 = if slices < 2 { 2 } else { slices }
  let count = if count0 % 2 == 0 { count0 } else { count0 + 1 }
  let width = (upper - lower) / count.to_double()
  let mut total = f(lower) + f(upper)
  for i in 1..<count {
    let coefficient = if i % 2 == 0 { 2.0 } else { 4.0 }
    total = total + coefficient * f(lower + i.to_double() * width)
  }
  total * width / 3.0
}

///|
pub fn integrate_adaptive(
  f : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  depth : Int,
) -> Double {
  let whole = integrate_simpson(f, lower, upper, 2)
  fn recurse(
    f : (Double) -> Double,
    lo : Double,
    hi : Double,
    eps : Double,
    estimate : Double,
    level : Int,
  ) -> Double {
    let mid = 0.5 * (lo + hi)
    let left = integrate_simpson(f, lo, mid, 2)
    let right = integrate_simpson(f, mid, hi, 2)
    let combined = left + right
    if level <= 0 || (combined - estimate).abs() <= 15.0 * eps {
      combined + (combined - estimate) / 15.0
    } else {
      recurse(f, lo, mid, eps / 2.0, left, level - 1) +
      recurse(f, mid, hi, eps / 2.0, right, level - 1)
    }
  }
  recurse(
    f,
    lower,
    upper,
    if tolerance <= 0.0 {
      1.0e-8
    } else {
      tolerance
    },
    whole,
    if depth < 1 {
      1
    } else {
      depth
    },
  )
}

///|
pub fn interpolate_root(
  x0 : Double,
  y0 : Double,
  x1 : Double,
  y1 : Double,
  target : Double,
) -> Double {
  let denominator = y1 - y0
  if denominator == 0.0 {
    0.5 * (x0 + x1)
  } else {
    x0 + (target - y0) * (x1 - x0) / denominator
  }
}

///|
pub fn normalize_root_interval(lower : Double, upper : Double) -> Array[Double] {
  if lower <= upper {
    [lower, upper]
  } else {
    [upper, lower]
  }
}

///|
pub fn root_distance(left : RootResult, right : RootResult) -> Double {
  (left.root - right.root).abs()
}

///|
pub fn root_error_bound(result : RootResult, derivative : Double) -> Double {
  if derivative.abs() <= 1.0e-30 {
    1.0e30
  } else {
    result.value.abs() / derivative.abs()
  }
}

///|
pub fn root_scan_sign_changes(scan : Array[RootScanPoint]) -> Int {
  let mut count = 0
  for point in scan {
    if point.sign_change {
      count = count + 1
    }
  }
  count
}

///|
pub fn root_scan_values(scan : Array[RootScanPoint]) -> Array[Double] {
  let result = Array::make(scan.length(), 0.0)
  for i in 0..<scan.length() {
    result[i] = scan[i].value
  }
  result
}

///|
pub fn roots_unique(
  roots : Array[RootResult],
  tolerance : Double,
) -> Array[RootResult] {
  let result : Array[RootResult] = []
  let tol = if tolerance <= 0.0 { 1.0e-8 } else { tolerance }
  for root in roots {
    let mut seen = false
    for existing in result {
      if (existing.root - root.root).abs() <= tol {
        seen = true
      }
    }
    if !seen {
      result.push(root)
    }
  }
  result
}

///|
pub fn root_result_at(f : (Double) -> Double, x : Double) -> RootResult {
  { root: x, value: f(x), iterations: 0, converged: false, bracketed: false }
}

///|
pub fn solve_linear_threshold(
  slope : Double,
  intercept : Double,
  target : Double,
) -> RootResult {
  if slope == 0.0 {
    {
      root: 0.0,
      value: intercept - target,
      iterations: 0,
      converged: intercept == target,
      bracketed: false,
    }
  } else {
    let x = (target - intercept) / slope
    { root: x, value: 0.0, iterations: 1, converged: true, bracketed: false }
  }
}

///|
pub fn root_quality(result : RootResult, scale : Double) -> Double {
  let denominator = if scale.abs() < 1.0 { 1.0 } else { scale.abs() }
  1.0 / (1.0 + result.value.abs() / denominator)
}

///|
pub fn extremum_is_minimum(
  f : (Double) -> Double,
  point : Double,
  step : Double,
) -> Bool {
  let h = if step == 0.0 { 1.0e-5 } else { step.abs() }
  f(point) <= f(point - h) && f(point) <= f(point + h)
}

///|
pub fn extremum_is_maximum(
  f : (Double) -> Double,
  point : Double,
  step : Double,
) -> Bool {
  let h = if step == 0.0 { 1.0e-5 } else { step.abs() }
  f(point) >= f(point - h) && f(point) >= f(point + h)
}

///|
pub fn local_minimum(
  f : (Double) -> Double,
  center : Double,
  radius : Double,
  samples : Int,
) -> ExtremumResult {
  let lower = center - radius.abs()
  let upper = center + radius.abs()
  let count = if samples < 3 { 3 } else { samples }
  let xs = linspace(lower, upper, count)
  let mut index = 0
  let mut value = f(xs[0])
  for i in 1..<xs.length() {
    let candidate = f(xs[i])
    if candidate < value {
      index = i
      value = candidate
    }
  }
  { point: xs[index], value, iterations: count, converged: true }
}

///|
pub fn local_maximum(
  f : (Double) -> Double,
  center : Double,
  radius : Double,
  samples : Int,
) -> ExtremumResult {
  let lower = center - radius.abs()
  let upper = center + radius.abs()
  let count = if samples < 3 { 3 } else { samples }
  let xs = linspace(lower, upper, count)
  let mut index = 0
  let mut value = f(xs[0])
  for i in 1..<xs.length() {
    let candidate = f(xs[i])
    if candidate > value {
      index = i
      value = candidate
    }
  }
  { point: xs[index], value, iterations: count, converged: true }
}
