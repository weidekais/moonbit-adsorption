///|
/// Langmuir model parameters.
/// q = (q_m * k_l * C) / (1 + k_l * C)
pub(all) struct LangmuirParams {
  q_m : Double
  k_l : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Fits Langmuir parameters using linear regression on C/q = 1/(q_m * k_l) + C/q_m
pub fn fit_langmuir(data : Array[AdsorptionData]) -> LangmuirParams {
  let points = []
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let x = d.c
      let y = d.c / d.q
      points.push(@utils.Point::{ x, y })
    }
  }
  let reg = @utils.linear_regression(points)
  let q_m = if reg.slope != 0.0 { 1.0 / reg.slope } else { 0.0 }
  let k_l = if reg.intercept != 0.0 && q_m != 0.0 {
    1.0 / (reg.intercept * q_m)
  } else {
    0.0
  }
  { q_m, k_l, r_squared: reg.r_squared }
}

///|
/// Predicts the adsorption capacity (q) for a given concentration (c) using the Langmuir model.
pub fn predict_langmuir(params : LangmuirParams, c : Double) -> Double {
  params.q_m * params.k_l * c / (1.0 + params.k_l * c)
}
