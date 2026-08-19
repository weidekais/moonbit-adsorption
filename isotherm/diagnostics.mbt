///|
/// Fit diagnostics and uncertainty summaries for adsorption model selection.
pub struct ResidualRecord {
  index : Int
  concentration : Double
  observed : Double
  predicted : Double
  residual : Double
  standardized : Double
  relative : Double
}

///|
pub struct FitDiagnostics {
  records : Array[ResidualRecord]
  rmse : Double
  mae : Double
  bias : Double
  r_squared : Double
  max_absolute_error : Double
  residual_standard_deviation : Double
  durbin_watson : Double
}

///|
pub struct ModelScore {
  name : String
  parameters : Int
  observations : Int
  rmse : Double
  aic : Double
  bic : Double
  score : Double
}

///|
pub struct BootstrapSummary {
  mean : Double
  standard_deviation : Double
  lower : Double
  median : Double
  upper : Double
  samples : Array[Double]
}

///|
pub fn diagnostic_residuals(
  observed : Array[Double],
  predicted : Array[Double],
  concentrations : Array[Double],
) -> Array[ResidualRecord] {
  let size = if observed.length() < predicted.length() {
    observed.length()
  } else {
    predicted.length()
  }
  let residuals = Array::make(size, 0.0)
  for i in 0..<size {
    residuals[i] = observed[i] - predicted[i]
  }
  let deviation = @utils.signal_standard_deviation(residuals)
  let scale = if deviation <= 1.0e-30 { 1.0 } else { deviation }
  let result : Array[ResidualRecord] = []
  for i in 0..<size {
    let concentration = if i < concentrations.length() {
      concentrations[i]
    } else {
      i.to_double()
    }
    let relative = if observed[i].abs() <= 1.0e-30 {
      residuals[i]
    } else {
      residuals[i] / observed[i]
    }
    result.push({
      index: i,
      concentration,
      observed: observed[i],
      predicted: predicted[i],
      residual: residuals[i],
      standardized: residuals[i] / scale,
      relative,
    })
  }
  result
}

///|
pub fn diagnostic_fit(
  observed : Array[Double],
  predicted : Array[Double],
  concentrations : Array[Double],
) -> FitDiagnostics {
  let records = diagnostic_residuals(observed, predicted, concentrations)
  let residuals : Array[Double] = []
  for record in records {
    residuals.push(record.residual)
  }
  let rmse = @utils.objective_rms(residuals)
  let mae = @utils.objective_mae(residuals)
  let bias = @utils.signal_mean(residuals)
  let mean = @utils.signal_mean(observed)
  let mut total = 0.0
  let mut error = 0.0
  let mut maximum = 0.0
  for i in 0..<records.length() {
    total = total + (observed[i] - mean) * (observed[i] - mean)
    error = error + records[i].residual * records[i].residual
    if records[i].residual.abs() > maximum {
      maximum = records[i].residual.abs()
    }
  }
  let mut durbin = 0.0
  for i in 1..<residuals.length() {
    let delta = residuals[i] - residuals[i - 1]
    durbin = durbin + delta * delta
  }
  {
    records,
    rmse,
    mae,
    bias,
    r_squared: if total == 0.0 {
      1.0
    } else {
      1.0 - error / total
    },
    max_absolute_error: maximum,
    residual_standard_deviation: @utils.signal_standard_deviation(residuals),
    durbin_watson: if error == 0.0 {
      0.0
    } else {
      durbin / error
    },
  }
}

///|
pub fn diagnostic_residual_values(
  diagnostics : FitDiagnostics,
) -> Array[Double] {
  let result = Array::make(diagnostics.records.length(), 0.0)
  for i in 0..<result.length() {
    result[i] = diagnostics.records[i].residual
  }
  result
}

///|
pub fn diagnostic_standardized_values(
  diagnostics : FitDiagnostics,
) -> Array[Double] {
  let result = Array::make(diagnostics.records.length(), 0.0)
  for i in 0..<result.length() {
    result[i] = diagnostics.records[i].standardized
  }
  result
}

