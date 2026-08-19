///|
/// Extended equilibrium, temperature, and mixture models for practical adsorption analysis.
pub struct ThermodynamicPoint {
  temperature : Double
  capacity : Double
  pressure : Double
}

///|
pub struct ThermodynamicFit {
  reference_capacity : Double
  enthalpy : Double
  entropy : Double
  gibbs_energy : Double
  r_squared : Double
}

///|
pub struct MixtureComponent {
  name : String
  concentration : Double
  capacity : Double
  affinity : Double
  exponent : Double
}

///|
pub struct MixtureLoading {
  loadings : Array[Double]
  total_loading : Double
  selectivities : Array[Double]
  saturation_fraction : Double
}

///|
pub struct BatchEquilibrium {
  initial_concentrations : Array[Double]
  final_concentrations : Array[Double]
  loadings : Array[Double]
  removed_mass : Array[Double]
  closure_error : Double
  converged : Bool
  iterations : Int
}

///|
pub fn thermodynamic_point(
  temperature : Double,
  capacity : Double,
  pressure : Double,
) -> ThermodynamicPoint {
  { temperature, capacity, pressure }
}

///|
pub fn predict_henry(coefficient : Double, concentration : Double) -> Double {
  if concentration <= 0.0 || coefficient <= 0.0 {
    0.0
  } else {
    coefficient * concentration
  }
}

///|
pub fn predict_hill(
  q_max : Double,
  affinity : Double,
  exponent : Double,
  concentration : Double,
) -> Double {
  if q_max <= 0.0 || affinity <= 0.0 || exponent <= 0.0 || concentration <= 0.0 {
    0.0
  } else {
    let numerator = q_max * @math.pow(affinity * concentration, exponent)
    numerator / (1.0 + @math.pow(affinity * concentration, exponent))
  }
}

///|
pub fn predict_fowler_guggenheim(
  q_max : Double,
  affinity : Double,
  interaction : Double,
  concentration : Double,
  iterations : Int,
) -> Double {
  if q_max <= 0.0 || affinity <= 0.0 || concentration <= 0.0 {
    return 0.0
  }
  let mut coverage = 0.5
  let limit = if iterations <= 0 { 100 } else { iterations }
  for _ in 0..<limit {
    let exponent = @math.exp(interaction * coverage)
    let next = affinity *
      concentration *
      exponent /
      (1.0 + affinity * concentration * exponent)
    coverage = 0.5 * coverage + 0.5 * next
  }
  q_max * @utils.clamp(coverage, 0.0, 1.0)
}

///|
pub fn predict_dual_site(
  q_first : Double,
  affinity_first : Double,
  q_second : Double,
  affinity_second : Double,
  concentration : Double,
) -> Double {
  predict_langmuir(
    { q_m: q_first, k_l: affinity_first, r_squared: 1.0 },
    concentration,
  ) +
  predict_langmuir(
    { q_m: q_second, k_l: affinity_second, r_squared: 1.0 },
    concentration,
  )
}

///|
pub fn predict_langmuir_freundlich(
  q_max : Double,
  affinity : Double,
  exponent : Double,
  concentration : Double,
) -> Double {
  if q_max <= 0.0 || affinity <= 0.0 || concentration <= 0.0 {
    0.0
  } else {
    let term = @math.pow(affinity * concentration, exponent)
    q_max * term / (1.0 + term)
  }
}

///|
pub fn predict_redlich_peterson_extended(
  coefficient : Double,
  affinity : Double,
  exponent : Double,
  concentration : Double,
) -> Double {
  if coefficient <= 0.0 || concentration <= 0.0 {
    0.0
  } else {
    let denominator = 1.0 + affinity * @math.pow(concentration, exponent)
    coefficient * concentration / denominator
  }
}

///|
pub fn predict_henry_partition(
  coefficient : Double,
  concentration : Double,
  water_volume : Double,
  solid_mass : Double,
) -> Double {
  if solid_mass <= 0.0 {
    0.0
  } else {
    predict_henry(coefficient, concentration) * solid_mass / water_volume
  }
}

///|
pub fn temperature_corrected_affinity(
  reference_affinity : Double,
  enthalpy : Double,
  reference_temperature : Double,
  temperature : Double,
) -> Double {
  if reference_affinity <= 0.0 ||
    reference_temperature <= 0.0 ||
    temperature <= 0.0 {
    0.0
  } else {
    let gas_constant = 8.314462618
    reference_affinity *
    @math.exp(
      -enthalpy /
      gas_constant *
      (1.0 / temperature - 1.0 / reference_temperature),
    )
  }
}

