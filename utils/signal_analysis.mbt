///|
/// Signal processing and breakthrough-curve diagnostics for laboratory and pilot data.
pub struct SignalPeak {
  index : Int
  time : Double
  value : Double
  prominence : Double
  width : Double
  rising : Bool
}

///|
pub struct BaselineModel {
  coefficients : Array[Double]
  lower_fraction : Double
  upper_fraction : Double
}

///|
pub struct ResponseMetrics {
  t10 : Double
  t50 : Double
  t90 : Double
  t_breakthrough : Double
  area : Double
  capacity : Double
  removal : Double
  tail_slope : Double
}

///|
pub struct SignalWindow {
  start : Int
  end : Int
  mean : Double
  standard_deviation : Double
  slope : Double
}

///|
pub fn signal_mean(values : Array[Double]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let mut total = 0.0
  for value in values {
    total = total + value
  }
  total / values.length().to_double()
}

///|
pub fn signal_variance(values : Array[Double]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let mean = signal_mean(values)
  let mut total = 0.0
  for value in values {
    total = total + (value - mean) * (value - mean)
  }
  total / values.length().to_double()
}

///|
pub fn signal_standard_deviation(values : Array[Double]) -> Double {
  signal_variance(values).sqrt()
}

///|
pub fn signal_median(values : Array[Double]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let sorted = values.copy()
  for i in 1..<sorted.length() {
    let current = sorted[i]
    let mut j = i
    while j > 0 && sorted[j - 1] > current {
      sorted[j] = sorted[j - 1]
      j = j - 1
    }
    sorted[j] = current
  }
  if sorted.length() % 2 == 1 {
    sorted[sorted.length() / 2]
  } else {
    0.5 * (sorted[sorted.length() / 2 - 1] + sorted[sorted.length() / 2])
  }
}

///|
pub fn signal_quantile(values : Array[Double], probability : Double) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let sorted = values.copy()
  for i in 1..<sorted.length() {
    let current = sorted[i]
    let mut j = i
    while j > 0 && sorted[j - 1] > current {
      sorted[j] = sorted[j - 1]
      j = j - 1
    }
    sorted[j] = current
  }
  let p = clamp(probability, 0.0, 1.0)
  let position = p * (sorted.length() - 1).to_double()
  let lower = position.to_int()
  let upper = if lower + 1 < sorted.length() { lower + 1 } else { lower }
  sorted[lower] +
  (position - lower.to_double()) * (sorted[upper] - sorted[lower])
}

///|
pub fn signal_mad(values : Array[Double]) -> Double {
  let center = signal_median(values)
  let deviations = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    deviations[i] = (values[i] - center).abs()
  }
  signal_median(deviations)
}

///|
pub fn signal_clamp(
  values : Array[Double],
  lower : Double,
  upper : Double,
) -> Array[Double] {
  let result = values.copy()
  let low = if lower <= upper { lower } else { upper }
  let high = if upper >= lower { upper } else { lower }
  for i in 0..<result.length() {
    result[i] = clamp(result[i], low, high)
  }
  result
}

///|
pub fn signal_detrend(
  values : Array[Double],
  times : Array[Double],
) -> Array[Double] {
  if values.length() != times.length() || values.length() < 2 {
    return values.copy()
  }
  let points : Array[Point] = []
  for i in 0..<values.length() {
    points.push({ x: times[i], y: values[i] })
  }
  let fit = linear_regression(points)
  let result = values.copy()
  for i in 0..<result.length() {
    result[i] = result[i] - fit.intercept - fit.slope * times[i]
  }
  result
}

///|
pub fn signal_difference(
  values : Array[Double],
  times : Array[Double],
) -> Array[Double] {
  if values.length() < 2 || values.length() != times.length() {
    return []
  }
  let result = Array::make(values.length(), 0.0)
  result[0] = if times[1] == times[0] {
    0.0
  } else {
    (values[1] - values[0]) / (times[1] - times[0])
  }
  for i in 1..<(values.length() - 1) {
    let width = times[i + 1] - times[i - 1]
    result[i] = if width == 0.0 {
      0.0
    } else {
      (values[i + 1] - values[i - 1]) / width
    }
  }
  let last = values.length() - 1
  result[last] = if times[last] == times[last - 1] {
    0.0
  } else {
    (values[last] - values[last - 1]) / (times[last] - times[last - 1])
  }
  result
}

