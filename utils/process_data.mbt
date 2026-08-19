///|
/// Process quantities, units, and tabular observations for reproducible experiments.
pub struct Quantity {
  value : Double
  unit : String
  scale : Double
  offset : Double
}

///|
pub struct Dimension {
  mass : Int
  length : Int
  time : Int
  amount : Int
  temperature : Int
}

///|
pub struct Observation {
  time : Double
  value : Double
  weight : Double
  valid : Bool
}

///|
pub struct ObservationTable {
  times : Array[Double]
  values : Array[Double]
  weights : Array[Double]
  valid : Array[Bool]
}

///|
pub struct TableSummary {
  count : Int
  valid_count : Int
  missing_count : Int
  mean : Double
  standard_deviation : Double
  minimum : Double
  maximum : Double
  integral : Double
}

///|
pub struct QualityFlag {
  index : Int
  code : Int
  score : Double
  message : String
}

///|
pub struct QualityReport {
  flags : Array[QualityFlag]
  valid_count : Int
  invalid_count : Int
  outlier_count : Int
  completeness : Double
  weighted_mean : Double
}

///|
pub fn dimensionless() -> Dimension {
  { mass: 0, length: 0, time: 0, amount: 0, temperature: 0 }
}

///|
pub fn mass_dimension() -> Dimension {
  { mass: 1, length: 0, time: 0, amount: 0, temperature: 0 }
}

///|
pub fn length_dimension() -> Dimension {
  { mass: 0, length: 1, time: 0, amount: 0, temperature: 0 }
}

///|
pub fn time_dimension() -> Dimension {
  { mass: 0, length: 0, time: 1, amount: 0, temperature: 0 }
}

///|
pub fn concentration_dimension() -> Dimension {
  { mass: 1, length: -3, time: 0, amount: 0, temperature: 0 }
}

///|
pub fn pressure_dimension() -> Dimension {
  { mass: 1, length: -1, time: -2, amount: 0, temperature: 0 }
}

///|
pub fn quantity(
  value : Double,
  unit : String,
  scale : Double,
  offset : Double,
) -> Quantity {
  { value, unit, scale: if scale == 0.0 { 1.0 } else { scale }, offset }
}

///|
pub fn quantity_dimensionless(value : Double, unit : String) -> Quantity {
  quantity(value, unit, 1.0, 0.0)
}

///|
pub fn quantity_si_value(value : Quantity) -> Double {
  value.value * value.scale + value.offset
}

///|
pub fn quantity_from_si(
  value : Double,
  unit : String,
  scale : Double,
  offset : Double,
) -> Quantity {
  let safe_scale = if scale == 0.0 { 1.0 } else { scale }
  quantity((value - offset) / safe_scale, unit, safe_scale, offset)
}

///|
pub fn quantity_convert(
  value : Quantity,
  scale : Double,
  offset : Double,
  unit : String,
) -> Quantity {
  let si = quantity_si_value(value)
  quantity_from_si(si, unit, scale, offset)
}

///|
pub fn kilograms(value : Double) -> Quantity {
  quantity(value, "kg", 1.0, 0.0)
}

///|
pub fn grams(value : Double) -> Quantity {
  quantity(value, "g", 1.0e-3, 0.0)
}

///|
pub fn milligrams(value : Double) -> Quantity {
  quantity(value, "mg", 1.0e-6, 0.0)
}

///|
pub fn cubic_meters(value : Double) -> Quantity {
  quantity(value, "m3", 1.0, 0.0)
}

///|
pub fn liters(value : Double) -> Quantity {
  quantity(value, "L", 1.0e-3, 0.0)
}

///|
pub fn milliliters(value : Double) -> Quantity {
  quantity(value, "mL", 1.0e-6, 0.0)
}

///|
pub fn seconds(value : Double) -> Quantity {
  quantity(value, "s", 1.0, 0.0)
}

///|
pub fn minutes(value : Double) -> Quantity {
  quantity(value, "min", 60.0, 0.0)
}

///|
pub fn hours(value : Double) -> Quantity {
  quantity(value, "h", 3600.0, 0.0)
}

///|
pub fn pascals(value : Double) -> Quantity {
  quantity(value, "Pa", 1.0, 0.0)
}

///|
pub fn kilopascals(value : Double) -> Quantity {
  quantity(value, "kPa", 1000.0, 0.0)
}

///|
pub fn bar(value : Double) -> Quantity {
  quantity(value, "bar", 100000.0, 0.0)
}

///|
pub fn celsius(value : Double) -> Quantity {
  quantity(value, "degC", 1.0, 273.15)
}

///|
pub fn kelvin(value : Double) -> Quantity {
  quantity(value, "K", 1.0, 0.0)
}

