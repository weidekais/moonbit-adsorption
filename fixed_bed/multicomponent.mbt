///|
/// Multicomponent fixed-bed transport with shared mass-transfer and competition callbacks.
pub struct MultiColumnConfig {
  bed_length : Double
  velocity : Double
  porosity : Double
  bulk_density : Double
  ldf_coefficients : Array[Double]
  grid_points : Int
  time_step : Double
  total_time : Double
}

///|
pub struct MultiColumnResult {
  times : Array[Double]
  outlet_concentrations : Array[Array[Double]]
  final_concentration_profiles : Array[Array[Double]]
  final_adsorbed_profiles : Array[Array[Double]]
  mass_balance_errors : Array[Double]
  stable : Bool
}

///|
pub struct ComponentMetric {
  component : Int
  breakthrough_time : Double
  outlet_area : Double
  removed_mass : Double
  average_removal : Double
  mass_balance_error : Double
}

///|
pub struct MultiColumnState {
  concentration : Array[Double]
  adsorbed : Array[Double]
}

///|
pub fn multi_column_config(
  bed_length : Double,
  velocity : Double,
  porosity : Double,
  bulk_density : Double,
  ldf_coefficients : Array[Double],
  grid_points : Int,
  time_step : Double,
  total_time : Double,
) -> MultiColumnConfig {
  {
    bed_length,
    velocity,
    porosity,
    bulk_density,
    ldf_coefficients: ldf_coefficients.copy(),
    grid_points: if grid_points < 2 {
      2
    } else {
      grid_points
    },
    time_step: if time_step <= 0.0 {
      1.0e-3
    } else {
      time_step
    },
    total_time: if total_time <= 0.0 {
      1.0
    } else {
      total_time
    },
  }
}

///|
pub fn multi_column_state(species : Int, grid_points : Int) -> MultiColumnState {
  let species_count = if species < 0 { 0 } else { species }
  let grid_count = if grid_points < 0 { 0 } else { grid_points }
  let size = species_count * grid_count
  { concentration: Array::make(size, 0.0), adsorbed: Array::make(size, 0.0) }
}

///|
fn multi_index(component : Int, position : Int, grid_points : Int) -> Int {
  component * grid_points + position
}

///|
fn multi_copy_state(state : MultiColumnState) -> MultiColumnState {
  { concentration: state.concentration.copy(), adsorbed: state.adsorbed.copy() }
}

///|
pub fn multi_component_concentration(
  state : MultiColumnState,
  component : Int,
  position : Int,
  grid_points : Int,
) -> Double {
  let index = multi_index(component, position, grid_points)
  if index < 0 || index >= state.concentration.length() {
    0.0
  } else {
    state.concentration[index]
  }
}

///|
pub fn multi_component_loading(
  state : MultiColumnState,
  component : Int,
  position : Int,
  grid_points : Int,
) -> Double {
  let index = multi_index(component, position, grid_points)
  if index < 0 || index >= state.adsorbed.length() {
    0.0
  } else {
    state.adsorbed[index]
  }
}

