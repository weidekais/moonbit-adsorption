///|
/// Langmuir model parameters.
/// q = (q_m * k_l * C) / (1 + k_l * C)
pub(all) struct LangmuirParams {
  q_m : Double
  k_l : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Fits Langmuir parameters using Non-linear Least Squares (NLLS) optimization,
/// with the linearized regression parameters as the initial guess.
pub fn fit_langmuir(data : Array[AdsorptionData]) -> LangmuirParams {
  // 1. Get initial guess via linear regression
  let points = []
  let mut sum_q = 0.0
  let mut count = 0
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let x = d.c
      let y = d.c / d.q
      points.push(@utils.Point::{ x, y })
      sum_q = sum_q + d.q
      count = count + 1
    }
  }

  if count < 2 {
    return { q_m: 0.0, k_l: 0.0, r_squared: 0.0 }
  }

  let mean_q = sum_q / count.to_double()
  let reg = @utils.linear_regression(points)
  let q_m_guess = if reg.slope != 0.0 { 1.0 / reg.slope } else { 1.0 }
  let k_l_guess = if reg.intercept != 0.0 && q_m_guess != 0.0 {
    1.0 / (reg.intercept * q_m_guess)
  } else {
    1.0
  }

  // Adjust guess if negative
  let init_guess = [
    if q_m_guess > 0.0 {
      q_m_guess
    } else {
      1.0
    },
    if k_l_guess > 0.0 {
      k_l_guess
    } else {
      1.0
    },
  ]

  // 2. Define objective function for NLLS: Sum of Squared Residuals
  let obj = fn(params : Array[Double]) -> Double {
    let q_m = params[0]
    let k_l = params[1]
    if q_m <= 0.0 || k_l <= 0.0 {
      return 1.0e30 // Large penalty for invalid parameters
    }
    let mut ss = 0.0
    for d in data {
      if d.c > 0.0 && d.q > 0.0 {
        let pred = q_m * k_l * d.c / (1.0 + k_l * d.c)
        let diff = d.q - pred
        ss = ss + diff * diff
      }
    }
    ss
  }

  // 3. Optimize parameters
  let opt = @utils.nelder_mead(obj, init_guess, 1.0e-8, 1000)
  let q_m = opt[0]
  let k_l = opt[1]

  // 4. Calculate final R-squared in non-linear space
  let mut ss_tot = 0.0
  let mut ss_res = 0.0
  for d in data {
    if d.c > 0.0 && d.q > 0.0 {
      let pred = q_m * k_l * d.c / (1.0 + k_l * d.c)
      let d_tot = d.q - mean_q
      ss_tot = ss_tot + d_tot * d_tot
      let d_res = d.q - pred
      ss_res = ss_res + d_res * d_res
    }
  }

  let r_squared = if ss_tot == 0.0 { 1.0 } else { 1.0 - ss_res / ss_tot }

  { q_m, k_l, r_squared }
}

///|
/// Predicts the adsorption capacity (q) for a given concentration (c) using the Langmuir model.
pub fn predict_langmuir(params : LangmuirParams, c : Double) -> Double {
  if c <= 0.0 {
    0.0
  } else {
    params.q_m * params.k_l * c / (1.0 + params.k_l * c)
  }
}