///|
pub fn fahrenheit(value : Double) -> Quantity {
  quantity(value, "degF", 5.0 / 9.0, 255.3722222222)
}

///|
pub fn mass_concentration(value : Double, unit : String) -> Quantity {
  quantity_dimensionless(value, unit)
}

///|
pub fn quantity_add(left : Quantity, right : Quantity) -> Quantity {
  quantity_dimensionless(
    quantity_si_value(left) + quantity_si_value(right),
    left.unit,
  )
}

///|
pub fn quantity_subtract(left : Quantity, right : Quantity) -> Quantity {
  quantity_dimensionless(
    quantity_si_value(left) - quantity_si_value(right),
    left.unit,
  )
}

///|
pub fn quantity_multiply(
  left : Quantity,
  right : Quantity,
  unit : String,
) -> Quantity {
  quantity_dimensionless(
    quantity_si_value(left) * quantity_si_value(right),
    unit,
  )
}

///|
pub fn quantity_divide(
  left : Quantity,
  right : Quantity,
  unit : String,
) -> Quantity {
  let denominator = quantity_si_value(right)
  quantity_dimensionless(
    if denominator == 0.0 {
      0.0
    } else {
      quantity_si_value(left) / denominator
    },
    unit,
  )
}

///|
pub fn flow_from_volume_time(
  volume : Quantity,
  duration : Quantity,
  unit : String,
) -> Quantity {
  quantity_divide(volume, duration, unit)
}

///|
pub fn mass_rate(
  mass : Quantity,
  duration : Quantity,
  unit : String,
) -> Quantity {
  quantity_divide(mass, duration, unit)
}

///|
pub fn superficial_velocity(
  flow : Quantity,
  area : Quantity,
  unit : String,
) -> Quantity {
  quantity_divide(flow, area, unit)
}

///|
pub fn empty_bed_contact_time(
  volume : Quantity,
  flow : Quantity,
  unit : String,
) -> Quantity {
  quantity_divide(volume, flow, unit)
}

///|
pub fn quantity_array_to_si(values : Array[Quantity]) -> Array[Double] {
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    result[i] = quantity_si_value(values[i])
  }
  result
}

///|
pub fn observation(
  time : Double,
  value : Double,
  weight : Double,
  valid : Bool,
) -> Observation {
  { time, value, weight: if weight < 0.0 { 0.0 } else { weight }, valid }
}

///|
pub fn observation_table(
  times : Array[Double],
  values : Array[Double],
) -> ObservationTable {
  let size = if times.length() < values.length() {
    times.length()
  } else {
    values.length()
  }
  let safe_times = Array::make(size, 0.0)
  let safe_values = Array::make(size, 0.0)
  let weights = Array::make(size, 1.0)
  let valid = Array::make(size, true)
  for i in 0..<size {
    safe_times[i] = times[i]
    safe_values[i] = values[i]
  }
  { times: safe_times, values: safe_values, weights, valid }
}

///|
pub fn table_length(table : ObservationTable) -> Int {
  table.times.length()
}

///|
pub fn table_get(table : ObservationTable, index : Int) -> Observation {
  if index < 0 || index >= table_length(table) {
    observation(0.0, 0.0, 0.0, false)
  } else {
    {
      time: table.times[index],
      value: table.values[index],
      weight: table.weights[index],
      valid: table.valid[index],
    }
  }
}

///|
pub fn table_append(
  table : ObservationTable,
  item : Observation,
) -> ObservationTable {
  table.times.push(item.time)
  table.values.push(item.value)
  table.weights.push(item.weight)
  table.valid.push(item.valid)
  table
}

///|
pub fn table_mark_invalid(
  table : ObservationTable,
  index : Int,
) -> ObservationTable {
  if index >= 0 && index < table_length(table) {
    table.valid[index] = false
  }
  table
}

///|
pub fn table_set_weight(
  table : ObservationTable,
  index : Int,
  weight : Double,
) -> ObservationTable {
  if index >= 0 && index < table_length(table) {
    table.weights[index] = if weight < 0.0 { 0.0 } else { weight }
  }
  table
}

///|
pub fn table_copy(table : ObservationTable) -> ObservationTable {
  {
    times: table.times.copy(),
    values: table.values.copy(),
    weights: table.weights.copy(),
    valid: table.valid.copy(),
  }
}

///|
pub fn table_filter_valid(table : ObservationTable) -> ObservationTable {
  let result = observation_table([], [])
  for i in 0..<table_length(table) {
    if table.valid[i] {
      let _ = table_append(result, table_get(table, i))
    }
  }
  result
}

