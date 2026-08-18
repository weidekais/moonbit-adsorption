///|
/// Sips (Langmuir-Freundlich) isotherm parameters.
pub(all) struct SipsParams {
  q_m : Double
  k_s : Double
  n_s : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Toth isotherm parameters.
pub(all) struct TothParams {
  q_m : Double
  k_t : Double
  n_t : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// Redlich-Peterson isotherm parameters.
pub(all) struct RedlichPetersonParams {
  a : Double
  b : Double
  g : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub fn predict_sips(params : SipsParams, c : Double) -> Double {
  if c <= 0.0 || params.q_m <= 0.0 || params.k_s <= 0.0 || params.n_s <= 0.0 {
    0.0
  } else {
    let x = @math.pow(params.k_s * c, params.n_s)
    params.q_m * x / (1.0 + x)
  }
}

///|
pub fn predict_toth(params : TothParams, c : Double) -> Double {
  if c <= 0.0 || params.q_m <= 0.0 || params.k_t <= 0.0 || params.n_t <= 0.0 {
    0.0
  } else {
    let x = @math.pow(params.k_t * c, params.n_t)
    params.q_m * params.k_t * c / @math.pow(1.0 + x, 1.0 / params.n_t)
  }
}

///|
pub fn predict_redlich_peterson(
  params : RedlichPetersonParams,
  c : Double,
) -> Double {
  if c <= 0.0 || params.a < 0.0 || params.b < 0.0 {
    0.0
  } else {
    let denominator = 1.0 + params.b * @math.pow(c, params.g)
    if denominator == 0.0 {
      0.0
    } else {
      params.a * c / denominator
    }
  }
}

///|
pub(all) struct BetParams {
  q_m : Double
  c_b : Double
  r_squared : Double
} derive(Debug, Eq)

///|
/// BET multilayer equation in its practical finite-domain form.
pub fn predict_bet(params : BetParams, relative_pressure : Double) -> Double {
  let p = relative_pressure
  if p <= 0.0 || p >= 1.0 || params.q_m <= 0.0 {
    0.0
  } else {
    params.q_m * params.c_b * p / ((1.0 - p) * (1.0 + (params.c_b - 1.0) * p))
  }
}

///|
pub(all) struct DubininRadushkevichParams {
  q_s : Double
  beta : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub fn predict_dubinin_radushkevich(
  params : DubininRadushkevichParams,
  c : Double,
  saturation : Double,
) -> Double {
  if c <= 0.0 || saturation <= c || params.q_s < 0.0 || params.beta < 0.0 {
    0.0
  } else {
    let energy = 8.314 * @math.ln(1.0 + saturation / c)
    params.q_s * @math.exp(-params.beta * energy * energy)
  }
}

///|
pub(all) struct HalseyParams {
  a : Double
  b : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub fn predict_halsey(
  params : HalseyParams,
  relative_pressure : Double,
) -> Double {
  if relative_pressure <= 0.0 || relative_pressure >= 1.0 {
    0.0
  } else {
    @math.exp((params.a - @math.ln(-@math.ln(relative_pressure))) / params.b)
  }
}

///|
pub(all) struct HarkinJuraParams {
  a : Double
  b : Double
  r_squared : Double
} derive(Debug, Eq)

///|
pub fn predict_harkin_jura(
  params : HarkinJuraParams,
  relative_pressure : Double,
) -> Double {
  if relative_pressure <= 0.0 || relative_pressure >= 1.0 || params.a == 0.0 {
    0.0
  } else {
    1.0 / (params.a - params.b * @math.log10(relative_pressure)).sqrt()
  }
}

///|
fn fit_two_parameter(
  data : Array[AdsorptionData],
  predictor : (Array[Double], Double) -> Double,
  initial : Array[Double],
) -> Array[Double] {
  let objective = fn(params : Array[Double]) -> Double {
    let mut score = 0.0
    for point in data {
      if point.c > 0.0 && point.q >= 0.0 {
        let error = point.q - predictor(params, point.c)
        score = score + error * error
      }
    }
    score
  }
  @utils.nelder_mead(objective, initial, 1.0e-9, 1600)
}

///|
fn fit_three_parameter(
  data : Array[AdsorptionData],
  predictor : (Array[Double], Double) -> Double,
  initial : Array[Double],
) -> Array[Double] {
  let objective = fn(params : Array[Double]) -> Double {
    let mut score = 0.0
    if params.length() < 3 {
      return 1.0e30
    }
    for point in data {
      if point.c > 0.0 && point.q >= 0.0 {
        let error = point.q - predictor(params, point.c)
        score = score + error * error
      }
    }
    score
  }
  @utils.nelder_mead(objective, initial, 1.0e-9, 2200)
}

///|
fn score_model(
  data : Array[AdsorptionData],
  predicted : (Double) -> Double,
) -> Double {
  let actual = []
  let estimate = []
  for point in data {
    if point.c > 0.0 {
      actual.push(point.q)
      estimate.push(predicted(point.c))
    }
  }
  @utils.r_squared(actual, estimate)
}

///|
pub fn fit_sips(data : Array[AdsorptionData]) -> SipsParams {
  let opt = fit_three_parameter(
    data,
    fn(p, c) {
      if p[0] <= 0.0 || p[1] <= 0.0 || p[2] <= 0.0 {
        1.0e15
      } else {
        let x = @math.pow(p[1] * c, p[2])
        p[0] * x / (1.0 + x)
      }
    },
    [10.0, 0.5, 1.0],
  )
  let params = {
    q_m: opt[0],
    k_s: opt[1],
    n_s: opt[2],
    r_squared: score_model(data, fn(c) {
      predict_sips({ q_m: opt[0], k_s: opt[1], n_s: opt[2], r_squared: 0.0 }, c)
    }),
  }
  params
}

///|
pub fn fit_toth(data : Array[AdsorptionData]) -> TothParams {
  let opt = fit_three_parameter(
    data,
    fn(p, c) {
      if p[0] <= 0.0 || p[1] <= 0.0 || p[2] <= 0.0 {
        1.0e15
      } else {
        p[0] * p[1] * c / @math.pow(1.0 + @math.pow(p[1] * c, p[2]), 1.0 / p[2])
      }
    },
    [10.0, 0.5, 1.0],
  )
  {
    q_m: opt[0],
    k_t: opt[1],
    n_t: opt[2],
    r_squared: score_model(data, fn(c) {
      predict_toth({ q_m: opt[0], k_t: opt[1], n_t: opt[2], r_squared: 0.0 }, c)
    }),
  }
}

///|
pub fn fit_redlich_peterson(
  data : Array[AdsorptionData],
) -> RedlichPetersonParams {
  let opt = fit_three_parameter(
    data,
    fn(p, c) {
      if p[0] < 0.0 || p[1] < 0.0 || p[2] <= 0.0 || p[2] > 1.0 {
        1.0e15
      } else {
        p[0] * c / (1.0 + p[1] * @math.pow(c, p[2]))
      }
    },
    [5.0, 0.5, 0.8],
  )
  {
    a: opt[0],
    b: opt[1],
    g: opt[2],
    r_squared: score_model(data, fn(c) {
      predict_redlich_peterson(
        { a: opt[0], b: opt[1], g: opt[2], r_squared: 0.0 },
        c,
      )
    }),
  }
}

///|
pub fn fit_bet(data : Array[AdsorptionData]) -> BetParams {
  let opt = fit_two_parameter(
    data,
    fn(p, c) { predict_bet({ q_m: p[0], c_b: p[1], r_squared: 0.0 }, c) },
    [1.0, 10.0],
  )
  {
    q_m: opt[0],
    c_b: opt[1],
    r_squared: score_model(data, fn(c) {
      predict_bet({ q_m: opt[0], c_b: opt[1], r_squared: 0.0 }, c)
    }),
  }
}

///|
pub fn fit_dubinin_radushkevich(
  data : Array[AdsorptionData],
  saturation : Double,
) -> DubininRadushkevichParams {
  let opt = fit_two_parameter(
    data,
    fn(p, c) {
      predict_dubinin_radushkevich(
        { q_s: p[0], beta: p[1], r_squared: 0.0 },
        c,
        saturation,
      )
    },
    [10.0, 0.001],
  )
  {
    q_s: opt[0],
    beta: opt[1],
    r_squared: score_model(data, fn(c) {
      predict_dubinin_radushkevich(
        { q_s: opt[0], beta: opt[1], r_squared: 0.0 },
        c,
        saturation,
      )
    }),
  }
}
