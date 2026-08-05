///|
pub(all) struct ColumnSimulationConfig {
  /// Bed length (Z, cm)
  bed_length : Double
  /// Linear interstitial flow velocity (v, cm/min)
  velocity : Double
  /// Bed porosity (epsilon, dimensionless)
  porosity : Double
  /// Adsorbent bulk density (rho_b, g/cm^3)
  bulk_density : Double
  /// Mass transfer coefficient (k_LDF, 1/min)
  ldf_coefficient : Double
  /// Number of grid points for space discretization
  grid_points : Int
  /// Time step for numerical integration (dt, min)
  time_step : Double
  /// Total simulation time (min)
  total_time : Double
} derive(Debug, Eq)

///|
pub(all) struct BreakthroughPoint {
  time : Double
  outlet_concentration : Double
  outlet_ratio : Double
} derive(Debug, Eq)

///|
pub(all) struct ColumnSimulationResult {
  breakthrough_curve : Array[BreakthroughPoint]
  final_concentration_profile : Array[Double]
  final_adsorbed_profile : Array[Double]
} derive(Debug, Eq)

///|
priv struct ColumnState {
  c : Array[Double]
  q : Array[Double]
}

///|
fn add_states(s1 : ColumnState, s2 : ColumnState) -> ColumnState {
  let n = s1.c.length()
  let c = Array::make(n, 0.0)
  let q = Array::make(n, 0.0)
  for i = 0; i < n; i = i + 1 {
    c[i] = s1.c[i] + s2.c[i]
    q[i] = s1.q[i] + s2.q[i]
  }
  { c, q }
}

///|
fn scale_state(s : ColumnState, factor : Double) -> ColumnState {
  let n = s.c.length()
  let c = Array::make(n, 0.0)
  let q = Array::make(n, 0.0)
  for i = 0; i < n; i = i + 1 {
    c[i] = s.c[i] * factor
    q[i] = s.q[i] * factor
  }
  { c, q }
}

///|
fn odes(
  t : Double,
  state : ColumnState,
  config : ColumnSimulationConfig,
  isotherm : (Double) -> Double,
  feed : (Double) -> Double,
) -> ColumnState {
  let n = config.grid_points
  let dz = config.bed_length / (n - 1).to_double()
  let dc = Array::make(n, 0.0)
  let dq = Array::make(n, 0.0)

  // Inlet boundary condition (z = 0)
  let c_in = feed(t)
  dc[0] = 0.0
  let q_star_in = isotherm(c_in)
  dq[0] = config.ldf_coefficient * (q_star_in - state.q[0])

  // Internal points
  for i = 1; i < n; i = i + 1 {
    let c_val = state.c[i]
    let q_val = state.q[i]
    let q_star = isotherm(c_val)

    // Upwind discretization of convection: -v * (C_i - C_{i-1}) / dz
    let convection = -config.velocity * (c_val - state.c[i - 1]) / dz
    // Mass transfer to solid phase: -(rho_b / epsilon) * dq/dt
    let transfer = config.bulk_density /
      config.porosity *
      config.ldf_coefficient *
      (q_star - q_val)

    dc[i] = convection - transfer
    dq[i] = config.ldf_coefficient * (q_star - q_val)
  }

  { c: dc, q: dq }
}

///|
/// Simulates the dynamic 1D adsorption column using a Finite Difference Method
/// and RK4 time integration.
/// `config`: Simulator configuration parameters.
/// `isotherm`: Adsorption isotherm model callback $q^* = f(c)$.
/// `feed`: Time-varying inlet concentration callback $C_{feed}(t)$.
pub fn simulate_column(
  config : ColumnSimulationConfig,
  isotherm : (Double) -> Double,
  feed : (Double) -> Double,
) -> ColumnSimulationResult {
  let n = config.grid_points
  let dt = config.time_step
  let steps = (config.total_time / dt).to_int()

  // Initialize column: C(z, 0) = 0, q(z, 0) = 0
  let c = Array::make(n, 0.0)
  let q = Array::make(n, 0.0)
  let mut state = ColumnState::{ c, q }

  let breakthrough_curve = []

  for step = 0; step < steps; step = step + 1 {
    let t = step.to_double() * dt

    // Enforce inlet boundary concentration
    state.c[0] = feed(t)

    // Record breakthrough point at the outlet (index n - 1)
    let c_out = state.c[n - 1]
    let c_feed_val = feed(t)
    let ratio = if c_feed_val == 0.0 { 0.0 } else { c_out / c_feed_val }
    breakthrough_curve.push({
      time: t,
      outlet_concentration: c_out,
      outlet_ratio: ratio,
    })

    // RK4 time integration step
    let k1 = odes(t, state, config, isotherm, feed)

    let state_k2 = add_states(state, scale_state(k1, 0.5 * dt))
    let k2 = odes(t + 0.5 * dt, state_k2, config, isotherm, feed)

    let state_k3 = add_states(state, scale_state(k2, 0.5 * dt))
    let k3 = odes(t + 0.5 * dt, state_k3, config, isotherm, feed)

    let state_k4 = add_states(state, scale_state(k3, dt))
    let k4 = odes(t + dt, state_k4, config, isotherm, feed)

    // state_next = state + (dt/6) * (k1 + 2*k2 + 2*k3 + k4)
    let k_sum = add_states(
      add_states(k1, scale_state(k2, 2.0)),
      add_states(scale_state(k3, 2.0), k4),
    )
    state = add_states(state, scale_state(k_sum, dt / 6.0))
  }

  // Final check for boundary concentration at end of simulation
  state.c[0] = feed(config.total_time)

  {
    breakthrough_curve,
    final_concentration_profile: state.c,
    final_adsorbed_profile: state.q,
  }
}
