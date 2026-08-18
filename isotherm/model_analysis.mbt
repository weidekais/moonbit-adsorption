///|
/// Evaluate langmuir over a concentration grid.
pub fn langmuir_curve(
  params : LangmuirParams,
  concentrations : Array[Double],
) -> Array[Double] {
  let result = Array::make(concentrations.length(), 0.0)
  for i in 0..<concentrations.length() {
    result[i] = predict_langmuir(params, concentrations[i])
  }
  result
}

///|
pub fn langmuir_capacity_average(
  params : LangmuirParams,
  concentrations : Array[Double],
) -> Double {
  if concentrations.length() == 0 {
    0.0
  } else {
    @utils.mean(langmuir_curve(params, concentrations))
  }
}

///|
pub fn langmuir_capacity_maximum(
  params : LangmuirParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(langmuir_curve(params, concentrations)).maximum
}

///|
pub fn langmuir_capacity_minimum(
  params : LangmuirParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(langmuir_curve(params, concentrations)).minimum
}

///|
pub fn langmuir_capacity_integral(
  params : LangmuirParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Double {
  let xs = @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples })
  @utils.trapezoid_area(xs, langmuir_curve(params, xs))
}

///|
pub fn langmuir_finite_sensitivity(
  params : LangmuirParams,
  concentration : Double,
  step : Double,
) -> @utils.SensitivityPoint {
  @utils.finite_difference_sensitivity(
    fn(c) { predict_langmuir(params, c) },
    concentration,
    step,
  )
}

///|
pub fn langmuir_elasticity(
  params : LangmuirParams,
  concentration : Double,
  step : Double,
) -> Double {
  @utils.elasticity(fn(c) { predict_langmuir(params, c) }, concentration, step)
}

///|
pub fn langmuir_is_monotone(
  params : LangmuirParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Bool {
  let curve = langmuir_curve(
    params,
    @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples }),
  )
  let mut ok = true
  for i in 1..<curve.length() {
    if curve[i] < curve[i - 1] {
      ok = false
    }
  }
  ok
}

///|
/// Evaluate freundlich over a concentration grid.
pub fn freundlich_curve(
  params : FreundlichParams,
  concentrations : Array[Double],
) -> Array[Double] {
  let result = Array::make(concentrations.length(), 0.0)
  for i in 0..<concentrations.length() {
    result[i] = predict_freundlich(params, concentrations[i])
  }
  result
}

///|
pub fn freundlich_capacity_average(
  params : FreundlichParams,
  concentrations : Array[Double],
) -> Double {
  if concentrations.length() == 0 {
    0.0
  } else {
    @utils.mean(freundlich_curve(params, concentrations))
  }
}

///|
pub fn freundlich_capacity_maximum(
  params : FreundlichParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(freundlich_curve(params, concentrations)).maximum
}

///|
pub fn freundlich_capacity_minimum(
  params : FreundlichParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(freundlich_curve(params, concentrations)).minimum
}

///|
pub fn freundlich_capacity_integral(
  params : FreundlichParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Double {
  let xs = @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples })
  @utils.trapezoid_area(xs, freundlich_curve(params, xs))
}

///|
pub fn freundlich_finite_sensitivity(
  params : FreundlichParams,
  concentration : Double,
  step : Double,
) -> @utils.SensitivityPoint {
  @utils.finite_difference_sensitivity(
    fn(c) { predict_freundlich(params, c) },
    concentration,
    step,
  )
}

///|
pub fn freundlich_elasticity(
  params : FreundlichParams,
  concentration : Double,
  step : Double,
) -> Double {
  @utils.elasticity(
    fn(c) { predict_freundlich(params, c) },
    concentration,
    step,
  )
}

///|
pub fn freundlich_is_monotone(
  params : FreundlichParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Bool {
  let curve = freundlich_curve(
    params,
    @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples }),
  )
  let mut ok = true
  for i in 1..<curve.length() {
    if curve[i] < curve[i - 1] {
      ok = false
    }
  }
  ok
}

///|
/// Evaluate temkin over a concentration grid.
pub fn temkin_curve(
  params : TemkinParams,
  concentrations : Array[Double],
) -> Array[Double] {
  let result = Array::make(concentrations.length(), 0.0)
  for i in 0..<concentrations.length() {
    result[i] = predict_temkin(params, concentrations[i])
  }
  result
}

///|
pub fn temkin_capacity_average(
  params : TemkinParams,
  concentrations : Array[Double],
) -> Double {
  if concentrations.length() == 0 {
    0.0
  } else {
    @utils.mean(temkin_curve(params, concentrations))
  }
}

///|
pub fn temkin_capacity_maximum(
  params : TemkinParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(temkin_curve(params, concentrations)).maximum
}

///|
pub fn temkin_capacity_minimum(
  params : TemkinParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(temkin_curve(params, concentrations)).minimum
}

///|
pub fn temkin_capacity_integral(
  params : TemkinParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Double {
  let xs = @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples })
  @utils.trapezoid_area(xs, temkin_curve(params, xs))
}

///|
pub fn temkin_finite_sensitivity(
  params : TemkinParams,
  concentration : Double,
  step : Double,
) -> @utils.SensitivityPoint {
  @utils.finite_difference_sensitivity(
    fn(c) { predict_temkin(params, c) },
    concentration,
    step,
  )
}