///|
pub fn signal_second_difference(
  values : Array[Double],
  times : Array[Double],
) -> Array[Double] {
  signal_difference(signal_difference(values, times), times)
}

///|
pub fn signal_smooth_boxcar(
  values : Array[Double],
  window : Int,
) -> Array[Double] {
  process_moving_average(values, window)
}

///|
pub fn signal_smooth_exponential(
  values : Array[Double],
  alpha : Double,
) -> Array[Double] {
  exponential_smoothing(values, clamp(alpha, 0.0, 1.0))
}

///|
pub fn signal_smooth_median(
  values : Array[Double],
  window : Int,
) -> Array[Double] {
  if window <= 1 {
    return values.copy()
  }
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    let lower = if i + 1 > window { i + 1 - window } else { 0 }
    let slice : Array[Double] = []
    for j in lower..<(i + 1) {
      slice.push(values[j])
    }
    result[i] = signal_median(slice)
  }
  result
}

///|
pub fn signal_smooth_savgol(
  values : Array[Double],
  window : Int,
) -> Array[Double] {
  if window < 3 {
    return values.copy()
  }
  let radius = window / 2
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    let lower = if i > radius { i - radius } else { 0 }
    let upper = if i + radius + 1 < values.length() {
      i + radius + 1
    } else {
      values.length()
    }
    let xs : Array[Double] = []
    let ys : Array[Double] = []
    for j in lower..<upper {
      xs.push((j - i).to_double())
      ys.push(values[j])
    }
    let points : Array[Point] = []
    for j in 0..<xs.length() {
      points.push({ x: xs[j], y: ys[j] })
    }
    let fit = linear_regression(points)
    result[i] = fit.intercept
  }
  result
}

///|
pub fn signal_baseline_linear(
  times : Array[Double],
  values : Array[Double],
  lower_fraction : Double,
  upper_fraction : Double,
) -> BaselineModel {
  if times.length() != values.length() || times.length() < 2 {
    return { coefficients: [0.0], lower_fraction, upper_fraction }
  }
  let low = clamp(lower_fraction, 0.0, 1.0)
  let high = clamp(upper_fraction, 0.0, 1.0)
  let count = times.length()
  let first_count = (count.to_double() * low).to_int() + 1
  let last_count = (count.to_double() * (1.0 - high)).to_int() + 1
  let points : Array[Point] = []
  for i in 0..<first_count {
    points.push({ x: times[i], y: values[i] })
  }
  let start = if count - last_count < 0 { 0 } else { count - last_count }
  for i in start..<count {
    points.push({ x: times[i], y: values[i] })
  }
  let fit = linear_regression(points)
  {
    coefficients: [fit.intercept, fit.slope],
    lower_fraction: low,
    upper_fraction: high,
  }
}

///|
pub fn signal_baseline_value(model : BaselineModel, time : Double) -> Double {
  polynomial_value(model.coefficients, time)
}

///|
pub fn signal_remove_baseline(
  times : Array[Double],
  values : Array[Double],
  model : BaselineModel,
) -> Array[Double] {
  let result = values.copy()
  let size = if times.length() < values.length() {
    times.length()
  } else {
    values.length()
  }
  for i in 0..<size {
    result[i] = values[i] - signal_baseline_value(model, times[i])
  }
  result
}

///|
pub fn signal_peak_prominence(
  values : Array[Double],
  index : Int,
  radius : Int,
) -> Double {
  if index < 0 || index >= values.length() {
    return 0.0
  }
  let span = if radius <= 0 { 1 } else { radius }
  let left = if index > span { index - span } else { 0 }
  let right = if index + span + 1 < values.length() {
    index + span + 1
  } else {
    values.length()
  }
  let mut left_min = values[index]
  let mut right_min = values[index]
  for i in left..<index {
    if values[i] < left_min {
      left_min = values[i]
    }
  }
  for i in (index + 1)..<right {
    if values[i] < right_min {
      right_min = values[i]
    }
  }
  values[index] - (if left_min > right_min { left_min } else { right_min })
}

///|
pub fn signal_peak_width(
  values : Array[Double],
  index : Int,
  fraction : Double,
) -> Double {
  if index < 0 || index >= values.length() {
    return 0.0
  }
  let baseline = if values[index] >= 0.0 {
    values[index] * clamp(fraction, 0.0, 1.0)
  } else {
    values[index]
  }
  let mut left = index
  let mut right = index
  while left > 0 && values[left] > baseline {
    left = left - 1
  }
  while right + 1 < values.length() && values[right] > baseline {
    right = right + 1
  }
  (right - left).to_double()
}

