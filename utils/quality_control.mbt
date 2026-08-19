///|
/// Statistical quality control for repeated adsorption experiments and production signals.
pub struct ControlLimits {
  center : Double
  upper : Double
  lower : Double
  warning_upper : Double
  warning_lower : Double
}

///|
pub struct ControlDecision {
  index : Int
  value : Double
  score : Double
  code : Int
  accepted : Bool
}

///|
pub struct RepeatabilitySummary {
  groups : Int
  observations : Int
  grand_mean : Double
  within_standard_deviation : Double
  between_standard_deviation : Double
  repeatability : Double
  reproducibility : Double
}

///|
pub struct CapabilitySummary {
  mean : Double
  standard_deviation : Double
  lower_specification : Double
  upper_specification : Double
  cp : Double
  cpk : Double
  pass_fraction : Double
}

///|
pub struct DriftReport {
  slope : Double
  intercept : Double
  r_squared : Double
  drift_per_unit : Double
  flagged : Bool
}

///|
pub fn control_limits(
  values : Array[Double],
  sigma_multiplier : Double,
) -> ControlLimits {
  let center = signal_mean(values)
  let deviation = signal_standard_deviation(values)
  let multiplier = if sigma_multiplier <= 0.0 { 3.0 } else { sigma_multiplier }
  {
    center,
    upper: center + multiplier * deviation,
    lower: center - multiplier * deviation,
    warning_upper: center + 2.0 / 3.0 * multiplier * deviation,
    warning_lower: center - 2.0 / 3.0 * multiplier * deviation,
  }
}

///|
pub fn control_decisions(
  values : Array[Double],
  limits : ControlLimits,
) -> Array[ControlDecision] {
  let result : Array[ControlDecision] = []
  let scale = (limits.upper - limits.center).abs()
  for i in 0..<values.length() {
    let score = if scale <= 1.0e-30 {
      0.0
    } else {
      (values[i] - limits.center) / scale
    }
    let code = if values[i] > limits.upper || values[i] < limits.lower {
      2
    } else if values[i] > limits.warning_upper ||
      values[i] < limits.warning_lower {
      1
    } else {
      0
    }
    result.push({ index: i, value: values[i], score, code, accepted: code < 2 })
  }
  result
}

///|
pub fn control_out_of_limits(
  values : Array[Double],
  limits : ControlLimits,
) -> Array[ControlDecision] {
  let decisions = control_decisions(values, limits)
  let result : Array[ControlDecision] = []
  for decision in decisions {
    if !decision.accepted {
      result.push(decision)
    }
  }
  result
}

///|
pub fn control_warning_count(
  values : Array[Double],
  limits : ControlLimits,
) -> Int {
  let mut count = 0
  for decision in control_decisions(values, limits) {
    if decision.code == 1 {
      count = count + 1
    }
  }
  count
}

///|
pub fn control_acceptance_fraction(
  values : Array[Double],
  limits : ControlLimits,
) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let mut accepted = 0
  for decision in control_decisions(values, limits) {
    if decision.accepted {
      accepted = accepted + 1
    }
  }
  accepted.to_double() / values.length().to_double()
}

///|
pub fn robust_control_limits(
  values : Array[Double],
  sigma_multiplier : Double,
) -> ControlLimits {
  let center = signal_median(values)
  let deviation = signal_mad(values) / 0.67448975
  let multiplier = if sigma_multiplier <= 0.0 { 3.0 } else { sigma_multiplier }
  {
    center,
    upper: center + multiplier * deviation,
    lower: center - multiplier * deviation,
    warning_upper: center + 2.0 / 3.0 * multiplier * deviation,
    warning_lower: center - 2.0 / 3.0 * multiplier * deviation,
  }
}

///|
pub fn robust_filter(
  values : Array[Double],
  threshold : Double,
) -> Array[Double] {
  let limits = robust_control_limits(values, threshold)
  let result : Array[Double] = []
  for value in values {
    if value >= limits.lower && value <= limits.upper {
      result.push(value)
    }
  }
  result
}

///|
pub fn robust_replace_outliers(
  values : Array[Double],
  threshold : Double,
) -> Array[Double] {
  let limits = robust_control_limits(values, threshold)
  let result = values.copy()
  for i in 0..<result.length() {
    if result[i] < limits.lower || result[i] > limits.upper {
      result[i] = limits.center
    }
  }
  result
}

///|
pub fn winsorize(
  values : Array[Double],
  lower_probability : Double,
  upper_probability : Double,
) -> Array[Double] {
  let low = signal_quantile(values, lower_probability)
  let high = signal_quantile(values, upper_probability)
  signal_clamp(values, low, high)
}

///|
pub fn trimmed_mean(values : Array[Double], trim_fraction : Double) -> Double {
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
  let fraction = clamp(trim_fraction, 0.0, 0.49)
  let trim = (sorted.length().to_double() * fraction).to_int()
  let lower = trim
  let upper = sorted.length() - trim
  if lower >= upper {
    return signal_mean(values)
  }
  let mut total = 0.0
  for i in lower..<upper {
    total = total + sorted[i]
  }
  total / (upper - lower).to_double()
}

