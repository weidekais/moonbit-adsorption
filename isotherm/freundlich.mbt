///|
/// Freundlich model parameters.
/// q = K_F * C^(1/n)
pub(all) struct FreundlichParams {
  k_f : Double
  n : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Fits Freundlich parameters using linear regression on ln(q) = ln(K_F) + (1/n) * ln(C)
pub fn fit_freundlich(data : Array[AdsorptionData]) -> FreundlichParams {
  let points = []
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let x = @math.ln(d.c)
      let y = @math.ln(d.q)
      points.push(@utils.Point::{ x, y })
    }
  }
  let reg = @utils.linear_regression(points)
  let n = if reg.slope != 0.0 { 1.0 / reg.slope } else { 0.0 }
  let k_f = @math.exp(reg.intercept)
  { k_f, n, r_squared: reg.r_squared }
}

///|
/// Predicts the adsorption capacity (q) for a given concentration (c) using the Freundlich model.
pub fn predict_freundlich(params : FreundlichParams, c : Double) -> Double {
  if c <= 0.0 {
    0.0
  } else {
    params.k_f * @math.pow(c, 1.0 / params.n)
  }
}