///|
pub fn temperature_corrected_capacity(
  reference_capacity : Double,
  heat_of_adsorption : Double,
  reference_temperature : Double,
  temperature : Double,
) -> Double {
  if reference_capacity <= 0.0 ||
    reference_temperature <= 0.0 ||
    temperature <= 0.0 {
    0.0
  } else {
    reference_capacity *
    @math.exp(
      -heat_of_adsorption /
      8.314462618 *
      (1.0 / temperature - 1.0 / reference_temperature),
    )
  }
}

///|
pub fn van_t_hoff_slope(points : Array[ThermodynamicPoint]) -> ThermodynamicFit {
  if points.length() < 2 {
    return {
      reference_capacity: 0.0,
      enthalpy: 0.0,
      entropy: 0.0,
      gibbs_energy: 0.0,
      r_squared: 0.0,
    }
  }
  let x : Array[Double] = []
  let y : Array[Double] = []
  for point in points {
    if point.temperature > 0.0 && point.capacity > 0.0 {
      x.push(1.0 / point.temperature)
      y.push(@math.ln(point.capacity))
    }
  }
  let fit = @utils.fit_weighted_linear(x, y, [])
  let slope = if fit.coefficients.length() > 0 {
    fit.coefficients[0]
  } else {
    0.0
  }
  let intercept = if fit.coefficients.length() > 1 {
    fit.coefficients[1]
  } else {
    0.0
  }
  let enthalpy = -slope * 8.314462618
  let entropy = intercept * 8.314462618
  let temperature = points[0].temperature
  let gibbs = enthalpy - temperature * entropy
  let predicted : Array[Double] = []
  for item in x {
    predicted.push(@math.exp(intercept + slope * item))
  }
  let mut total = 0.0
  let mean = @utils.signal_mean(y)
  let mut residual = 0.0
  for i in 0..<y.length() {
    total = total + (y[i] - mean) * (y[i] - mean)
    residual = residual +
      (y[i] - @math.ln(predicted[i])) * (y[i] - @math.ln(predicted[i]))
  }
  {
    reference_capacity: @math.exp(intercept),
    enthalpy,
    entropy,
    gibbs_energy: gibbs,
    r_squared: if total == 0.0 {
      1.0
    } else {
      1.0 - residual / total
    },
  }
}

///|
pub fn gibbs_free_energy(
  enthalpy : Double,
  entropy : Double,
  temperature : Double,
) -> Double {
  enthalpy - temperature * entropy
}

///|
pub fn entropy_from_partition(
  coefficient : Double,
  temperature : Double,
) -> Double {
  if coefficient <= 0.0 || temperature <= 0.0 {
    0.0
  } else {
    8.314462618 * @math.ln(coefficient)
  }
}

///|
pub fn isosteric_heat(
  first : ThermodynamicPoint,
  second : ThermodynamicPoint,
) -> Double {
  if first.temperature <= 0.0 ||
    second.temperature <= 0.0 ||
    first.capacity <= 0.0 ||
    second.capacity <= 0.0 ||
    first.temperature == second.temperature {
    0.0
  } else {
    -8.314462618 *
    (@math.ln(second.capacity) - @math.ln(first.capacity)) /
    (1.0 / second.temperature - 1.0 / first.temperature)
  }
}

///|
pub fn mixture_component(
  name : String,
  concentration : Double,
  capacity : Double,
  affinity : Double,
  exponent : Double,
) -> MixtureComponent {
  {
    name,
    concentration,
    capacity,
    affinity,
    exponent: if exponent <= 0.0 {
      1.0
    } else {
      exponent
    },
  }
}

///|
pub fn competitive_langmuir_loading(
  components : Array[MixtureComponent],
) -> MixtureLoading {
  let mut total_capacity = 0.0
  for component in components {
    total_capacity = total_capacity + component.capacity
  }
  let mut denominator_value = 1.0
  for component in components {
    denominator_value = denominator_value +
      component.affinity * component.concentration
  }
  let loadings = Array::make(components.length(), 0.0)
  let selectivities = Array::make(components.length(), 0.0)
  let mut total = 0.0
  for i in 0..<components.length() {
    let component = components[i]
    loadings[i] = if denominator_value == 0.0 {
      0.0
    } else {
      component.capacity *
      component.affinity *
      component.concentration /
      denominator_value
    }
    total = total + loadings[i]
  }
  for i in 0..<components.length() {
    selectivities[i] = if total - loadings[i] == 0.0 {
      0.0
    } else {
      loadings[i] / (total - loadings[i])
    }
  }
  {
    loadings,
    total_loading: total,
    selectivities,
    saturation_fraction: if total_capacity == 0.0 {
      0.0
    } else {
      total / total_capacity
    },
  }
}

