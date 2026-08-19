///|
/// Production-operation helpers for column scheduling, multicomponent studies, and design screening.
pub struct FeedSegment {
  start : Double
  finish : Double
  concentration : Double
  flow_rate : Double
}

///|
pub struct RegenerationStep {
  name : String
  duration : Double
  flow_rate : Double
  temperature : Double
  recovery_fraction : Double
}

///|
pub struct OperatingPoint {
  time : Double
  inlet : Double
  outlet : Double
  ratio : Double
  removal : Double
  pressure_drop : Double
}

///|
pub struct ColumnCycleResult {
  operating_points : Array[OperatingPoint]
  adsorbed_mass : Double
  treated_volume : Double
  average_removal : Double
  breakthrough_time : Double
  pressure_energy : Double
  recovered_fraction : Double
  valid : Bool
}

///|
pub struct ScenarioResult {
  scenario : Int
  parameter_scale : Double
  breakthrough_time : Double
  capacity : Double
  removal : Double
  pressure_drop : Double
}

///|
pub struct ScenarioSummary {
  mean_breakthrough : Double
  p05_breakthrough : Double
  p50_breakthrough : Double
  p95_breakthrough : Double
  mean_capacity : Double
  worst_removal : Double
  best_removal : Double
  scenarios : Array[ScenarioResult]
}

///|
pub struct DesignCandidate {
  length : Double
  diameter : Double
  flow_rate : Double
  bed_mass : Double
  contact_time : Double
  pressure_drop : Double
  service_time : Double
  objective : Double
  feasible : Bool
}

///|
pub fn feed_segment(
  start : Double,
  finish : Double,
  concentration : Double,
  flow_rate : Double,
) -> FeedSegment {
  {
    start: if start <= finish {
      start
    } else {
      finish
    },
    finish: if finish >= start {
      finish
    } else {
      start
    },
    concentration: if concentration < 0.0 {
      0.0
    } else {
      concentration
    },
    flow_rate: if flow_rate < 0.0 {
      0.0
    } else {
      flow_rate
    },
  }
}

///|
pub fn regeneration_step(
  name : String,
  duration : Double,
  flow_rate : Double,
  temperature : Double,
  recovery_fraction : Double,
) -> RegenerationStep {
  {
    name,
    duration: if duration < 0.0 {
      0.0
    } else {
      duration
    },
    flow_rate: if flow_rate < 0.0 {
      0.0
    } else {
      flow_rate
    },
    temperature,
    recovery_fraction: @utils.clamp(recovery_fraction, 0.0, 1.0),
  }
}

///|
pub fn feed_schedule_value(
  segments : Array[FeedSegment],
  time : Double,
) -> Double {
  if segments.length() == 0 {
    return 0.0
  }
  for segment in segments {
    if time >= segment.start && time <= segment.finish {
      return segment.concentration
    }
  }
  if time < segments[0].start {
    0.0
  } else {
    segments[segments.length() - 1].concentration
  }
}

///|
pub fn feed_schedule_flow(
  segments : Array[FeedSegment],
  time : Double,
) -> Double {
  if segments.length() == 0 {
    return 0.0
  }
  for segment in segments {
    if time >= segment.start && time <= segment.finish {
      return segment.flow_rate
    }
  }
  0.0
}

///|
pub fn feed_schedule_duration(segments : Array[FeedSegment]) -> Double {
  let mut total = 0.0
  for segment in segments {
    total = total + (segment.finish - segment.start)
  }
  total
}

///|
pub fn feed_schedule_area(segments : Array[FeedSegment]) -> Double {
  let mut area = 0.0
  for segment in segments {
    area = area +
      (segment.finish - segment.start) *
      segment.concentration *
      segment.flow_rate
  }
  area
}

///|
pub fn simulate_segmented_column(
  config : ColumnSimulationConfig,
  isotherm : (Double) -> Double,
  segments : Array[FeedSegment],
) -> ColumnSimulationResult {
  let all_points : Array[BreakthroughPoint] = []
  let mut final_c = Array::make(config.grid_points, 0.0)
  let mut final_q = Array::make(config.grid_points, 0.0)
  for segment in segments {
    let duration = segment.finish - segment.start
    let segment_config = {
      bed_length: config.bed_length,
      velocity: if segment.flow_rate <= 0.0 {
        config.velocity
      } else {
        config.velocity * segment.flow_rate
      },
      porosity: config.porosity,
      bulk_density: config.bulk_density,
      ldf_coefficient: config.ldf_coefficient,
      grid_points: config.grid_points,
      time_step: config.time_step,
      total_time: duration,
    }
    let result = simulate_column(segment_config, isotherm, fn(time) {
      if time <= duration {
        segment.concentration
      } else {
        0.0
      }
    })
    for point in result.breakthrough_curve {
      all_points.push({
        time: point.time + segment.start,
        outlet_concentration: point.outlet_concentration,
        outlet_ratio: point.outlet_ratio,
      })
    }
    final_c = result.final_concentration_profile
    final_q = result.final_adsorbed_profile
  }
  {
    breakthrough_curve: all_points,
    final_concentration_profile: final_c,
    final_adsorbed_profile: final_q,
  }
}