///|
pub fn temkin_elasticity(
  params : TemkinParams,
  concentration : Double,
  step : Double,
) -> Double {
  @utils.elasticity(fn(c) { predict_temkin(params, c) }, concentration, step)
}

///|
pub fn temkin_is_monotone(
  params : TemkinParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Bool {
  let curve = temkin_curve(
    params,
    @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples }),
  )
  let mut ok = true
  for i in 1..<curve.length() {
    if curve[i] < curve[i - 1] {
      ok = false
    }
  }
  ok
}

///|
/// Evaluate sips over a concentration grid.
pub fn sips_curve(
  params : SipsParams,
  concentrations : Array[Double],
) -> Array[Double] {
  let result = Array::make(concentrations.length(), 0.0)
  for i in 0..<concentrations.length() {
    result[i] = predict_sips(params, concentrations[i])
  }
  result
}

///|
pub fn sips_capacity_average(
  params : SipsParams,
  concentrations : Array[Double],
) -> Double {
  if concentrations.length() == 0 {
    0.0
  } else {
    @utils.mean(sips_curve(params, concentrations))
  }
}

///|
pub fn sips_capacity_maximum(
  params : SipsParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(sips_curve(params, concentrations)).maximum
}

///|
pub fn sips_capacity_minimum(
  params : SipsParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(sips_curve(params, concentrations)).minimum
}

///|
pub fn sips_capacity_integral(
  params : SipsParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Double {
  let xs = @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples })
  @utils.trapezoid_area(xs, sips_curve(params, xs))
}

///|
pub fn sips_finite_sensitivity(
  params : SipsParams,
  concentration : Double,
  step : Double,
) -> @utils.SensitivityPoint {
  @utils.finite_difference_sensitivity(
    fn(c) { predict_sips(params, c) },
    concentration,
    step,
  )
}

///|
pub fn sips_elasticity(
  params : SipsParams,
  concentration : Double,
  step : Double,
) -> Double {
  @utils.elasticity(fn(c) { predict_sips(params, c) }, concentration, step)
}

///|
pub fn sips_is_monotone(
  params : SipsParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Bool {
  let curve = sips_curve(
    params,
    @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples }),
  )
  let mut ok = true
  for i in 1..<curve.length() {
    if curve[i] < curve[i - 1] {
      ok = false
    }
  }
  ok
}

///|
/// Evaluate toth over a concentration grid.
pub fn toth_curve(
  params : TothParams,
  concentrations : Array[Double],
) -> Array[Double] {
  let result = Array::make(concentrations.length(), 0.0)
  for i in 0..<concentrations.length() {
    result[i] = predict_toth(params, concentrations[i])
  }
  result
}

///|
pub fn toth_capacity_average(
  params : TothParams,
  concentrations : Array[Double],
) -> Double {
  if concentrations.length() == 0 {
    0.0
  } else {
    @utils.mean(toth_curve(params, concentrations))
  }
}

///|
pub fn toth_capacity_maximum(
  params : TothParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(toth_curve(params, concentrations)).maximum
}

///|
pub fn toth_capacity_minimum(
  params : TothParams,
  concentrations : Array[Double],
) -> Double {
  @utils.summarize(toth_curve(params, concentrations)).minimum
}

///|
pub fn toth_capacity_integral(
  params : TothParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Double {
  let xs = @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples })
  @utils.trapezoid_area(xs, toth_curve(params, xs))
}

///|
pub fn toth_finite_sensitivity(
  params : TothParams,
  concentration : Double,
  step : Double,
) -> @utils.SensitivityPoint {
  @utils.finite_difference_sensitivity(
    fn(c) { predict_toth(params, c) },
    concentration,
    step,
  )
}

///|
pub fn toth_elasticity(
  params : TothParams,
  concentration : Double,
  step : Double,
) -> Double {
  @utils.elasticity(fn(c) { predict_toth(params, c) }, concentration, step)
}

///|
pub fn toth_is_monotone(
  params : TothParams,
  lower : Double,
  upper : Double,
  samples : Int,
) -> Bool {
  let curve = toth_curve(
    params,
    @utils.linspace(lower, upper, if samples < 2 { 2 } else { samples }),
  )
  let mut ok = true
  for i in 1..<curve.length() {
    if curve[i] < curve[i - 1] {
      ok = false
    }
  }
  ok
}

///|
/// Compare two fitted models on the same concentration grid.
pub fn model_rmse(actual : Array[Double], predicted : Array[Double]) -> Double {
  @utils.rmse(actual, predicted)
}

///|
pub fn model_mae(actual : Array[Double], predicted : Array[Double]) -> Double {
  @utils.mae(actual, predicted)
}

///|
pub fn model_aic(
  actual : Array[Double],
  predicted : Array[Double],
  parameters : Int,
) -> Double {
  @utils.aic(
    @utils.mse(actual, predicted) * actual.length().to_double(),
    actual.length(),
    parameters,
  )
}

///|
pub fn model_bic(
  actual : Array[Double],
  predicted : Array[Double],
  parameters : Int,
) -> Double {
  @utils.bic(
    @utils.mse(actual, predicted) * actual.length().to_double(),
    actual.length(),
    parameters,
  )
}
