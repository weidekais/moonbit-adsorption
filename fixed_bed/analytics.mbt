///|
/// Summary metrics for breakthrough experiments.
pub(all) struct BreakthroughMetrics {
  c0 : Double
  c5_time : Double
  c10_time : Double
  c50_time : Double
  c90_time : Double
  area : Double
  treated_volume : Double
  removal_capacity : Double
} derive(Debug, Eq)

///|
pub fn ratio_at(point : BreakthroughPoint) -> Double {
  point.outlet_ratio
}

///|
pub fn interpolate_time(
  curve : Array[BreakthroughPoint],
  ratio : Double,
) -> Double {
  if curve.length() == 0 {
    return 0.0
  }
  if ratio <= curve[0].outlet_ratio {
    return curve[0].time
  }
  for i in 1..<curve.length() {
    let left = curve[i - 1]
    let right = curve[i]
    if right.outlet_ratio >= ratio {
      let span = right.outlet_ratio - left.outlet_ratio
      if span == 0.0 {
        return right.time
      }
      return left.time +
        (ratio - left.outlet_ratio) * (right.time - left.time) / span
    }
  }
  curve[curve.length() - 1].time
}

///|
pub fn breakthrough_area(curve : Array[BreakthroughPoint]) -> Double {
  if curve.length() < 2 {
    return 0.0
  }
  let mut area = 0.0
  for i in 1..<curve.length() {
    area = area +
      0.5 *
      (curve[i].time - curve[i - 1].time) *
      (curve[i].outlet_ratio + curve[i - 1].outlet_ratio)
  }
  area
}

///|
pub fn removal_area(curve : Array[BreakthroughPoint]) -> Double {
  if curve.length() < 2 {
    return 0.0
  }
  let mut area = 0.0
  for i in 1..<curve.length() {
    let left = 1.0 - curve[i - 1].outlet_ratio
    let right = 1.0 - curve[i].outlet_ratio
    area = area + 0.5 * (curve[i].time - curve[i - 1].time) * (left + right)
  }
  area
}

///|
pub fn summarize_breakthrough(
  curve : Array[BreakthroughPoint],
  feed : Double,
  flow : Double,
) -> BreakthroughMetrics {
  let c5 = interpolate_time(curve, 0.05)
  let c10 = interpolate_time(curve, 0.10)
  let c50 = interpolate_time(curve, 0.50)
  let c90 = interpolate_time(curve, 0.90)
  let volume = if curve.length() == 0 {
    0.0
  } else {
    flow * curve[curve.length() - 1].time
  }
  {
    c0: feed,
    c5_time: c5,
    c10_time: c10,
    c50_time: c50,
    c90_time: c90,
    area: breakthrough_area(curve),
    treated_volume: volume,
    removal_capacity: feed * flow * removal_area(curve),
  }
}

///|
pub(all) struct ThomasParams {
  k_th : Double
  q0 : Double
  mass : Double
  flow : Double
  c0 : Double
} derive(Debug, Eq)

///|
pub fn thomas_ratio(params : ThomasParams, time : Double) -> Double {
  calculate_thomas_breakthrough(
    time,
    params.k_th,
    params.q0,
    params.mass,
    params.flow,
    params.c0,
  )
}

///|
pub fn yoon_nelson_ratio(tau : Double, k_yn : Double, time : Double) -> Double {
  if k_yn <= 0.0 {
    return 0.0
  }
  1.0 / (1.0 + @math.exp(k_yn * (tau - time)))
}

///|
pub fn yoon_nelson_time(ratio : Double, tau : Double, k_yn : Double) -> Double {
  if ratio <= 0.0 || ratio >= 1.0 || k_yn <= 0.0 {
    0.0
  } else {
    tau - @math.ln(1.0 / ratio - 1.0) / k_yn
  }
}

///|
pub(all) struct BdSTransform {
  capacity : Double
  rate : Double
  intercept : Double
} derive(Debug, Eq)