///|
pub fn diagnostic_relative_values(
  diagnostics : FitDiagnostics,
) -> Array[Double] {
  let result = Array::make(diagnostics.records.length(), 0.0)
  for i in 0..<result.length() {
    result[i] = diagnostics.records[i].relative
  }
  result
}

///|
pub fn diagnostic_outliers(
  diagnostics : FitDiagnostics,
  threshold : Double,
) -> Array[ResidualRecord] {
  let limit = if threshold <= 0.0 { 3.0 } else { threshold }
  let result : Array[ResidualRecord] = []
  for record in diagnostics.records {
    if record.standardized.abs() > limit {
      result.push(record)
    }
  }
  result
}

///|
pub fn diagnostic_leverage(
  concentrations : Array[Double],
  tolerance : Double,
) -> Array[Double] {
  if concentrations.length() == 0 {
    return []
  }
  let mean = @utils.signal_mean(concentrations)
  let mut total = 0.0
  for value in concentrations {
    total = total + (value - mean) * (value - mean)
  }
  let result = Array::make(concentrations.length(), 0.0)
  let denominator = if total <= tolerance { 1.0 } else { total }
  for i in 0..<result.length() {
    result[i] = 1.0 / result.length().to_double() +
      (concentrations[i] - mean) * (concentrations[i] - mean) / denominator
  }
  result
}

///|
pub fn diagnostic_cooks_distance(
  diagnostics : FitDiagnostics,
  leverage : Array[Double],
  parameter_count : Int,
) -> Array[Double] {
  let result = Array::make(diagnostics.records.length(), 0.0)
  let degrees = if diagnostics.records.length() <= parameter_count {
    1.0
  } else {
    (diagnostics.records.length() - parameter_count).to_double()
  }
  for i in 0..<result.length() {
    let h = if i < leverage.length() { leverage[i] } else { 0.0 }
    result[i] = diagnostics.records[i].standardized *
      diagnostics.records[i].standardized *
      h /
      ((1.0 - h) * (parameter_count + 1).to_double()) *
      degrees
  }
  result
}

///|
pub fn diagnostic_aic(
  diagnostics : FitDiagnostics,
  parameter_count : Int,
) -> Double {
  @utils.aic(
    diagnostics.rmse *
    diagnostics.rmse *
    diagnostics.records.length().to_double(),
    parameter_count,
    diagnostics.records.length(),
  )
}

///|
pub fn diagnostic_bic(
  diagnostics : FitDiagnostics,
  parameter_count : Int,
) -> Double {
  @utils.bic(
    diagnostics.rmse *
    diagnostics.rmse *
    diagnostics.records.length().to_double(),
    parameter_count,
    diagnostics.records.length(),
  )
}

///|
pub fn model_score(
  name : String,
  parameter_count : Int,
  observed : Array[Double],
  predicted : Array[Double],
  concentrations : Array[Double],
) -> ModelScore {
  let diagnostics = diagnostic_fit(observed, predicted, concentrations)
  let aic = diagnostic_aic(diagnostics, parameter_count)
  let bic = diagnostic_bic(diagnostics, parameter_count)
  {
    name,
    parameters: parameter_count,
    observations: diagnostics.records.length(),
    rmse: diagnostics.rmse,
    aic,
    bic,
    score: bic,
  }
}

///|
pub fn compare_model_scores(scores : Array[ModelScore]) -> ModelScore {
  if scores.length() == 0 {
    return {
      name: "none",
      parameters: 0,
      observations: 0,
      rmse: 0.0,
      aic: 1.0e30,
      bic: 1.0e30,
      score: 1.0e30,
    }
  }
  let mut best = scores[0]
  for score in scores {
    if score.score < best.score {
      best = score
    }
  }
  best
}

///|
pub fn model_score_ranking(scores : Array[ModelScore]) -> Array[Int] {
  let result = Array::make(scores.length(), 0)
  for i in 0..<result.length() {
    result[i] = i
  }
  for i in 1..<result.length() {
    let current = result[i]
    let mut j = i
    while j > 0 && scores[result[j - 1]].score > scores[current].score {
      result[j] = result[j - 1]
      j = j - 1
    }
    result[j] = current
  }
  result
}

