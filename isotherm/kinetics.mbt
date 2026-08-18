///|
/// A time-capacity observation for batch adsorption kinetics.
pub(all) struct KineticData {
  time : Double
  q : Double
} derive(Debug, Eq)

///|
pub(all) struct PseudoFirstOrderParams {
  q_e : Double
  k_1 : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub(all) struct PseudoSecondOrderParams {
  q_e : Double
  k_2 : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub(all) struct ElovichParams {
  alpha : Double
  beta : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub(all) struct IntraparticleParams {
  k_p : Double
  intercept : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub fn predict_pseudo_first_order(
  params : PseudoFirstOrderParams,
  time : Double,
) -> Double {
  if time <= 0.0 || params.q_e <= 0.0 || params.k_1 <= 0.0 {
    0.0
  } else {
    params.q_e * (1.0 - @math.exp(-params.k_1 * time))
  }
}

///|
pub fn predict_pseudo_second_order(
  params : PseudoSecondOrderParams,
  time : Double,
) -> Double {
  if time <= 0.0 || params.q_e <= 0.0 || params.k_2 <= 0.0 {
    0.0
  } else {
    let denominator = 1.0 + params.k_2 * params.q_e * time
    params.k_2 * params.q_e * params.q_e * time / denominator
  }
}

///|
pub fn predict_elovich(params : ElovichParams, time : Double) -> Double {
  if time <= 0.0 || params.alpha <= 0.0 || params.beta <= 0.0 {
    0.0
  } else {
    @math.ln(1.0 + params.alpha * params.beta * time) / params.beta
  }
}

///|
pub fn predict_intraparticle(
  params : IntraparticleParams,
  time : Double,
) -> Double {
  if time < 0.0 {
    params.intercept
  } else {
    params.k_p * time.sqrt() + params.intercept
  }
}

///|
fn kinetic_score(
  data : Array[KineticData],
  predictor : (Double) -> Double,
) -> Double {
  let actual = []
  let estimate = []
  for point in data {
    if point.time >= 0.0 {
      actual.push(point.q)
      estimate.push(predictor(point.time))
    }
  }
  @utils.r_squared(actual, estimate)
}

///|
pub fn fit_pseudo_first_order(
  data : Array[KineticData],
) -> PseudoFirstOrderParams {
  let objective = fn(p : Array[Double]) -> Double {
    if p[0] <= 0.0 || p[1] <= 0.0 {
      return 1.0e30
    }
    let mut score = 0.0
    for point in data {
      if point.time >= 0.0 {
        let e = point.q -
          predict_pseudo_first_order(
            { q_e: p[0], k_1: p[1], r_squared: 0.0 },
            point.time,
          )
        score = score + e * e
      }
    }
    score
  }
  let opt = @utils.nelder_mead(objective, [1.0, 0.1], 1.0e-9, 1800)
  {
    q_e: opt[0],
    k_1: opt[1],
    r_squared: kinetic_score(data, fn(t) {
      predict_pseudo_first_order(
        { q_e: opt[0], k_1: opt[1], r_squared: 0.0 },
        t,
      )
    }),
  }
}

///|
pub fn fit_pseudo_second_order(
  data : Array[KineticData],
) -> PseudoSecondOrderParams {
  let objective = fn(p : Array[Double]) -> Double {
    if p[0] <= 0.0 || p[1] <= 0.0 {
      return 1.0e30
    }
    let mut score = 0.0
    for point in data {
      if point.time >= 0.0 {
        let e = point.q -
          predict_pseudo_second_order(
            { q_e: p[0], k_2: p[1], r_squared: 0.0 },
            point.time,
          )
        score = score + e * e
      }
    }
    score
  }
  let opt = @utils.nelder_mead(objective, [1.0, 0.1], 1.0e-9, 1800)
  {
    q_e: opt[0],
    k_2: opt[1],
    r_squared: kinetic_score(data, fn(t) {
      predict_pseudo_second_order(
        { q_e: opt[0], k_2: opt[1], r_squared: 0.0 },
        t,
      )
    }),
  }
}

///|
pub fn fit_elovich(data : Array[KineticData]) -> ElovichParams {
  let objective = fn(p : Array[Double]) -> Double {
    if p[0] <= 0.0 || p[1] <= 0.0 {
      return 1.0e30
    }
    let mut score = 0.0
    for point in data {
      if point.time >= 0.0 {
        let e = point.q -
          predict_elovich(
            { alpha: p[0], beta: p[1], r_squared: 0.0 },
            point.time,
          )
        score = score + e * e
      }
    }
    score
  }
  let opt = @utils.nelder_mead(objective, [1.0, 0.1], 1.0e-9, 1800)
  {
    alpha: opt[0],
    beta: opt[1],
    r_squared: kinetic_score(data, fn(t) {
      predict_elovich({ alpha: opt[0], beta: opt[1], r_squared: 0.0 }, t)
    }),
  }
}

///|
pub fn fit_intraparticle(data : Array[KineticData]) -> IntraparticleParams {
  let points = []
  for point in data {
    if point.time >= 0.0 {
      points.push(@utils.Point::{ x: point.time.sqrt(), y: point.q })
    }
  }
  if points.length() < 2 {
    return { k_p: 0.0, intercept: 0.0, r_squared: 0.0 }
  }
  let line = @utils.linear_regression(points)
  { k_p: line.slope, intercept: line.intercept, r_squared: line.r_squared }
}

///|
pub fn initial_rate_pseudo_second_order(
  params : PseudoSecondOrderParams,
) -> Double {
  params.k_2 * params.q_e * params.q_e
}

///|
pub fn half_time_pseudo_first_order(params : PseudoFirstOrderParams) -> Double {
  if params.k_1 <= 0.0 {
    0.0
  } else {
    @math.ln(2.0) / params.k_1
  }
}

///|
pub fn half_time_pseudo_second_order(
  params : PseudoSecondOrderParams,
) -> Double {
  if params.k_2 <= 0.0 || params.q_e <= 0.0 {
    0.0
  } else {
    1.0 / (params.k_2 * params.q_e)
  }
}

///|
pub fn kinetic_conversion(
  data : Array[KineticData],
  mass : Double,
  volume : Double,
) -> Array[Double] {
  let result = Array::make(data.length(), 0.0)
  if mass <= 0.0 || volume <= 0.0 {
    return result
  }
  for i in 0..<data.length() {
    result[i] = data[i].q * mass / volume
  }
  result
}