///|
pub fn signal_find_peaks(
  times : Array[Double],
  values : Array[Double],
  minimum_prominence : Double,
  minimum_distance : Int,
) -> Array[SignalPeak] {
  if times.length() != values.length() || values.length() < 3 {
    return []
  }
  let distance = if minimum_distance < 1 { 1 } else { minimum_distance }
  let prominence_limit = if minimum_prominence < 0.0 {
    0.0
  } else {
    minimum_prominence
  }
  let result : Array[SignalPeak] = []
  for i in 1..<(values.length() - 1) {
    if values[i] >= values[i - 1] && values[i] >= values[i + 1] {
      let prominence = signal_peak_prominence(values, i, distance)
      if prominence >= prominence_limit {
        let mut accepted = true
        for peak in result {
          if (peak.index - i).abs() < distance && peak.value >= values[i] {
            accepted = false
          }
        }
        if accepted {
          result.push({
            index: i,
            time: times[i],
            value: values[i],
            prominence,
            width: signal_peak_width(values, i, 0.5),
            rising: true,
          })
        }
      }
    }
  }
  result
}

///|
pub fn signal_find_valleys(
  times : Array[Double],
  values : Array[Double],
  minimum_prominence : Double,
  minimum_distance : Int,
) -> Array[SignalPeak] {
  let inverted = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    inverted[i] = -values[i]
  }
  let peaks = signal_find_peaks(
    times, inverted, minimum_prominence, minimum_distance,
  )
  let result : Array[SignalPeak] = []
  for peak in peaks {
    result.push({
      index: peak.index,
      time: peak.time,
      value: -peak.value,
      prominence: -peak.prominence,
      width: peak.width,
      rising: false,
    })
  }
  result
}

///|
pub fn signal_peak_area(
  times : Array[Double],
  values : Array[Double],
  peak : SignalPeak,
) -> Double {
  let half_width = peak.width / 2.0
  let left = if peak.index.to_double() - half_width < 0.0 {
    0
  } else {
    (peak.index.to_double() - half_width).to_int()
  }
  let right = if peak.index.to_double() + half_width + 1.0 >
    values.length().to_double() {
    values.length()
  } else {
    (peak.index.to_double() + half_width + 1.0).to_int()
  }
  if right - left < 2 {
    0.0
  } else {
    let local_times : Array[Double] = []
    let local_values : Array[Double] = []
    for i in left..<right {
      local_times.push(times[i])
      local_values.push(values[i])
    }
    interpolation_integral(local_times, local_values)
  }
}

///|
pub fn signal_windows(
  times : Array[Double],
  values : Array[Double],
  window : Int,
) -> Array[SignalWindow] {
  if values.length() != times.length() || window <= 0 {
    return []
  }
  let result : Array[SignalWindow] = []
  let mut start = 0
  while start < values.length() {
    let finish = if start + window < values.length() {
      start + window
    } else {
      values.length()
    }
    let slice : Array[Double] = []
    for i in start..<finish {
      slice.push(values[i])
    }
    let points : Array[Point] = []
    for i in start..<finish {
      points.push({ x: times[i], y: values[i] })
    }
    let fit = linear_regression(points)
    result.push({
      start,
      end: finish - 1,
      mean: signal_mean(slice),
      standard_deviation: signal_standard_deviation(slice),
      slope: fit.slope,
    })
    start = finish
  }
  result
}

///|
pub fn signal_crossing_time(
  times : Array[Double],
  values : Array[Double],
  level : Double,
) -> Double {
  let locations = crossing_locations(times, values, level)
  if locations.length() == 0 {
    0.0
  } else {
    locations[0]
  }
}

///|
pub fn signal_response_time(
  times : Array[Double],
  normalized : Array[Double],
  probability : Double,
) -> Double {
  signal_crossing_time(times, normalized, clamp(probability, 0.0, 1.0))
}

///|
pub fn signal_normalize_response(
  values : Array[Double],
  initial : Double,
  final_value : Double,
) -> Array[Double] {
  let result = Array::make(values.length(), 0.0)
  let span = final_value - initial
  for i in 0..<values.length() {
    result[i] = if span == 0.0 { 0.0 } else { (values[i] - initial) / span }
  }
  result
}