///|
pub fn table_filter_range(
  table : ObservationTable,
  lower : Double,
  upper : Double,
) -> ObservationTable {
  let result = observation_table([], [])
  let low = if lower <= upper { lower } else { upper }
  let high = if upper >= lower { upper } else { lower }
  for i in 0..<table_length(table) {
    let item = table_get(table, i)
    if item.valid && item.time >= low && item.time <= high {
      let _ = table_append(result, item)
    }
  }
  result
}

///|
pub fn table_sort_by_time(table : ObservationTable) -> ObservationTable {
  let result = table_copy(table)
  for i in 1..<table_length(result) {
    let item = table_get(result, i)
    let mut j = i
    while j > 0 && result.times[j - 1] > item.time {
      result.times[j] = result.times[j - 1]
      result.values[j] = result.values[j - 1]
      result.weights[j] = result.weights[j - 1]
      result.valid[j] = result.valid[j - 1]
      j = j - 1
    }
    result.times[j] = item.time
    result.values[j] = item.value
    result.weights[j] = item.weight
    result.valid[j] = item.valid
  }
  result
}

///|
pub fn table_deduplicate_time(
  table : ObservationTable,
  tolerance : Double,
) -> ObservationTable {
  let sorted = table_sort_by_time(table)
  let result = observation_table([], [])
  let tol = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  for item in 0..<table_length(sorted) {
    let current = table_get(sorted, item)
    if result.times.length() == 0 ||
      (current.time - result.times[result.times.length() - 1]).abs() > tol {
      let _ = table_append(result, current)
    } else {
      let last = result.times.length() - 1
      result.values[last] = 0.5 * (result.values[last] + current.value)
      result.weights[last] = result.weights[last] + current.weight
      result.valid[last] = result.valid[last] && current.valid
    }
  }
  result
}

///|
pub fn table_fill_linear(
  table : ObservationTable,
  target_times : Array[Double],
) -> ObservationTable {
  let clean = table_filter_valid(table)
  let sorted = table_sort_by_time(clean)
  let values = resample_linear(sorted.times, sorted.values, target_times)
  let result = observation_table(target_times, values)
  for i in 0..<table_length(result) {
    result.weights[i] = 1.0
  }
  result
}

///|
pub fn table_summary(table : ObservationTable) -> TableSummary {
  let mut valid_count = 0
  let mut missing_count = 0
  let mut total_weight = 0.0
  let mut weighted_total = 0.0
  let mut minimum = 1.0e30
  let mut maximum = -1.0e30
  let valid_values : Array[Double] = []
  for i in 0..<table_length(table) {
    if table.valid[i] {
      valid_count = valid_count + 1
      let weight = if table.weights[i] <= 0.0 { 1.0 } else { table.weights[i] }
      total_weight = total_weight + weight
      weighted_total = weighted_total + weight * table.values[i]
      valid_values.push(table.values[i])
      if table.values[i] < minimum {
        minimum = table.values[i]
      }
      if table.values[i] > maximum {
        maximum = table.values[i]
      }
    } else {
      missing_count = missing_count + 1
    }
  }
  let mean = if total_weight == 0.0 {
    0.0
  } else {
    weighted_total / total_weight
  }
  let mut variance = 0.0
  for value in valid_values {
    variance = variance + (value - mean) * (value - mean)
  }
  let deviation = if valid_count == 0 {
    0.0
  } else {
    (variance / valid_count.to_double()).sqrt()
  }
  {
    count: table_length(table),
    valid_count,
    missing_count,
    mean,
    standard_deviation: deviation,
    minimum: if valid_count == 0 {
      0.0
    } else {
      minimum
    },
    maximum: if valid_count == 0 {
      0.0
    } else {
      maximum
    },
    integral: interpolation_integral(table.times, table.values),
  }
}

///|
pub fn table_values(
  table : ObservationTable,
  include_invalid : Bool,
) -> Array[Double] {
  let result : Array[Double] = []
  for i in 0..<table_length(table) {
    if include_invalid || table.valid[i] {
      result.push(table.values[i])
    }
  }
  result
}

///|
pub fn table_times(
  table : ObservationTable,
  include_invalid : Bool,
) -> Array[Double] {
  let result : Array[Double] = []
  for i in 0..<table_length(table) {
    if include_invalid || table.valid[i] {
      result.push(table.times[i])
    }
  }
  result
}

///|
pub fn table_weighted_mean(table : ObservationTable) -> Double {
  let summary = table_summary(table)
  summary.mean
}

