///|
/// Freundlich model parameters.
/// q = K_F * C^(1/n)
pub(all) struct FreundlichParams {
  k_f : Double
  n : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Fits Freundlich parameters using Non-linear Least Squares (NLLS) optimization,
/// with the linearized regression parameters as the initial guess.
pub fn fit_freundlich(data : Array[AdsorptionData]) -> FreundlichParams {
  // 1. Get initial guess via linear regression
  let points = []
  let mut sum_q = 0.0
  let mut count = 0
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let x = @math.ln(d.c)
      let y = @math.ln(d.q)
      points.push(@utils.Point::{ x, y })
      sum_q = sum_q + d.q
      count = count + 1
    }
  }

  if count < 2 {
    return { k_f: 0.0, n: 0.0, r_squared: 0.0 }
  }

  let mean_q = sum_q / count.to_double()
  let reg = @utils.linear_regression(points)
  let n_guess = if reg.slope != 0.0 { 1.0 / reg.slope } else { 1.0 }
  let k_f_guess = @math.exp(reg.intercept)

  // Adjust guess if negative/invalid
  let init_guess = [
    if k_f_guess > 0.0 {
      k_f_guess
    } else {
      1.0
    },
    if n_guess > 0.0 {
      n_guess
    } else {
      1.0
    },
  ]

  // 2. Define objective function for NLLS: Sum of Squared Residuals
  let obj = fn(params : Array[Double]) -> Double {
    let k_f = params[0]
    let n = params[1]
    if k_f <= 0.0 || n <= 0.0 {
      return 1.0e30 // Large penalty for invalid parameters
    }
    let mut ss = 0.0
    for d in data {
      if d.c > 0.0 && d.q > 0.0 {
        let pred = k_f * @math.pow(d.c, 1.0 / n)
        let diff = d.q - pred
        ss = ss + diff * diff
      }
    }
    ss
  }

  // 3. Optimize parameters
  let opt = @utils.nelder_mead(obj, init_guess, 1.0e-8, 1000)
  let k_f = opt[0]
  let n = opt[1]

  // 4. Calculate final R-squared in non-linear space
  let mut ss_tot = 0.0
  let mut ss_res = 0.0
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let pred = k_f * @math.pow(d.c, 1.0 / n)
      let d_tot = d.q - mean_q
      ss_tot = ss_tot + d_tot * d_tot
      let d_res = d.q - pred
      ss_res = ss_res + d_res * d_res
    }
  }

  let r_squared = if ss_tot == 0.0 { 1.0 } else { 1.0 - ss_res / ss_tot }

  { k_f, n, r_squared }
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