///|
fn multi_update_state(
  state : MultiColumnState,
  config : MultiColumnConfig,
  species : Int,
  time : Double,
  equilibrium : (Int, Double, Array[Double]) -> Double,
  feed : (Int, Double) -> Double,
) -> MultiColumnState {
  let next = multi_copy_state(state)
  let n = config.grid_points
  let dz = if n <= 1 {
    config.bed_length
  } else {
    config.bed_length / (n - 1).to_double()
  }
  for component in 0..<species {
    let coefficient = if component < config.ldf_coefficients.length() {
      config.ldf_coefficients[component]
    } else {
      0.0
    }
    for position in 0..<n {
      let index = multi_index(component, position, n)
      let current = state.concentration[index]
      let current_loading = state.adsorbed[index]
      let mixture = Array::make(species, 0.0)
      for other in 0..<species {
        mixture[other] = state.concentration[multi_index(other, position, n)]
      }
      let target = equilibrium(component, current, mixture)
      let transfer = coefficient * (target - current_loading)
      let feed_value = feed(component, time)
      if position == 0 {
        next.concentration[index] = feed_value
        next.adsorbed[index] = current_loading + config.time_step * transfer
      } else {
        let upstream = state.concentration[multi_index(
            component,
            position - 1,
            n,
          )]
        let convection = if dz == 0.0 {
          0.0
        } else {
          -config.velocity * (current - upstream) / dz
        }
        let solid_transfer = if config.porosity == 0.0 {
          0.0
        } else {
          config.bulk_density / config.porosity * transfer
        }
        next.concentration[index] = current +
          config.time_step * (convection - solid_transfer)
        next.adsorbed[index] = current_loading + config.time_step * transfer
      }
      if next.concentration[index] < 0.0 {
        next.concentration[index] = 0.0
      }
      if next.adsorbed[index] < 0.0 {
        next.adsorbed[index] = 0.0
      }
    }
  }
  next
}

///|
pub fn simulate_multicomponent_column(
  config : MultiColumnConfig,
  species : Int,
  equilibrium : (Int, Double, Array[Double]) -> Double,
  feed : (Int, Double) -> Double,
) -> MultiColumnResult {
  let count = if species < 0 { 0 } else { species }
  let state = multi_column_state(count, config.grid_points)
  let times : Array[Double] = []
  let outlet : Array[Array[Double]] = []
  let balance = Array::make(count, 0.0)
  let steps = (config.total_time / config.time_step).to_int()
  let mut current = state
  let mut stable = true
  for step in 0..<steps {
    let time = step.to_double() * config.time_step
    let values = Array::make(count, 0.0)
    for component in 0..<count {
      values[component] = multi_component_concentration(
        current,
        component,
        config.grid_points - 1,
        config.grid_points,
      )
    }
    times.push(time)
    outlet.push(values)
    current = multi_update_state(
      current, config, count, time, equilibrium, feed,
    )
    for value in current.concentration {
      if value != value || value > 1.0e100 {
        stable = false
      }
    }
  }
  let final_concentration_profiles : Array[Array[Double]] = []
  let final_adsorbed_profiles : Array[Array[Double]] = []
  for component in 0..<count {
    let concentration = Array::make(config.grid_points, 0.0)
    let adsorbed = Array::make(config.grid_points, 0.0)
    for position in 0..<config.grid_points {
      concentration[position] = multi_component_concentration(
        current,
        component,
        position,
        config.grid_points,
      )
      adsorbed[position] = multi_component_loading(
        current,
        component,
        position,
        config.grid_points,
      )
    }
    final_concentration_profiles.push(concentration)
    final_adsorbed_profiles.push(adsorbed)
  }
  for component in 0..<count {
    let inlet_values = Array::make(times.length(), 0.0)
    let outlet_values = Array::make(times.length(), 0.0)
    for i in 0..<times.length() {
      inlet_values[i] = feed(component, times[i])
      outlet_values[i] = outlet[i][component]
    }
    let inlet_mass = @utils.interpolation_integral(times, inlet_values) *
      config.velocity
    let outlet_mass = @utils.interpolation_integral(times, outlet_values) *
      config.velocity
    let inventory = multi_profile_integral(
        final_adsorbed_profiles[component],
        config.bed_length,
      ) *
      config.bulk_density
    balance[component] = if inlet_mass.abs() <= 1.0e-30 {
      (outlet_mass + inventory).abs()
    } else {
      (inlet_mass - outlet_mass - inventory).abs() / inlet_mass.abs()
    }
  }
  {
    times,
    outlet_concentrations: outlet,
    final_concentration_profiles,
    final_adsorbed_profiles,
    mass_balance_errors: balance,
    stable,
  }
}

