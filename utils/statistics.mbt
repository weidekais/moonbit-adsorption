///|
/// Descriptive statistics used by adsorption experiments and simulations.
pub(all) struct Summary {
  count : Int
  minimum : Double
  maximum : Double
  mean : Double
  variance : Double
  standard_deviation : Double
  sum : Double
} derive(Debug, Eq)

///|
/// Returns a stable summary. Empty input is represented by zero values.
pub fn summarize(values : Array[Double]) -> Summary {
  if values.length() == 0 {
    return {
      count: 0,
      minimum: 0.0,
      maximum: 0.0,
      mean: 0.0,
      variance: 0.0,
      standard_deviation: 0.0,
      sum: 0.0,
    }
  }
  let mut sum = 0.0
  let mut minimum = values[0]
  let mut maximum = values[0]
  for value in values {
    sum = sum + value
    if value < minimum {
      minimum = value
    }
    if value > maximum {
      maximum = value
    }
  }
  let mean = sum / values.length().to_double()
  let mut squared = 0.0
  for value in values {
    let delta = value - mean
    squared = squared + delta * delta
  }
  let variance = squared / values.length().to_double()
  {
    count: values.length(),
    minimum,
    maximum,
    mean,
    variance,
    standard_deviation: variance.sqrt(),
    sum,
  }
}

///|
pub fn mean(values : Array[Double]) -> Double {
  summarize(values).mean
}

///|
pub fn variance(values : Array[Double]) -> Double {
  summarize(values).variance
}

///|
pub fn standard_deviation(values : Array[Double]) -> Double {
  summarize(values).standard_deviation
}

///|
pub fn covariance(xs : Array[Double], ys : Array[Double]) -> Double {
  if xs.length() == 0 || xs.length() != ys.length() {
    return 0.0
  }
  let mx = mean(xs)
  let my = mean(ys)
  let mut total = 0.0
  for i in 0..<xs.length() {
    total = total + (xs[i] - mx) * (ys[i] - my)
  }
  total / xs.length().to_double()
}

///|
pub fn correlation(xs : Array[Double], ys : Array[Double]) -> Double {
  let sx = standard_deviation(xs)
  let sy = standard_deviation(ys)
  if sx == 0.0 || sy == 0.0 {
    0.0
  } else {
    covariance(xs, ys) / (sx * sy)
  }
}

///|
pub fn mae(actual : Array[Double], predicted : Array[Double]) -> Double {
  if actual.length() == 0 || actual.length() != predicted.length() {
    return 0.0
  }
  let mut total = 0.0
  for i in 0..<actual.length() {
    total = total + (actual[i] - predicted[i]).abs()
  }
  total / actual.length().to_double()
}

///|
pub fn mse(actual : Array[Double], predicted : Array[Double]) -> Double {
  if actual.length() == 0 || actual.length() != predicted.length() {
    return 0.0
  }
  let mut total = 0.0
  for i in 0..<actual.length() {
    let delta = actual[i] - predicted[i]
    total = total + delta * delta
  }
  total / actual.length().to_double()
}

///|
pub fn rmse(actual : Array[Double], predicted : Array[Double]) -> Double {
  mse(actual, predicted).sqrt()
}

///|
pub fn r_squared(actual : Array[Double], predicted : Array[Double]) -> Double {
  if actual.length() == 0 || actual.length() != predicted.length() {
    return 0.0
  }
  let average = mean(actual)
  let mut total = 0.0
  let mut residual = 0.0
  for i in 0..<actual.length() {
    let d = actual[i] - average
    total = total + d * d
    let e = actual[i] - predicted[i]
    residual = residual + e * e
  }
  if total == 0.0 {
    1.0
  } else {
    1.0 - residual / total
  }
}

///|
pub fn relative_error(actual : Double, predicted : Double) -> Double {
  if actual == 0.0 {
    if predicted == 0.0 {
      0.0
    } else {
      1.0e30
    }
  } else {
    (predicted - actual).abs() / actual.abs()
  }
}

///|
pub fn weighted_rmse(
  actual : Array[Double],
  predicted : Array[Double],
  weights : Array[Double],
) -> Double {
  if actual.length() == 0 ||
    actual.length() != predicted.length() ||
    actual.length() != weights.length() {
    return 0.0
  }
  let mut numerator = 0.0
  let mut denominator = 0.0
  for i in 0..<actual.length() {
    let delta = actual[i] - predicted[i]
    let weight = if weights[i] < 0.0 { 0.0 } else { weights[i] }
    numerator = numerator + weight * delta * delta
    denominator = denominator + weight
  }
  if denominator == 0.0 {
    0.0
  } else {
    (numerator / denominator).sqrt()
  }
}

///|
pub fn clamp(value : Double, lower : Double, upper : Double) -> Double {
  if lower > upper {
    return clamp(value, upper, lower)
  }
  if value < lower {
    lower
  } else if value > upper {
    upper
  } else {
    value
  }
}

///|
pub fn linspace(start : Double, stop : Double, count : Int) -> Array[Double] {
  if count <= 0 {
    return []
  }
  if count == 1 {
    return [start]
  }
  let values = Array::make(count, 0.0)
  let step = (stop - start) / (count - 1).to_double()
  for i in 0..<count {
    values[i] = start + i.to_double() * step
  }
  values
}

///|
pub fn cumulative_trapezoid(
  xs : Array[Double],
  ys : Array[Double],
) -> Array[Double] {
  if xs.length() != ys.length() || xs.length() == 0 {
    return []
  }
  let result = Array::make(xs.length(), 0.0)
  for i in 1..<xs.length() {
    result[i] = result[i - 1] + 0.5 * (xs[i] - xs[i - 1]) * (ys[i] + ys[i - 1])
  }
  result
}

///|
pub fn moving_average(values : Array[Double], window : Int) -> Array[Double] {
  if window <= 0 || values.length() == 0 {
    return []
  }
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    let first = if i + 1 < window { 0 } else { i + 1 - window }
    let mut total = 0.0
    for j in first..<(i + 1) {
      total = total + values[j]
    }
    result[i] = total / (i + 1 - first).to_double()
  }
  result
}

///|
pub fn percentile(values : Array[Double], probability : Double) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let sorted = values.copy()
  for i in 1..<sorted.length() {
    let mut j = i
    while j > 0 && sorted[j] < sorted[j - 1] {
      let temp = sorted[j]
      sorted[j] = sorted[j - 1]
      sorted[j - 1] = temp
      j = j - 1
    }
  }
  let p = clamp(probability, 0.0, 1.0) * (sorted.length() - 1).to_double()
  let lower = p.to_int()
  let upper = if lower + 1 < sorted.length() { lower + 1 } else { lower }
  sorted[lower] + (sorted[upper] - sorted[lower]) * (p - lower.to_double())
}

///|
pub fn residuals(
  actual : Array[Double],
  predicted : Array[Double],
) -> Array[Double] {
  if actual.length() != predicted.length() {
    return []
  }
  let result = Array::make(actual.length(), 0.0)
  for i in 0..<actual.length() {
    result[i] = actual[i] - predicted[i]
  }
  result
}

///|
pub fn normalized(values : Array[Double]) -> Array[Double] {
  if values.length() == 0 {
    return []
  }
  let summary = summarize(values)
  let span = summary.maximum - summary.minimum
  if span == 0.0 {
    return Array::make(values.length(), 0.0)
  }
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    result[i] = (values[i] - summary.minimum) / span
  }
  result
}