///|
pub fn diagnostic_prediction_interval(
  diagnostics : FitDiagnostics,
  confidence_multiplier : Double,
) -> (Double, Double) {
  let multiplier = if confidence_multiplier <= 0.0 {
    1.96
  } else {
    confidence_multiplier
  }
  let half = multiplier * diagnostics.residual_standard_deviation
  (diagnostics.bias - half, diagnostics.bias + half)
}

///|
pub fn deterministic_resample(
  values : Array[Double],
  sample_size : Int,
  offset : Int,
) -> Array[Double] {
  if values.length() == 0 || sample_size <= 0 {
    return []
  }
  let result = Array::make(sample_size, 0.0)
  for i in 0..<sample_size {
    result[i] = values[(i * 17 + offset * 13 + 7).abs() % values.length()]
  }
  result
}

///|
pub fn bootstrap_summary(
  values : Array[Double],
  sample_size : Int,
  repetitions : Int,
) -> BootstrapSummary {
  let count = if repetitions <= 0 { 100 } else { repetitions }
  let size = if sample_size <= 0 { values.length() } else { sample_size }
  let samples = Array::make(count, 0.0)
  for i in 0..<count {
    samples[i] = @utils.signal_mean(deterministic_resample(values, size, i))
  }
  let mean = @utils.signal_mean(samples)
  {
    mean,
    standard_deviation: @utils.signal_standard_deviation(samples),
    lower: @utils.signal_quantile(samples, 0.025),
    median: @utils.signal_quantile(samples, 0.5),
    upper: @utils.signal_quantile(samples, 0.975),
    samples,
  }
}

///|
pub fn bootstrap_capacity(
  data : Array[AdsorptionData],
  predictor : (Array[Double], Double) -> Double,
  parameters : Array[Double],
  repetitions : Int,
) -> BootstrapSummary {
  let capacities : Array[Double] = []
  for item in data {
    capacities.push(predictor(parameters, item.c))
  }
  bootstrap_summary(capacities, capacities.length(), repetitions)
}

///|
pub fn confidence_half_width(
  summary : BootstrapSummary,
  confidence : Double,
) -> Double {
  let probability = @utils.clamp((1.0 + confidence) / 2.0, 0.5, 0.999)
  0.5 *
  (
    @utils.signal_quantile(summary.samples, probability) -
    @utils.signal_quantile(summary.samples, 1.0 - probability)
  )
}

///|
pub fn fit_stability_score(
  scores : Array[ModelScore],
  bootstrap : BootstrapSummary,
) -> Double {
  if scores.length() == 0 {
    return 0.0
  }
  let best = compare_model_scores(scores)
  let spread = if bootstrap.mean.abs() <= 1.0e-30 {
    bootstrap.standard_deviation
  } else {
    bootstrap.standard_deviation / bootstrap.mean.abs()
  }
  @utils.clamp(1.0 - spread - best.rmse / (1.0 + best.rmse), 0.0, 1.0)
}

///|
pub fn residual_normality_proxy(diagnostics : FitDiagnostics) -> Double {
  let values = diagnostic_standardized_values(diagnostics)
  let skew = @utils.signal_mean(values)
  let tails = @utils.signal_quantile(values, 0.95).abs() -
    @utils.signal_quantile(values, 0.05).abs()
  @utils.clamp(1.0 - skew.abs() - tails.abs() * 0.1, 0.0, 1.0)
}

///|
pub fn model_is_adequate(
  diagnostics : FitDiagnostics,
  maximum_rmse : Double,
  maximum_durbin_watson_error : Double,
) -> Bool {
  let rmse_limit = if maximum_rmse <= 0.0 { 1.0e30 } else { maximum_rmse }
  let rmse_ok = diagnostics.rmse <= rmse_limit
  let dw_error = (diagnostics.durbin_watson - 2.0).abs()
  let dw_limit = if maximum_durbin_watson_error <= 0.0 {
    1.0
  } else {
    maximum_durbin_watson_error
  }
  rmse_ok &&
  dw_error <= dw_limit &&
  diagnostic_outliers(diagnostics, 3.0).length() == 0
}