///|
pub fn multi_outlet_series(
  result : MultiColumnResult,
  component : Int,
) -> Array[Double] {
  let series : Array[Double] = []
  for values in result.outlet_concentrations {
    if component >= 0 && component < values.length() {
      series.push(values[component])
    }
  }
  series
}

///|
pub fn multi_outlet_ratio(
  result : MultiColumnResult,
  component : Int,
  influent : Double,
) -> Array[Double] {
  let values = multi_outlet_series(result, component)
  let result_values = Array::make(values.length(), 0.0)
  for i in 0..<values.length() {
    result_values[i] = if influent == 0.0 { 0.0 } else { values[i] / influent }
  }
  result_values
}

///|
pub fn multi_component_metric(
  result : MultiColumnResult,
  component : Int,
  influent : Double,
  flow_rate : Double,
  breakthrough_fraction : Double,
) -> ComponentMetric {
  let values = multi_outlet_series(result, component)
  let ratios = multi_outlet_ratio(result, component, influent)
  let breakthrough = @utils.signal_crossing_time(
    result.times,
    values,
    influent * breakthrough_fraction,
  )
  let area = @utils.interpolation_integral(result.times, values)
  let input = if result.times.length() < 2 {
    0.0
  } else {
    influent *
    flow_rate *
    (result.times[result.times.length() - 1] - result.times[0])
  }
  let output = area * flow_rate
  let removed = input - output
  let balance_error = if input.abs() <= 1.0e-30 {
    0.0
  } else {
    (input - output - removed).abs() / input.abs()
  }
  let mut average = 0.0
  for ratio in ratios {
    average = average + @utils.clamp(1.0 - ratio, 0.0, 1.0)
  }
  {
    component,
    breakthrough_time: breakthrough,
    outlet_area: area,
    removed_mass: removed,
    average_removal: if ratios.length() == 0 {
      0.0
    } else {
      average / ratios.length().to_double()
    },
    mass_balance_error: balance_error,
  }
}

///|
pub fn multi_component_metrics(
  result : MultiColumnResult,
  influents : Array[Double],
  flow_rate : Double,
  breakthrough_fraction : Double,
) -> Array[ComponentMetric] {
  let output : Array[ComponentMetric] = []
  for component in 0..<result.final_concentration_profiles.length() {
    let influent = if component < influents.length() {
      influents[component]
    } else {
      0.0
    }
    output.push(
      multi_component_metric(
        result, component, influent, flow_rate, breakthrough_fraction,
      ),
    )
  }
  output
}

///|
pub fn multi_total_removed(metrics : Array[ComponentMetric]) -> Double {
  let mut total = 0.0
  for metric in metrics {
    total = total + metric.removed_mass
  }
  total
}

///|
pub fn multi_selectivity(
  metrics : Array[ComponentMetric],
  first : Int,
  second : Int,
) -> Double {
  if first < 0 ||
    second < 0 ||
    first >= metrics.length() ||
    second >= metrics.length() ||
    metrics[second].removed_mass == 0.0 {
    0.0
  } else {
    metrics[first].removed_mass / metrics[second].removed_mass
  }
}

///|
pub fn multi_profile_average(profile : Array[Double]) -> Double {
  if profile.length() == 0 {
    return 0.0
  }
  let mut total = 0.0
  for value in profile {
    total = total + value
  }
  total / profile.length().to_double()
}

///|
pub fn multi_profile_integral(
  profile : Array[Double],
  bed_length : Double,
) -> Double {
  if profile.length() < 2 {
    return 0.0
  }
  let spacing = bed_length / (profile.length() - 1).to_double()
  let mut area = 0.0
  for i in 0..<(profile.length() - 1) {
    area = area + 0.5 * (profile[i] + profile[i + 1]) * spacing
  }
  area
}