///|
pub fn median_absolute_score(values : Array[Double]) -> Array[Double] {
  let center = signal_median(values)
  let scale = signal_mad(values)
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    result[i] = if scale <= 1.0e-30 {
      0.0
    } else {
      (values[i] - center).abs() / scale
    }
  }
  result
}

///|
pub fn grubbs_scores(values : Array[Double]) -> Array[Double] {
  let center = signal_mean(values)
  let scale = signal_standard_deviation(values)
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    result[i] = if scale <= 1.0e-30 {
      0.0
    } else {
      (values[i] - center).abs() / scale
    }
  }
  result
}

///|
pub fn run_length_above(values : Array[Double], level : Double) -> Array[Int] {
  let result : Array[Int] = []
  let mut current = 0
  for value in values {
    if value > level {
      current = current + 1
    } else {
      if current > 0 {
        result.push(current)
      }
      current = 0
    }
  }
  if current > 0 {
    result.push(current)
  }
  result
}

///|
pub fn run_length_below(values : Array[Double], level : Double) -> Array[Int] {
  let inverted = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    inverted[i] = -values[i]
  }
  let runs = run_length_above(inverted, -level)
  runs
}

///|
pub fn trend_rule_violations(values : Array[Double], minimum_run : Int) -> Int {
  if values.length() < 2 {
    return 0
  }
  let run = if minimum_run < 2 { 2 } else { minimum_run }
  let mut violations = 0
  let mut rising = 0
  let mut falling = 0
  for i in 1..<values.length() {
    if values[i] > values[i - 1] {
      rising = rising + 1
      falling = 0
    } else if values[i] < values[i - 1] {
      falling = falling + 1
      rising = 0
    } else {
      rising = 0
      falling = 0
    }
    if rising + 1 >= run || falling + 1 >= run {
      violations = violations + 1
    }
  }
  violations
}

///|
pub fn alternating_rule_violations(
  values : Array[Double],
  minimum_length : Int,
) -> Int {
  if values.length() < 3 {
    return 0
  }
  let length = if minimum_length < 4 { 4 } else { minimum_length }
  let mut direction_changes = 0
  let mut previous = 0
  let mut run = 1
  let mut violations = 0
  for i in 1..<values.length() {
    let direction = if values[i] > values[i - 1] {
      1
    } else if values[i] < values[i - 1] {
      -1
    } else {
      0
    }
    if direction != 0 && previous != 0 && direction != previous {
      direction_changes = direction_changes + 1
      run = run + 1
    } else if direction != 0 {
      run = 1
    }
    if run >= length {
      violations = violations + 1
    }
    previous = direction
  }
  violations + direction_changes / length
}

///|
pub fn repeatability_summary(
  groups : Array[Array[Double]],
) -> RepeatabilitySummary {
  let mut observations = 0
  let mut total = 0.0
  for group in groups {
    observations = observations + group.length()
    total = total + signal_mean(group) * group.length().to_double()
  }
  if observations == 0 {
    return {
      groups: groups.length(),
      observations: 0,
      grand_mean: 0.0,
      within_standard_deviation: 0.0,
      between_standard_deviation: 0.0,
      repeatability: 0.0,
      reproducibility: 0.0,
    }
  }
  let grand = total / observations.to_double()
  let mut within_total = 0.0
  let means : Array[Double] = []
  for group in groups {
    let mean = signal_mean(group)
    means.push(mean)
    for value in group {
      within_total = within_total + (value - mean) * (value - mean)
    }
  }
  let within = if observations <= groups.length() {
    0.0
  } else {
    (within_total / (observations - groups.length()).to_double()).sqrt()
  }
  let between = signal_standard_deviation(means)
  {
    groups: groups.length(),
    observations,
    grand_mean: grand,
    within_standard_deviation: within,
    between_standard_deviation: between,
    repeatability: within,
    reproducibility: (within * within + between * between).sqrt(),
  }
}

///|
pub fn repeatability_confidence(
  summary : RepeatabilitySummary,
  confidence_multiplier : Double,
) -> Double {
  let multiplier = if confidence_multiplier <= 0.0 {
    2.0
  } else {
    confidence_multiplier
  }
  multiplier * summary.reproducibility
}

