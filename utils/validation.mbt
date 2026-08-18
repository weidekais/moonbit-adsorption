///|
/// Input validation report for experimental data and simulator settings.
pub(all) struct ValidationReport {
  valid : Bool
  errors : Array[String]
  warnings : Array[String]
} derive(Debug, Eq)

///|
pub fn valid_report() -> ValidationReport {
  { valid: true, errors: [], warnings: [] }
}

///|
pub fn validate_pairs(
  xs : Array[Double],
  ys : Array[Double],
) -> ValidationReport {
  let errors = []
  let warnings = []
  if xs.length() != ys.length() {
    errors.push("x and y must have equal length")
  }
  if xs.length() == 0 {
    warnings.push("the data set is empty")
  }
  for i in 0..<xs.length() {
    if xs[i] != xs[i] {
      errors.push("x contains NaN at index \\{i}")
    }
    if ys[i] != ys[i] {
      errors.push("y contains NaN at index \\{i}")
    }
  }
  { valid: errors.length() == 0, errors, warnings }
}

///|
pub fn validate_positive_pairs(
  xs : Array[Double],
  ys : Array[Double],
) -> ValidationReport {
  let report = validate_pairs(xs, ys)
  let errors = report.errors.copy()
  let warnings = report.warnings.copy()
  let limit = if xs.length() < ys.length() { xs.length() } else { ys.length() }
  for i in 0..<limit {
    if xs[i] <= 0.0 {
      errors.push("x must be positive at index \\{i}")
    }
    if ys[i] <= 0.0 {
      errors.push("y must be positive at index \\{i}")
    }
  }
  { valid: errors.length() == 0, errors, warnings }
}

///|
pub fn validate_probability(value : Double) -> Bool {
  value >= 0.0 && value <= 1.0
}

///|
pub fn validate_range(lower : Double, upper : Double) -> Bool {
  lower <= upper
}

///|
pub fn finite_or_zero(value : Double) -> Double {
  if value != value {
    0.0
  } else {
    value
  }
}

///|
pub fn sanitize_nonnegative(values : Array[Double]) -> Array[Double] {
  let result = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    result[i] = if values[i] < 0.0 { 0.0 } else { finite_or_zero(values[i]) }
  }
  result
}

///|
pub fn strictly_increasing(values : Array[Double]) -> Bool {
  if values.length() < 2 {
    true
  } else {
    let mut answer = true
    for i in 1..<values.length() {
      if values[i] <= values[i - 1] {
        answer = false
      }
    }
    answer
  }
}

///|
pub fn all_nonnegative(values : Array[Double]) -> Bool {
  let mut answer = true
  for value in values {
    if value < 0.0 {
      answer = false
    }
  }
  answer
}