///|
pub fn operating_point(
  time : Double,
  inlet : Double,
  outlet : Double,
  pressure_drop : Double,
) -> OperatingPoint {
  let ratio = if inlet <= 0.0 { 0.0 } else { outlet / inlet }
  {
    time,
    inlet,
    outlet,
    ratio,
    removal: @utils.clamp(1.0 - ratio, 0.0, 1.0),
    pressure_drop,
  }
}

///|
pub fn operating_points_from_curve(
  curve : Array[BreakthroughPoint],
  inlet : Double,
  pressure_drop : Double,
) -> Array[OperatingPoint] {
  let result : Array[OperatingPoint] = []
  for point in curve {
    result.push(
      operating_point(
        point.time,
        inlet,
        point.outlet_concentration,
        pressure_drop,
      ),
    )
  }
  result
}

///|
pub fn operating_average_removal(points : Array[OperatingPoint]) -> Double {
  if points.length() == 0 {
    return 0.0
  }
  let mut total = 0.0
  for point in points {
    total = total + point.removal
  }
  total / points.length().to_double()
}

///|
pub fn operating_integral_removal(points : Array[OperatingPoint]) -> Double {
  if points.length() < 2 {
    return 0.0
  }
  let times = Array::make(points.length(), 0.0)
  let removal = Array::make(points.length(), 0.0)
  for i in 0..<points.length() {
    times[i] = points[i].time
    removal[i] = points[i].removal
  }
  @utils.interpolation_integral(times, removal)
}

///|
pub fn operating_pressure_energy(
  points : Array[OperatingPoint],
  flow_rate : Double,
) -> Double {
  if points.length() < 2 {
    return 0.0
  }
  let times = Array::make(points.length(), 0.0)
  let pressure = Array::make(points.length(), 0.0)
  for i in 0..<points.length() {
    times[i] = points[i].time
    pressure[i] = points[i].pressure_drop * flow_rate
  }
  @utils.interpolation_integral(times, pressure)
}

///|
pub fn cycle_from_curve(
  curve : Array[BreakthroughPoint],
  influent : Double,
  flow_rate : Double,
  bed_mass : Double,
  pressure_drop : Double,
  breakthrough_fraction : Double,
) -> ColumnCycleResult {
  let points = operating_points_from_curve(curve, influent, pressure_drop)
  let times = Array::make(curve.length(), 0.0)
  let outlet = Array::make(curve.length(), 0.0)
  for i in 0..<curve.length() {
    times[i] = curve[i].time
    outlet[i] = curve[i].outlet_concentration
  }
  let input_mass = if curve.length() < 2 {
    0.0
  } else {
    influent * flow_rate * (times[times.length() - 1] - times[0])
  }
  let output_mass = @utils.interpolation_integral(times, outlet) * flow_rate
  let removed = input_mass - output_mass
  let breakthrough = @utils.signal_crossing_time(
    times,
    outlet,
    influent * breakthrough_fraction,
  )
  {
    operating_points: points,
    adsorbed_mass: if removed < 0.0 {
      0.0
    } else {
      removed
    },
    treated_volume: if curve.length() < 2 {
      0.0
    } else {
      flow_rate * (times[times.length() - 1] - times[0])
    },
    average_removal: operating_average_removal(points),
    breakthrough_time: breakthrough,
    pressure_energy: operating_pressure_energy(points, flow_rate),
    recovered_fraction: if bed_mass == 0.0 {
      0.0
    } else {
      removed / bed_mass
    },
    valid: points.length() > 1 && bed_mass > 0.0,
  }
}

///|
pub fn cycle_recovery(
  cycle : ColumnCycleResult,
  regeneration : Array[RegenerationStep],
) -> Double {
  let mut recovery = 1.0
  for step in regeneration {
    recovery = recovery * step.recovery_fraction
  }
  @utils.clamp(cycle.recovered_fraction * recovery, 0.0, 1.0)
}

///|
pub fn cycle_total_regeneration_time(
  regeneration : Array[RegenerationStep],
) -> Double {
  let mut total = 0.0
  for step in regeneration {
    total = total + step.duration
  }
  total
}

