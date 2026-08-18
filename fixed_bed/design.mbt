///|
/// Fixed-bed column design and dimensionless-group helpers.
pub fn flow_for_ebct(
  length : Double,
  porosity : Double,
  ebct : Double,
) -> Double {
  if length <= 0.0 || porosity <= 0.0 || ebct <= 0.0 {
    0.0
  } else {
    length * porosity / ebct
  }
}

///|
pub fn bed_volume(length : Double, diameter : Double) -> Double {
  if length <= 0.0 || diameter <= 0.0 {
    0.0
  } else {
    3.141592653589793 * diameter * diameter * length / 4.0
  }
}

///|
pub fn bed_mass(volume : Double, bulk_density : Double) -> Double {
  if volume <= 0.0 || bulk_density <= 0.0 {
    0.0
  } else {
    volume * bulk_density
  }
}

///|
pub fn superficial_velocity(flow : Double, area : Double) -> Double {
  if flow <= 0.0 || area <= 0.0 {
    0.0
  } else {
    flow / area
  }
}

///|
pub fn porosity_from_density(
  particle_density : Double,
  bulk_density : Double,
) -> Double {
  if particle_density <= 0.0 || bulk_density <= 0.0 {
    0.0
  } else {
    1.0 - bulk_density / particle_density
  }
}

///|
pub fn pressure_drop_ergun(
  length : Double,
  velocity : Double,
  viscosity : Double,
  particle_diameter : Double,
  porosity : Double,
) -> Double {
  if length <= 0.0 ||
    velocity < 0.0 ||
    viscosity <= 0.0 ||
    particle_diameter <= 0.0 ||
    porosity <= 0.0 {
    0.0
  } else {
    150.0 *
    viscosity *
    length *
    velocity *
    (1.0 - porosity) *
    (1.0 - porosity) /
    (particle_diameter * particle_diameter * porosity * porosity * porosity)
  }
}

///|
pub fn reynolds_particle(
  velocity : Double,
  diameter : Double,
  density : Double,
  viscosity : Double,
) -> Double {
  if viscosity <= 0.0 {
    0.0
  } else {
    velocity * diameter * density / viscosity
  }
}

///|
pub fn peclet_number(
  velocity : Double,
  length : Double,
  diffusivity : Double,
) -> Double {
  if diffusivity <= 0.0 {
    0.0
  } else {
    velocity * length / diffusivity
  }
}

///|
pub fn damkohler_number(
  rate : Double,
  length : Double,
  velocity : Double,
) -> Double {
  if velocity <= 0.0 {
    0.0
  } else {
    rate * length / velocity
  }
}

///|
pub fn mass_transfer_zone_length(
  bed_length : Double,
  breakthrough_time : Double,
  exhaustion_time : Double,
  residence_time : Double,
) -> Double {
  if exhaustion_time <= breakthrough_time || residence_time <= 0.0 {
    0.0
  } else {
    bed_length * (1.0 - residence_time / (exhaustion_time - breakthrough_time))
  }
}

///|
pub fn service_time(
  bed_depth : Double,
  critical_depth : Double,
  rate : Double,
  intercept : Double,
) -> Double {
  if rate <= 0.0 {
    0.0
  } else {
    (bed_depth - critical_depth) / rate + intercept
  }
}

///|
pub fn safety_factor(
  design_capacity : Double,
  required_capacity : Double,
) -> Double {
  if required_capacity <= 0.0 {
    0.0
  } else {
    design_capacity / required_capacity
  }
}

///|
pub fn concentration_pulse(
  time : Double,
  start : Double,
  duration : Double,
  height : Double,
) -> Double {
  if time < start || time > start + duration {
    0.0
  } else {
    height
  }
}

///|
pub fn gaussian_pulse(
  time : Double,
  center : Double,
  width : Double,
  height : Double,
) -> Double {
  if width <= 0.0 {
    0.0
  } else {
    height *
    @math.exp(-0.5 * ((time - center) / width) * ((time - center) / width))
  }
}

///|
pub fn square_wave(
  time : Double,
  period : Double,
  low : Double,
  high : Double,
) -> Double {
  if period <= 0.0 {
    low
  } else {
    let phase = (time / period).to_int()
    if phase % 2 == 0 {
      high
    } else {
      low
    }
  }
}

///|
pub fn ramp_feed(
  time : Double,
  start : Double,
  end : Double,
  duration : Double,
) -> Double {
  if duration <= 0.0 {
    end
  } else if time <= 0.0 {
    start
  } else if time >= duration {
    end
  } else {
    start + (end - start) * time / duration
  }
}

///|
pub fn pulse_integral(
  _start : Double,
  duration : Double,
  height : Double,
) -> Double {
  if duration <= 0.0 || height <= 0.0 {
    0.0
  } else {
    duration * height
  }
}

///|
pub fn residence_distribution(
  time : Double,
  mean : Double,
  variance : Double,
) -> Double {
  if time < 0.0 || mean <= 0.0 || variance <= 0.0 {
    0.0
  } else {
    @math.exp(-((time - mean) * (time - mean)) / (2.0 * variance)) /
    (2.0 * 3.141592653589793 * variance).sqrt()
  }
}

///|
pub fn ideal_plug_flow(
  time : Double,
  residence : Double,
  width : Double,
) -> Double {
  if width <= 0.0 ||
    time < residence - width / 2.0 ||
    time > residence + width / 2.0 {
    0.0
  } else {
    1.0 / width
  }
}

///|
pub fn residence_mean(times : Array[Double], weights : Array[Double]) -> Double {
  if times.length() == 0 || times.length() != weights.length() {
    0.0
  } else {
    let mut numerator = 0.0
    let mut denominator = 0.0
    for i in 0..<times.length() {
      numerator = numerator + times[i] * weights[i]
      denominator = denominator + weights[i]
    }
    if denominator == 0.0 {
      0.0
    } else {
      numerator / denominator
    }
  }
}

///|
pub fn residence_variance(
  times : Array[Double],
  weights : Array[Double],
) -> Double {
  let average = residence_mean(times, weights)
  if times.length() == 0 || times.length() != weights.length() {
    0.0
  } else {
    let mut numerator = 0.0
    let mut denominator = 0.0
    for i in 0..<times.length() {
      numerator = numerator +
        weights[i] * (times[i] - average) * (times[i] - average)
      denominator = denominator + weights[i]
    }
    if denominator == 0.0 {
      0.0
    } else {
      numerator / denominator
    }
  }
}

///|
pub fn discretization_step(length : Double, points : Int) -> Double {
  if length <= 0.0 || points < 2 {
    0.0
  } else {
    length / (points - 1).to_double()
  }
}

///|
pub fn courant_number(
  velocity : Double,
  time_step : Double,
  space_step : Double,
) -> Double {
  if space_step <= 0.0 {
    0.0
  } else {
    velocity * time_step / space_step
  }
}

///|
pub fn stable_upwind_time_step(
  velocity : Double,
  space_step : Double,
  safety : Double,
) -> Double {
  if velocity <= 0.0 {
    0.0
  } else {
    space_step / velocity * @utils.clamp(safety, 0.01, 1.0)
  }
}
