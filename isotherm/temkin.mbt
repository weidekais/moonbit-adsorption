///|
/// Temkin model parameters.
/// q = B * ln(A_T * C) = B * ln(A_T) + B * ln(C)
pub(all) struct TemkinParams {
  a_t : Double
  b : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Fits Temkin parameters using linear regression on q = B * ln(A_T) + B * ln(C)
pub fn fit_temkin(data : Array[AdsorptionData]) -> TemkinParams {
  let points = []
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let x = @math.ln(d.c)
      let y = d.q
      points.push(@utils.Point::{ x, y })
    }
  }
  let reg = @utils.linear_regression(points)
  let b = reg.slope
  let a_t = if b != 0.0 { @math.exp(reg.intercept / b) } else { 0.0 }
  { a_t, b, r_squared: reg.r_squared }
}

///|
/// Predicts the adsorption capacity (q) for a given concentration (c) using the Temkin model.
pub fn predict_temkin(params : TemkinParams, c : Double) -> Double {
  if c <= 0.0 {
    0.0
  } else {
    params.b * @math.ln(params.a_t * c)
  }
}
