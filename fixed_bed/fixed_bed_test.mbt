///|
test "calculate_thomas_breakthrough" {
  // Let's assume some parameters
  let c_ratio = @fixed_bed.calculate_thomas_breakthrough(
    10.0, // t
     0.5, // k_th
     100.0, // q_0
     2.0, // w
     5.0, // q
     10.0, // c_0
  )

  // Exponent = (0.5 * 100 * 2 / 5) - (0.5 * 10 * 10) = 20 - 50 = -30
  // C/C0 = 1 / (1 + exp(-30)) ~ 1.0
  if !(c_ratio > 0.99) {
    panic()
  }
}

///|
test "estimate_thomas_time" {
  // To reach exactly 0.5 ratio, ln(1/0.5 - 1) = ln(1) = 0
  // t = (0.5 * 100 * 2 / 5) / (0.5 * 10) = 20 / 5 = 4
  let t = @fixed_bed.estimate_thomas_time(0.5, 0.5, 100.0, 2.0, 5.0, 10.0)
  if !(t > 3.99 && t < 4.01) {
    panic()
  }
}

///|
test "simulate_column basic" {
  let config = @fixed_bed.ColumnSimulationConfig::{
    bed_length: 10.0,
    velocity: 2.0,
    porosity: 0.4,
    bulk_density: 0.8,
    ldf_coefficient: 0.5,
    grid_points: 11,
    time_step: 0.05,
    total_time: 1.0,
  }

  // Use a simple Langmuir isotherm callback
  let isotherm = fn(c : Double) -> Double {
    let q_m = 10.0
    let k_l = 0.5
    q_m * k_l * c / (1.0 + k_l * c)
  }

  // Constant feed concentration of 10.0 mg/L
  let feed = fn(_t : Double) -> Double { 10.0 }

  let res = @fixed_bed.simulate_column(config, isotherm, feed)

  // Verify that the final outlet concentration ratio is between 0.0 and 1.0
  let final_ratio = res.breakthrough_curve[res.breakthrough_curve.length() - 1].outlet_ratio
  if !(final_ratio >= 0.0 && final_ratio <= 1.0) {
    panic()
  }

  // Check the final profile size matches grid_points
  if res.final_concentration_profile.length() != 11 {
    panic()
  }
}
