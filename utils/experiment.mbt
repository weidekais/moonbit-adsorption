///|
/// A compact design-of-experiment description for reproducible studies.
pub(all) struct ExperimentPlan {
  name : String
  factors : Array[String]
  levels : Array[Array[Double]]
  replicates : Int
} derive(Debug, Eq)

///|
pub fn full_factorial(
  name : String,
  factors : Array[String],
  lower : Array[Double],
  upper : Array[Double],
  levels : Int,
  replicates : Int,
) -> ExperimentPlan {
  let safe_levels = if levels < 2 { 2 } else { levels }
  let grid = []
  let axis = []
  for i in 0..<factors.length() {
    let low = if i < lower.length() { lower[i] } else { 0.0 }
    let high = if i < upper.length() { upper[i] } else { low }
    axis.push(linspace(low, high, safe_levels))
  }
  fn enumerate_axis(
    axis : Array[Array[Double]],
    depth : Int,
    current : Array[Double],
    output : Array[Array[Double]],
  ) -> Unit {
    if depth == axis.length() {
      output.push(current.copy())
    } else {
      for value in axis[depth] {
        current.push(value)
        enumerate_axis(axis, depth + 1, current, output)
        ignore(current.pop())
      }
    }
  }
  enumerate_axis(axis, 0, [], grid)
  {
    name,
    factors,
    levels: grid,
    replicates: if replicates < 1 {
      1
    } else {
      replicates
    },
  }
}

///|
pub fn center_points(plan : ExperimentPlan) -> Array[Double] {
  if plan.levels.length() == 0 {
    return []
  }
  let result = Array::make(plan.factors.length(), 0.0)
  for i in 0..<result.length() {
    let mut total = 0.0
    let mut count = 0
    for level in plan.levels {
      if i < level.length() {
        total = total + level[i]
        count = count + 1
      }
    }
    result[i] = if count == 0 { 0.0 } else { total / count.to_double() }
  }
  result
}

///|
pub fn scale_to_unit(value : Double, lower : Double, upper : Double) -> Double {
  if upper == lower {
    0.0
  } else {
    2.0 * (value - lower) / (upper - lower) - 1.0
  }
}

///|
pub fn unscale_from_unit(
  value : Double,
  lower : Double,
  upper : Double,
) -> Double {
  lower + (value + 1.0) * (upper - lower) / 2.0
}

///|
pub(all) struct SensitivityPoint {
  input : Double
  output : Double
  local_sensitivity : Double
} derive(Debug, Eq)

///|
pub fn finite_difference_sensitivity(
  f : (Double) -> Double,
  input : Double,
  step : Double,
) -> SensitivityPoint {
  let h = if step == 0.0 { 1.0e-6 } else { step.abs() }
  let lower = f(input - h)
  let upper = f(input + h)
  { input, output: f(input), local_sensitivity: (upper - lower) / (2.0 * h) }
}

///|
pub fn sensitivity_curve(
  f : (Double) -> Double,
  inputs : Array[Double],
  step : Double,
) -> Array[SensitivityPoint] {
  let result = []
  for input in inputs {
    result.push(finite_difference_sensitivity(f, input, step))
  }
  result
}

///|
pub fn elasticity(
  f : (Double) -> Double,
  input : Double,
  step : Double,
) -> Double {
  let point = finite_difference_sensitivity(f, input, step)
  if point.output == 0.0 {
    0.0
  } else {
    point.local_sensitivity * input / point.output
  }
}

///|
pub(all) struct ConfidenceInterval {
  estimate : Double
  lower : Double
  upper : Double
  confidence : Double
} derive(Debug, Eq)

///|
pub fn normal_interval(
  values : Array[Double],
  z : Double,
  confidence : Double,
) -> ConfidenceInterval {
  let summary = summarize(values)
  let margin = if summary.count == 0 {
    0.0
  } else {
    z * summary.standard_deviation / summary.count.to_double().sqrt()
  }
  {
    estimate: summary.mean,
    lower: summary.mean - margin,
    upper: summary.mean + margin,
    confidence,
  }
}

///|
pub fn bootstrap_mean(samples : Array[Array[Double]]) -> ConfidenceInterval {
  let estimates = []
  for sample in samples {
    estimates.push(mean(sample))
  }
  {
    estimate: mean(estimates),
    lower: percentile(estimates, 0.025),
    upper: percentile(estimates, 0.975),
    confidence: 0.95,
  }
}

///|
pub fn rank(values : Array[Double]) -> Array[Int] {
  let result = Array::make(values.length(), 0)
  for i in 0..<values.length() {
    let mut rank = 0
    for j in 0..<values.length() {
      if values[j] < values[i] || (values[j] == values[i] && j < i) {
        rank = rank + 1
      }
    }
    result[i] = rank
  }
  result
}

///|
pub fn argmin(values : Array[Double]) -> Int {
  if values.length() == 0 {
    return -1
  }
  let mut index = 0
  for i in 1..<values.length() {
    if values[i] < values[index] {
      index = i
    }
  }
  index
}

///|
pub fn argmax(values : Array[Double]) -> Int {
  if values.length() == 0 {
    return -1
  }
  let mut index = 0
  for i in 1..<values.length() {
    if values[i] > values[index] {
      index = i
    }
  }
  index
}

///|
pub fn choose_best_model(scores : Array[Double]) -> Int {
  argmax(scores)
}

///|
pub fn aic(
  residual_sum : Double,
  sample_count : Int,
  parameter_count : Int,
) -> Double {
  if sample_count <= 0 {
    0.0
  } else {
    sample_count.to_double() * @math.ln(residual_sum / sample_count.to_double()) +
    2.0 * parameter_count.to_double()
  }
}

///|
pub fn bic(
  residual_sum : Double,
  sample_count : Int,
  parameter_count : Int,
) -> Double {
  if sample_count <= 0 {
    0.0
  } else {
    sample_count.to_double() * @math.ln(residual_sum / sample_count.to_double()) +
    parameter_count.to_double() * @math.ln(sample_count.to_double())
  }
}
