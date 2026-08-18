///|
fn main {
  let data = [
    @isotherm.AdsorptionData::{ c: 0.5, q: 2.0 },
    @isotherm.AdsorptionData::{ c: 1.0, q: 3.3333333333 },
    @isotherm.AdsorptionData::{ c: 2.0, q: 5.0 },
    @isotherm.AdsorptionData::{ c: 4.0, q: 6.6666666667 },
    @isotherm.AdsorptionData::{ c: 8.0, q: 8.0 },
  ]
  let fitted = @isotherm.fit_langmuir(data)
  println("langmuir q_m")
  println(fitted.q_m)
  println("langmuir k_l")
  println(fitted.k_l)
  println("langmuir r2")
  println(fitted.r_squared)
  let config = @fixed_bed.ColumnSimulationConfig::{
    bed_length: 10.0,
    velocity: 2.0,
    porosity: 0.4,
    bulk_density: 0.8,
    ldf_coefficient: 0.5,
    grid_points: 51,
    time_step: 0.01,
    total_time: 10.0,
  }
  let result = @fixed_bed.simulate_column(
    config,
    fn(c) { @isotherm.predict_langmuir(fitted, c) },
    fn(_time) { 10.0 },
  )
  let metrics = @fixed_bed.summarize_breakthrough(
    result.breakthrough_curve,
    10.0,
    2.0,
  )
  println("column steps")
  println(result.breakthrough_curve.length())
  println("c50_time")
  println(metrics.c50_time)
  println("removal_capacity")
  println(metrics.removal_capacity)
}