///|
pub fn cycle_water_demand(regeneration : Array[RegenerationStep]) -> Double {
  let mut total = 0.0
  for step in regeneration {
    total = total + step.duration * step.flow_rate
  }
  total
}

///|
pub fn cycle_energy_demand(
  regeneration : Array[RegenerationStep],
  heat_capacity : Double,
  reference_temperature : Double,
) -> Double {
  let mut total = 0.0
  for step in regeneration {
    total = total +
      step.flow_rate *
      heat_capacity *
      (step.temperature - reference_temperature).abs() *
      step.duration
  }
  total
}

///|
pub fn scenario_scales(
  count : Int,
  minimum : Double,
  maximum : Double,
) -> Array[Double] {
  let size = if count <= 0 { 1 } else { count }
  let result = Array::make(size, 1.0)
  for i in 0..<size {
    result[i] = if size == 1 {
      1.0
    } else {
      minimum + (maximum - minimum) * i.to_double() / (size - 1).to_double()
    }
  }
  result
}

///|
pub fn run_scenarios(
  config : ColumnSimulationConfig,
  isotherm : (Double, Double) -> Double,
  feed : (Double) -> Double,
  scales : Array[Double],
  influent : Double,
  bed_mass : Double,
  breakthrough_fraction : Double,
) -> Array[ScenarioResult] {
  let result : Array[ScenarioResult] = []
  for i in 0..<scales.length() {
    let scale = scales[i]
    let local_config = {
      bed_length: config.bed_length,
      velocity: config.velocity * scale,
      porosity: config.porosity,
      bulk_density: config.bulk_density * scale,
      ldf_coefficient: config.ldf_coefficient * scale,
      grid_points: config.grid_points,
      time_step: config.time_step,
      total_time: config.total_time,
    }
    let simulation = simulate_column(
      local_config,
      fn(concentration) { isotherm(concentration, scale) },
      feed,
    )
    let cycle = cycle_from_curve(
      simulation.breakthrough_curve,
      influent,
      local_config.velocity,
      bed_mass * scale,
      pressure_drop_ergun(
        local_config.bed_length,
        local_config.velocity,
        local_config.porosity,
        local_config.bulk_density,
        1.0,
      ) *
      scale,
      breakthrough_fraction,
    )
    result.push({
      scenario: i,
      parameter_scale: scale,
      breakthrough_time: cycle.breakthrough_time,
      capacity: cycle.adsorbed_mass,
      removal: cycle.average_removal,
      pressure_drop: if cycle.operating_points.length() == 0 {
        0.0
      } else {
        cycle.operating_points[0].pressure_drop
      },
    })
  }
  result
}

///|
pub fn summarize_scenarios(
  scenarios : Array[ScenarioResult],
) -> ScenarioSummary {
  if scenarios.length() == 0 {
    return {
      mean_breakthrough: 0.0,
      p05_breakthrough: 0.0,
      p50_breakthrough: 0.0,
      p95_breakthrough: 0.0,
      mean_capacity: 0.0,
      worst_removal: 0.0,
      best_removal: 0.0,
      scenarios: [],
    }
  }
  let breakthrough = Array::make(scenarios.length(), 0.0)
  let capacity = Array::make(scenarios.length(), 0.0)
  let mut mean_breakthrough = 0.0
  let mut mean_capacity = 0.0
  let mut worst = 1.0e30
  let mut best = -1.0e30
  for i in 0..<scenarios.length() {
    breakthrough[i] = scenarios[i].breakthrough_time
    capacity[i] = scenarios[i].capacity
    mean_breakthrough = mean_breakthrough + breakthrough[i]
    mean_capacity = mean_capacity + capacity[i]
    if scenarios[i].removal < worst {
      worst = scenarios[i].removal
    }
    if scenarios[i].removal > best {
      best = scenarios[i].removal
    }
  }
  {
    mean_breakthrough: mean_breakthrough / scenarios.length().to_double(),
    p05_breakthrough: @utils.signal_quantile(breakthrough, 0.05),
    p50_breakthrough: @utils.signal_quantile(breakthrough, 0.5),
    p95_breakthrough: @utils.signal_quantile(breakthrough, 0.95),
    mean_capacity: mean_capacity / scenarios.length().to_double(),
    worst_removal: worst,
    best_removal: best,
    scenarios,
  }
}