///|
pub fn table_weighted_variance(table : ObservationTable) -> Double {
  let summary = table_summary(table)
  let mut total_weight = 0.0
  let mut total = 0.0
  for i in 0..<table_length(table) {
    if table.valid[i] {
      let weight = if table.weights[i] <= 0.0 { 1.0 } else { table.weights[i] }
      total_weight = total_weight + weight
      total = total +
        weight *
        (table.values[i] - summary.mean) *
        (table.values[i] - summary.mean)
    }
  }
  if total_weight == 0.0 {
    0.0
  } else {
    total / total_weight
  }
}

///|
pub fn table_z_scores(table : ObservationTable) -> Array[Double] {
  let summary = table_summary(table)
  let scale = if summary.standard_deviation <= 1.0e-30 {
    1.0
  } else {
    summary.standard_deviation
  }
  let result = Array::make(table_length(table), 0.0)
  for i in 0..<result.length() {
    result[i] = (table.values[i] - summary.mean) / scale
  }
  result
}

///|
pub fn table_outlier_flags(
  table : ObservationTable,
  threshold : Double,
) -> Array[QualityFlag] {
  let z_scores = table_z_scores(table)
  let limit = if threshold <= 0.0 { 3.0 } else { threshold }
  let flags : Array[QualityFlag] = []
  for i in 0..<z_scores.length() {
    if table.valid[i] && z_scores[i].abs() > limit {
      flags.push({ index: i, code: 2, score: z_scores[i], message: "outlier" })
    }
  }
  flags
}

///|
pub fn table_quality(
  table : ObservationTable,
  outlier_threshold : Double,
  minimum_time_step : Double,
) -> QualityReport {
  let flags : Array[QualityFlag] = []
  let mut valid_count = 0
  let mut invalid_count = 0
  for i in 0..<table_length(table) {
    if table.valid[i] {
      valid_count = valid_count + 1
    } else {
      invalid_count = invalid_count + 1
      flags.push({ index: i, code: 1, score: 0.0, message: "invalid" })
    }
    if i > 0 &&
      table.valid[i] &&
      table.valid[i - 1] &&
      table.times[i] - table.times[i - 1] < minimum_time_step {
      flags.push({
        index: i,
        code: 3,
        score: table.times[i] - table.times[i - 1],
        message: "time-step",
      })
    }
  }
  let outliers = table_outlier_flags(table, outlier_threshold)
  for flag in outliers {
    flags.push(flag)
  }
  let total = table_length(table)
  {
    flags,
    valid_count,
    invalid_count,
    outlier_count: outliers.length(),
    completeness: if total == 0 {
      0.0
    } else {
      valid_count.to_double() / total.to_double()
    },
    weighted_mean: table_weighted_mean(table),
  }
}

///|
pub fn quality_has_fatal(report : QualityReport) -> Bool {
  for flag in report.flags {
    if flag.code == 1 {
      return true
    }
  }
  false
}

///|
pub fn quality_score(report : QualityReport) -> Double {
  let penalty = report.invalid_count.to_double() +
    report.outlier_count.to_double() * 0.25
  let score = report.completeness -
    penalty / (report.valid_count + report.invalid_count + 1).to_double()
  clamp(score, 0.0, 1.0)
}

///|
pub fn process_moving_average(
  values : Array[Double],
  window : Int,
) -> Array[Double] {
  if window <= 0 {
    return values.copy()
  }
  let result = Array::make(values.length(), 0.0)
  let mut running = 0.0
  for i in 0..<values.length() {
    running = running + values[i]
    if i >= window {
      running = running - values[i - window]
    }
    let count = if i + 1 < window { i + 1 } else { window }
    result[i] = running / count.to_double()
  }
  result
}

///|
pub fn process_moving_weighted_average(
  values : Array[Double],
  weights : Array[Double],
  window : Int,
) -> Array[Double] {
  if values.length() != weights.length() || window <= 0 {
    return []
  }
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    let lower = if i + 1 > window { i + 1 - window } else { 0 }
    let mut total = 0.0
    let mut denominator = 0.0
    for j in lower..<(i + 1) {
      let weight = if weights[j] < 0.0 { 0.0 } else { weights[j] }
      total = total + weight * values[j]
      denominator = denominator + weight
    }
    result[i] = if denominator == 0.0 { values[i] } else { total / denominator }
  }
  result
}

///|
pub fn process_rolling_rms(
  values : Array[Double],
  window : Int,
) -> Array[Double] {
  let result = Array::make(values.length(), 0.0)
  if window <= 0 {
    return result
  }
  for i in 0..<values.length() {
    let lower = if i + 1 > window { i + 1 - window } else { 0 }
    let mut total = 0.0
    for j in lower..<(i + 1) {
      total = total + values[j] * values[j]
    }
    result[i] = (total / (i + 1 - lower).to_double()).sqrt()
  }
  result
}