///|
pub fn capability_summary(
  values : Array[Double],
  lower_specification : Double,
  upper_specification : Double,
) -> CapabilitySummary {
  let mean = signal_mean(values)
  let deviation = signal_standard_deviation(values)
  let width = upper_specification - lower_specification
  let cp = if deviation <= 1.0e-30 { 1.0e30 } else { width / (6.0 * deviation) }
  let cpk = if deviation <= 1.0e-30 {
    1.0e30
  } else {
    let left = (mean - lower_specification) / (3.0 * deviation)
    let right = (upper_specification - mean) / (3.0 * deviation)
    if left < right {
      left
    } else {
      right
    }
  }
  let mut passed = 0
  for value in values {
    if value >= lower_specification && value <= upper_specification {
      passed = passed + 1
    }
  }
  {
    mean,
    standard_deviation: deviation,
    lower_specification,
    upper_specification,
    cp,
    cpk,
    pass_fraction: if values.length() == 0 {
      0.0
    } else {
      passed.to_double() / values.length().to_double()
    },
  }
}

///|
pub fn capability_passes(
  summary : CapabilitySummary,
  minimum_cpk : Double,
) -> Bool {
  let limit = if minimum_cpk <= 0.0 { 1.33 } else { minimum_cpk }
  summary.cpk >= limit
}

///|
pub fn drift_report(
  times : Array[Double],
  values : Array[Double],
  maximum_slope : Double,
) -> DriftReport {
  let points : Array[Point] = []
  let size = if times.length() < values.length() {
    times.length()
  } else {
    values.length()
  }
  for i in 0..<size {
    points.push({ x: times[i], y: values[i] })
  }
  let fit = linear_regression(points)
  let limit = if maximum_slope <= 0.0 { 1.0e-6 } else { maximum_slope }
  let flagged = fit.slope.abs() > limit
  {
    slope: fit.slope,
    intercept: fit.intercept,
    r_squared: fit.r_squared,
    drift_per_unit: fit.slope,
    flagged,
  }
}

///|
pub fn remove_drift(
  times : Array[Double],
  values : Array[Double],
  report : DriftReport,
) -> Array[Double] {
  let result = values.copy()
  let size = if times.length() < result.length() {
    times.length()
  } else {
    result.length()
  }
  for i in 0..<size {
    result[i] = result[i] - report.slope * times[i]
  }
  result
}

///|
pub fn block_means(values : Array[Double], block_size : Int) -> Array[Double] {
  if block_size <= 0 {
    return []
  }
  let result : Array[Double] = []
  let mut start = 0
  while start < values.length() {
    let finish = if start + block_size < values.length() {
      start + block_size
    } else {
      values.length()
    }
    let block : Array[Double] = []
    for i in start..<finish {
      block.push(values[i])
    }
    result.push(signal_mean(block))
    start = finish
  }
  result
}

///|
pub fn block_standard_deviations(
  values : Array[Double],
  block_size : Int,
) -> Array[Double] {
  if block_size <= 0 {
    return []
  }
  let result : Array[Double] = []
  let mut start = 0
  while start < values.length() {
    let finish = if start + block_size < values.length() {
      start + block_size
    } else {
      values.length()
    }
    let block : Array[Double] = []
    for i in start..<finish {
      block.push(values[i])
    }
    result.push(signal_standard_deviation(block))
    start = finish
  }
  result
}

///|
pub fn sequential_difference_test(
  values : Array[Double],
  threshold : Double,
) -> Bool {
  if values.length() < 3 {
    return false
  }
  let difference = Array::make(values.length() - 1, 0.0)
  for i in 1..<values.length() {
    difference[i - 1] = values[i] - values[i - 1]
  }
  let limit = if threshold <= 0.0 { 1.0 } else { threshold }
  signal_standard_deviation(difference) <= limit
}

///|
pub fn batch_consistency_score(
  groups : Array[Array[Double]],
  tolerance : Double,
) -> Double {
  let summary = repeatability_summary(groups)
  let limit = if tolerance <= 0.0 { 0.05 } else { tolerance }
  if summary.grand_mean.abs() <= 1.0e-30 {
    if summary.reproducibility <= limit {
      1.0
    } else {
      0.0
    }
  } else {
    clamp(
      1.0 - summary.reproducibility / summary.grand_mean.abs() / limit,
      0.0,
      1.0,
    )
  }
}

///|
pub fn uncertainty_from_repeats(
  groups : Array[Array[Double]],
  confidence_multiplier : Double,
) -> Double {
  repeatability_confidence(repeatability_summary(groups), confidence_multiplier)
}

///|
pub fn quality_gate(
  values : Array[Double],
  lower_specification : Double,
  upper_specification : Double,
  outlier_threshold : Double,
  minimum_cpk : Double,
) -> Bool {
  let filtered = robust_filter(values, outlier_threshold)
  let capability = capability_summary(
    filtered, lower_specification, upper_specification,
  )
  capability_passes(capability, minimum_cpk) && capability.pass_fraction >= 0.95
}

///|
pub fn control_chart_score(
  values : Array[Double],
  sigma_multiplier : Double,
) -> Double {
  let limits = control_limits(values, sigma_multiplier)
  let acceptance = control_acceptance_fraction(values, limits)
  let trend_penalty = trend_rule_violations(values, 7).to_double() /
    (values.length() + 1).to_double()
  clamp(acceptance - trend_penalty, 0.0, 1.0)
}