///|
pub fn signal_breakthrough_metrics(
  times : Array[Double],
  concentration : Array[Double],
  influent : Double,
  flow_rate : Double,
  bed_mass : Double,
  breakthrough_fraction : Double,
) -> ResponseMetrics {
  let normalized = signal_normalize_response(concentration, 0.0, influent)
  let t10 = signal_response_time(times, normalized, 0.1)
  let t50 = signal_response_time(times, normalized, 0.5)
  let t90 = signal_response_time(times, normalized, 0.9)
  let threshold = influent * breakthrough_fraction
  let t_breakthrough = signal_crossing_time(times, concentration, threshold)
  let area = interpolation_integral(times, concentration)
  let volume = if times.length() < 2 {
    0.0
  } else {
    flow_rate * (times[times.length() - 1] - times[0])
  }
  let removed = influent * volume - area * flow_rate
  {
    t10,
    t50,
    t90,
    t_breakthrough,
    area,
    capacity: if bed_mass == 0.0 {
      0.0
    } else {
      removed / bed_mass
    },
    removal: if influent * volume == 0.0 {
      0.0
    } else {
      removed / (influent * volume)
    },
    tail_slope: if concentration.length() < 2 {
      0.0
    } else {
      (
        concentration[concentration.length() - 1] -
        concentration[concentration.length() - 2]
      ) /
      (times[times.length() - 1] - times[times.length() - 2])
    },
  }
}

///|
pub fn signal_response_area(
  times : Array[Double],
  normalized : Array[Double],
  lower : Double,
  upper : Double,
) -> Double {
  let clipped = signal_clamp(normalized, lower, upper)
  interpolation_integral(times, clipped)
}

///|
pub fn signal_residence_time(
  times : Array[Double],
  response : Array[Double],
) -> Double {
  let total = interpolation_integral(times, response)
  let weighted = if times.length() < 2 || times.length() != response.length() {
    0.0
  } else {
    let products = Array::make(times.length(), 0.0)
    for i in 0..<times.length() {
      products[i] = times[i] * response[i]
    }
    interpolation_integral(times, products)
  }
  if total == 0.0 {
    0.0
  } else {
    weighted / total
  }
}

///|
pub fn signal_mass_balance_error(
  times : Array[Double],
  influent : Array[Double],
  effluent : Array[Double],
  flow_rate : Double,
) -> Double {
  let input = interpolation_integral(times, influent) * flow_rate
  let output = interpolation_integral(times, effluent) * flow_rate
  if input.abs() <= 1.0e-30 {
    output.abs()
  } else {
    (input - output).abs() / input.abs()
  }
}

///|
pub fn signal_align_by_crossing(
  times : Array[Double],
  values : Array[Double],
  level : Double,
) -> Array[Double] {
  let crossing = signal_crossing_time(times, values, level)
  let result = times.copy()
  for i in 0..<result.length() {
    result[i] = result[i] - crossing
  }
  result
}

///|
pub fn signal_resample(
  times : Array[Double],
  values : Array[Double],
  grid : Array[Double],
  monotone : Bool,
) -> Array[Double] {
  if monotone {
    resample_monotone(times, values, grid)
  } else {
    resample_linear(times, values, grid)
  }
}

///|
pub fn signal_noise_level(values : Array[Double]) -> Double {
  if values.length() < 3 {
    return signal_standard_deviation(values)
  }
  let differences = Array::make(values.length() - 1, 0.0)
  for i in 1..<values.length() {
    differences[i - 1] = values[i] - values[i - 1]
  }
  signal_mad(differences) / 0.67448975 / 2.0.sqrt()
}

///|
pub fn signal_snr(signal : Array[Double], noise : Array[Double]) -> Double {
  let noise_level = signal_standard_deviation(noise)
  if noise_level <= 1.0e-30 {
    1.0e30
  } else {
    signal_standard_deviation(signal) / noise_level
  }
}

///|
pub fn signal_quality_score(
  times : Array[Double],
  values : Array[Double],
) -> Double {
  if times.length() != values.length() || values.length() < 2 {
    return 0.0
  }
  let mut score = 1.0
  for i in 1..<times.length() {
    if times[i] <= times[i - 1] {
      score = score - 0.2
    }
  }
  if signal_noise_level(values) > signal_standard_deviation(values) {
    score = score - 0.2
  }
  clamp(score, 0.0, 1.0)
}
