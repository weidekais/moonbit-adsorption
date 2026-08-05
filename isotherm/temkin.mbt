///|
/// Temkin model parameters.
/// q = B * ln(A_T * C) = B * ln(A_T) + B * ln(C)
pub(all) struct TemkinParams {
  a_t : Double
  b : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Fits Temkin parameters using Non-linear Least Squares (NLLS) optimization,
/// with the linearized regression parameters as the initial guess.
pub fn fit_temkin(data : Array[AdsorptionData]) -> TemkinParams {
  // 1. Get initial guess via linear regression
  let points = []
  let mut sum_q = 0.0
  let mut count = 0
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let x = @math.ln(d.c)
      let y = d.q
      points.push(@utils.Point::{ x, y })
      sum_q = sum_q + d.q
      count = count + 1
    }
  }

  if count < 2 {
    return { a_t: 0.0, b: 0.0, r_squared: 0.0 }
  }

  let mean_q = sum_q / count.to_double()
  let reg = @utils.linear_regression(points)
  let b_guess = reg.slope
  let a_t_guess = if b_guess != 0.0 {
    @math.exp(reg.intercept / b_guess)
  } else {
    1.0
  }

  // Adjust guess if negative/invalid
  let init_guess = [
    if a_t_guess > 0.0 {
      a_t_guess
    } else {
      1.0
    },
    if b_guess > 0.0 {
      b_guess
    } else {
      1.0
    },
  ]

  // 2. Define objective function for NLLS: Sum of Squared Residuals
  let obj = fn(params : Array[Double]) -> Double {
    let a_t = params[0]
    let b = params[1]
    if a_t <= 0.0 || b <= 0.0 {
      return 1.0e30 // Large penalty for invalid parameters
    }
    let mut ss = 0.0
    for d in data {
      if d.c > 0.0 && d.q > 0.0 {
        let pred = b * @math.ln(a_t * d.c)
        let diff = d.q - pred
        ss = ss + diff * diff
      }
    }
    ss
  }

  // 3. Optimize parameters
  let opt = @utils.nelder_mead(obj, init_guess, 1.0e-8, 1000)
  let a_t = opt[0]
  let b = opt[1]

  // 4. Calculate final R-squared in non-linear space
  let mut ss_tot = 0.0
  let mut ss_res = 0.0
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let pred = b * @math.ln(a_t * d.c)
      let d_tot = d.q - mean_q
      ss_tot = ss_tot + d_tot * d_tot
      let d_res = d.q - pred
      ss_res = ss_res + d_res * d_res
    }
  }

  let r_squared = if ss_tot == 0.0 { 1.0 } else { 1.0 - ss_res / ss_tot }

  { a_t, b, r_squared }
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