///|
pub fn competitive_sips_loading(
  components : Array[MixtureComponent],
) -> MixtureLoading {
  let denominator_terms = Array::make(components.length(), 0.0)
  let mut denominator = 1.0
  for i in 0..<components.length() {
    let component = components[i]
    denominator_terms[i] = @math.pow(
      component.affinity * component.concentration,
      component.exponent,
    )
    denominator = denominator + denominator_terms[i]
  }
  let loadings = Array::make(components.length(), 0.0)
  let selectivities = Array::make(components.length(), 0.0)
  let mut total = 0.0
  let mut capacity = 0.0
  for component in components {
    capacity = capacity + component.capacity
  }
  for i in 0..<components.length() {
    loadings[i] = components[i].capacity * denominator_terms[i] / denominator
    total = total + loadings[i]
  }
  for i in 0..<components.length() {
    selectivities[i] = if total == 0.0 { 0.0 } else { loadings[i] / total }
  }
  {
    loadings,
    total_loading: total,
    selectivities,
    saturation_fraction: if capacity == 0.0 {
      0.0
    } else {
      total / capacity
    },
  }
}

///|
pub fn mixture_selectivity(
  loading : MixtureLoading,
  first : Int,
  second : Int,
) -> Double {
  if first < 0 ||
    second < 0 ||
    first >= loading.loadings.length() ||
    second >= loading.loadings.length() ||
    loading.loadings[second] == 0.0 {
    0.0
  } else {
    loading.loadings[first] / loading.loadings[second]
  }
}

///|
pub fn mixture_normalized_loadings(loading : MixtureLoading) -> Array[Double] {
  let result = Array::make(loading.loadings.length(), 0.0)
  for i in 0..<result.length() {
    result[i] = if loading.total_loading == 0.0 {
      0.0
    } else {
      loading.loadings[i] / loading.total_loading
    }
  }
  result
}

///|
pub fn batch_equilibrium(
  initial_concentrations : Array[Double],
  water_volume : Double,
  solid_mass : Double,
  capacity : (Int, Double, Array[Double]) -> Double,
  tolerance : Double,
  maximum_iterations : Int,
) -> BatchEquilibrium {
  let final_concentrations = initial_concentrations.copy()
  let loadings = Array::make(initial_concentrations.length(), 0.0)
  let removed = Array::make(initial_concentrations.length(), 0.0)
  let limit = if maximum_iterations <= 0 { 1000 } else { maximum_iterations }
  let tol = if tolerance <= 0.0 { 1.0e-8 } else { tolerance }
  let mut converged = false
  let mut iteration = 0
  while iteration < limit && !converged {
    let previous = final_concentrations.copy()
    for i in 0..<initial_concentrations.length() {
      let q = capacity(i, final_concentrations[i], final_concentrations)
      loadings[i] = if q < 0.0 { 0.0 } else { q }
      let available = initial_concentrations[i] * water_volume / solid_mass
      let target = initial_concentrations[i] -
        loadings[i] * solid_mass / water_volume
      final_concentrations[i] = @utils.clamp(
        target,
        0.0,
        initial_concentrations[i],
      )
      removed[i] = (initial_concentrations[i] - final_concentrations[i]) *
        water_volume
      if loadings[i] > available {
        loadings[i] = available
      }
    }
    converged = @utils.vector_distance(previous, final_concentrations) <= tol
    iteration = iteration + 1
  }
  let mut closure = 0.0
  for i in 0..<initial_concentrations.length() {
    closure = closure +
      (initial_concentrations[i] - final_concentrations[i]) * water_volume -
      removed[i]
  }
  {
    initial_concentrations,
    final_concentrations,
    loadings,
    removed_mass: removed,
    closure_error: closure.abs(),
    converged,
    iterations: iteration,
  }
}

///|
pub fn batch_single_component(
  initial_concentration : Double,
  water_volume : Double,
  solid_mass : Double,
  isotherm : (Double) -> Double,
  tolerance : Double,
) -> BatchEquilibrium {
  batch_equilibrium(
    [initial_concentration],
    water_volume,
    solid_mass,
    fn(_index, concentration, _mixture) { isotherm(concentration) },
    tolerance,
    1000,
  )
}

///|
pub fn batch_loading_fraction(
  result : BatchEquilibrium,
  capacities : Array[Double],
) -> Array[Double] {
  let output = Array::make(result.loadings.length(), 0.0)
  for i in 0..<output.length() {
    output[i] = if i < capacities.length() && capacities[i] != 0.0 {
      result.loadings[i] / capacities[i]
    } else {
      0.0
    }
  }
  output
}