///|
pub fn bdst_capacity(
  bed_depth : Double,
  breakthrough_time : Double,
  concentration : Double,
  flow : Double,
) -> Double {
  if bed_depth <= 0.0 ||
    breakthrough_time <= 0.0 ||
    concentration <= 0.0 ||
    flow <= 0.0 {
    0.0
  } else {
    concentration * flow * breakthrough_time / bed_depth
  }
}

///|
pub fn bdst_time(
  bed_depth : Double,
  critical_depth : Double,
  rate : Double,
  concentration : Double,
  flow : Double,
) -> Double {
  if rate <= 0.0 || concentration <= 0.0 || flow <= 0.0 {
    0.0
  } else {
    (bed_depth - critical_depth) / rate +
    concentration * flow * critical_depth / (rate * concentration * flow)
  }
}

///|
pub fn clark_ratio(
  time : Double,
  k : Double,
  n : Double,
  tau : Double,
) -> Double {
  if time < 0.0 || k <= 0.0 || n <= 0.0 {
    0.0
  } else {
    let x = @math.exp(k * (tau - time))
    1.0 / @math.pow(1.0 + x, 1.0 / n)
  }
}

///|
pub fn clark_time(
  ratio : Double,
  k : Double,
  n : Double,
  tau : Double,
) -> Double {
  if ratio <= 0.0 || ratio >= 1.0 || k <= 0.0 || n <= 0.0 {
    0.0
  } else {
    tau - @math.ln(@math.pow(1.0 / ratio, n) - 1.0) / k
  }
}

///|
pub fn hydraulic_residence_time(length : Double, velocity : Double) -> Double {
  if length <= 0.0 || velocity <= 0.0 {
    0.0
  } else {
    length / velocity
  }
}

///|
pub fn empty_bed_contact_time(
  length : Double,
  porosity : Double,
  velocity : Double,
) -> Double {
  if length <= 0.0 || porosity <= 0.0 || velocity <= 0.0 {
    0.0
  } else {
    length * porosity / velocity
  }
}

///|
pub fn mass_balance_capacity(
  feed : Double,
  outlet : Double,
  flow : Double,
  duration : Double,
  adsorbent_mass : Double,
) -> Double {
  if adsorbent_mass <= 0.0 || flow < 0.0 || duration < 0.0 {
    0.0
  } else {
    (feed - outlet) * flow * duration / adsorbent_mass
  }
}

///|
pub fn breakthrough_width(
  curve : Array[BreakthroughPoint],
  lower : Double,
  upper : Double,
) -> Double {
  if lower >= upper {
    0.0
  } else {
    interpolate_time(curve, upper) - interpolate_time(curve, lower)
  }
}

///|
pub fn normalized_curve(
  curve : Array[BreakthroughPoint],
  c0 : Double,
) -> Array[BreakthroughPoint] {
  let result = Array::make(curve.length(), {
    time: 0.0,
    outlet_concentration: 0.0,
    outlet_ratio: 0.0,
  })
  for i in 0..<curve.length() {
    let point = curve[i]
    let ratio = if c0 == 0.0 { 0.0 } else { point.outlet_concentration / c0 }
    result[i] = {
      time: point.time,
      outlet_concentration: point.outlet_concentration,
      outlet_ratio: ratio,
    }
  }
  result
}

///|
pub fn monotonic_breakthrough(curve : Array[BreakthroughPoint]) -> Bool {
  if curve.length() < 2 {
    true
  } else {
    let mut ok = true
    for i in 1..<curve.length() {
      if curve[i].outlet_ratio < curve[i - 1].outlet_ratio {
        ok = false
      }
    }
    ok
  }
}

///|
pub fn breakthrough_time(
  curve : Array[BreakthroughPoint],
  threshold : Double,
) -> Double {
  interpolate_time(curve, threshold)
}