///|
pub fn design_candidate(
  length : Double,
  diameter : Double,
  flow_rate : Double,
  bulk_density : Double,
  velocity : Double,
  porosity : Double,
  service_time_value : Double,
  objective : Double,
  maximum_pressure_drop : Double,
) -> DesignCandidate {
  let volume = bed_volume(length, diameter)
  let mass = bed_mass(volume, bulk_density)
  let contact = empty_bed_contact_time(length, velocity, porosity)
  let pressure = pressure_drop_ergun(
    length, velocity, porosity, bulk_density, diameter,
  )
  {
    length,
    diameter,
    flow_rate,
    bed_mass: mass,
    contact_time: contact,
    pressure_drop: pressure,
    service_time: service_time_value,
    objective,
    feasible: pressure <= maximum_pressure_drop &&
    length > 0.0 &&
    diameter > 0.0,
  }
}

///|
pub fn design_screen(
  lengths : Array[Double],
  diameters : Array[Double],
  flows : Array[Double],
  bulk_density : Double,
  porosity : Double,
  velocity : Double,
  maximum_pressure_drop : Double,
  target_service_time : Double,
) -> Array[DesignCandidate] {
  let result : Array[DesignCandidate] = []
  for length in lengths {
    for diameter in diameters {
      for flow in flows {
        let service = service_time(
          length, velocity, porosity, target_service_time,
        )
        let candidate = design_candidate(
          length,
          diameter,
          flow,
          bulk_density,
          velocity,
          porosity,
          service,
          (service - target_service_time).abs() +
          empty_bed_contact_time(length, velocity, porosity),
          maximum_pressure_drop,
        )
        result.push(candidate)
      }
    }
  }
  result
}

///|
pub fn best_feasible_design(
  candidates : Array[DesignCandidate],
) -> DesignCandidate {
  if candidates.length() == 0 {
    return {
      length: 0.0,
      diameter: 0.0,
      flow_rate: 0.0,
      bed_mass: 0.0,
      contact_time: 0.0,
      pressure_drop: 0.0,
      service_time: 0.0,
      objective: 1.0e30,
      feasible: false,
    }
  }
  let mut best = candidates[0]
  for candidate in candidates {
    if candidate.feasible && candidate.objective < best.objective {
      best = candidate
    }
  }
  best
}

///|
pub fn design_pareto(
  candidates : Array[DesignCandidate],
) -> Array[DesignCandidate] {
  let result : Array[DesignCandidate] = []
  for candidate in candidates {
    if candidate.feasible {
      let mut dominated = false
      for other in candidates {
        if other.feasible &&
          other.bed_mass <= candidate.bed_mass &&
          other.pressure_drop <= candidate.pressure_drop &&
          (
            other.bed_mass < candidate.bed_mass ||
            other.pressure_drop < candidate.pressure_drop
          ) {
          dominated = true
        }
      }
      if !dominated {
        result.push(candidate)
      }
    }
  }
  result
}

///|
pub fn column_safety_margin(
  pressure_drop : Double,
  maximum_pressure_drop : Double,
) -> Double {
  if maximum_pressure_drop <= 0.0 {
    0.0
  } else {
    @utils.clamp(
      (maximum_pressure_drop - pressure_drop) / maximum_pressure_drop,
      0.0,
      1.0,
    )
  }
}

///|
pub fn column_utilization(
  adsorbed_mass : Double,
  theoretical_capacity : Double,
) -> Double {
  if theoretical_capacity <= 0.0 {
    0.0
  } else {
    @utils.clamp(adsorbed_mass / theoretical_capacity, 0.0, 1.0)
  }
}

///|
pub fn cycle_productivity(
  cycle : ColumnCycleResult,
  total_cycle_time : Double,
) -> Double {
  if total_cycle_time <= 0.0 {
    0.0
  } else {
    cycle.adsorbed_mass / total_cycle_time
  }
}

///|
pub fn cycle_specific_energy(
  cycle : ColumnCycleResult,
  recovered_mass : Double,
) -> Double {
  if recovered_mass <= 0.0 {
    0.0
  } else {
    cycle.pressure_energy / recovered_mass
  }
}

///|
pub fn curve_quality(
  curve : Array[BreakthroughPoint],
  maximum_ratio : Double,
) -> Double {
  if curve.length() < 2 {
    return 0.0
  }
  let mut score = 1.0
  for i in 1..<curve.length() {
    if curve[i].time <= curve[i - 1].time {
      score = score - 0.2
    }
    if curve[i].outlet_ratio < -1.0e-8 || curve[i].outlet_ratio > maximum_ratio {
      score = score - 0.1
    }
  }
  if !monotonic_breakthrough(curve) {
    score = score - 0.1
  }
  @utils.clamp(score, 0.0, 1.0)
}