///|
pub fn multi_profile_maximum(profile : Array[Double]) -> Double {
  if profile.length() == 0 {
    return 0.0
  }
  let mut maximum = profile[0]
  for value in profile {
    if value > maximum {
      maximum = value
    }
  }
  maximum
}

///|
pub fn multi_profile_minimum(profile : Array[Double]) -> Double {
  if profile.length() == 0 {
    return 0.0
  }
  let mut minimum = profile[0]
  for value in profile {
    if value < minimum {
      minimum = value
    }
  }
  minimum
}

///|
pub fn multi_profile_nonnegative(profile : Array[Double]) -> Bool {
  for value in profile {
    if value < -1.0e-12 {
      return false
    }
  }
  true
}

///|
pub fn multi_stability_report(result : MultiColumnResult) -> Double {
  if !result.stable {
    return 0.0
  }
  let mut score = 1.0
  for profile in result.final_concentration_profiles {
    if !multi_profile_nonnegative(profile) {
      score = score - 0.2
    }
  }
  for error in result.mass_balance_errors {
    if error > 0.05 {
      score = score - 0.1
    }
  }
  @utils.clamp(score, 0.0, 1.0)
}

///|
pub fn competitive_equilibrium(
  capacities : Array[Double],
  affinities : Array[Double],
) -> (Int, Double, Array[Double]) -> Double {
  fn equilibrium(
    component : Int,
    concentration : Double,
    mixture : Array[Double],
  ) -> Double {
    if component < 0 || component >= capacities.length() {
      return 0.0
    }
    let mut denominator = 1.0
    for i in 0..<mixture.length() {
      if i < affinities.length() {
        denominator = denominator + affinities[i] * mixture[i]
      }
    }
    if denominator == 0.0 {
      0.0
    } else {
      capacities[component] *
      affinities[component] *
      concentration /
      denominator
    }
  }
  equilibrium
}

///|
pub fn component_feed(values : Array[Double]) -> (Int, Double) -> Double {
  fn feed(component : Int, _time : Double) -> Double {
    if component < 0 || component >= values.length() {
      0.0
    } else {
      values[component]
    }
  }
  feed
}

///|
pub fn multi_time_average(
  result : MultiColumnResult,
  component : Int,
) -> Double {
  @utils.signal_mean(multi_outlet_series(result, component))
}

///|
pub fn multi_time_quantile(
  result : MultiColumnResult,
  component : Int,
  probability : Double,
) -> Double {
  @utils.signal_quantile(multi_outlet_series(result, component), probability)
}

///|
pub fn multi_breakthrough_order(
  result : MultiColumnResult,
  influents : Array[Double],
  fraction : Double,
) -> Array[Int] {
  let times = Array::make(result.final_concentration_profiles.length(), 0.0)
  for component in 0..<times.length() {
    let influent = if component < influents.length() {
      influents[component]
    } else {
      0.0
    }
    times[component] = @utils.signal_crossing_time(
      result.times,
      multi_outlet_series(result, component),
      influent * fraction,
    )
  }
  let ranking = Array::make(times.length(), 0)
  for i in 0..<ranking.length() {
    ranking[i] = i
  }
  for i in 1..<ranking.length() {
    let current = ranking[i]
    let mut j = i
    while j > 0 && times[ranking[j - 1]] > times[current] {
      ranking[j] = ranking[j - 1]
      j = j - 1
    }
    ranking[j] = current
  }
  ranking
}

///|
pub fn multi_capacity_by_component(
  result : MultiColumnResult,
  metrics : Array[ComponentMetric],
  bulk_density : Double,
  bed_length : Double,
) -> Array[Double] {
  let output = Array::make(metrics.length(), 0.0)
  let profiles_match = result.final_adsorbed_profiles.length() ==
    metrics.length()
  let volume = bed_length * bulk_density
  for i in 0..<output.length() {
    output[i] = if !profiles_match || volume == 0.0 {
      0.0
    } else {
      metrics[i].removed_mass / volume
    }
  }
  output
}
