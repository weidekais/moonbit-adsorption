///|
/// Ordinary differential equation solvers for batch uptake, bed transport, and calibration.
pub struct OdeState {
  time : Double
  values : Array[Double]
}

///|
pub struct OdeConfig {
  initial_step : Double
  minimum_step : Double
  maximum_step : Double
  absolute_tolerance : Double
  relative_tolerance : Double
  maximum_steps : Int
}

///|
pub struct OdeEvent {
  time : Double
  state : Array[Double]
  value : Double
  rising : Bool
}

///|
pub struct OdeTrajectory {
  states : Array[OdeState]
  accepted_steps : Int
  rejected_steps : Int
  reached_end : Bool
  event : OdeEvent?
}

///|
pub fn ode_config(
  initial_step : Double,
  minimum_step : Double,
  maximum_step : Double,
  absolute_tolerance : Double,
  relative_tolerance : Double,
  maximum_steps : Int,
) -> OdeConfig {
  {
    initial_step: if initial_step <= 0.0 {
      1.0e-3
    } else {
      initial_step
    },
    minimum_step: if minimum_step <= 0.0 {
      1.0e-9
    } else {
      minimum_step
    },
    maximum_step: if maximum_step <= 0.0 {
      1.0
    } else {
      maximum_step
    },
    absolute_tolerance: if absolute_tolerance <= 0.0 {
      1.0e-8
    } else {
      absolute_tolerance
    },
    relative_tolerance: if relative_tolerance <= 0.0 {
      1.0e-6
    } else {
      relative_tolerance
    },
    maximum_steps: if maximum_steps <= 0 {
      100000
    } else {
      maximum_steps
    },
  }
}

///|
pub fn ode_default_config() -> OdeConfig {
  ode_config(1.0e-2, 1.0e-9, 1.0, 1.0e-8, 1.0e-6, 100000)
}

///|
pub fn ode_state(time : Double, values : Array[Double]) -> OdeState {
  { time, values: values.copy() }
}

///|
fn ode_add_scaled(
  state : Array[Double],
  derivative : Array[Double],
  step : Double,
) -> Array[Double] {
  if state.length() != derivative.length() {
    return state.copy()
  }
  let result = state.copy()
  for i in 0..<state.length() {
    result[i] = state[i] + step * derivative[i]
  }
  result
}

///|
fn ode_linear_combination(
  state : Array[Double],
  first : Array[Double],
  second : Array[Double],
  third : Array[Double],
  fourth : Array[Double],
  step : Double,
) -> Array[Double] {
  let result = state.copy()
  for i in 0..<state.length() {
    result[i] = state[i] +
      step * (first[i] + 2.0 * second[i] + 2.0 * third[i] + fourth[i]) / 6.0
  }
  result
}

///|
pub fn ode_euler_step(
  derivative : (Double, Array[Double]) -> Array[Double],
  state : OdeState,
  step : Double,
) -> OdeState {
  let slope = derivative(state.time, state.values.copy())
  if slope.length() != state.values.length() {
    return state
  }
  ode_state(state.time + step, ode_add_scaled(state.values, slope, step))
}

///|
pub fn ode_heun_step(
  derivative : (Double, Array[Double]) -> Array[Double],
  state : OdeState,
  step : Double,
) -> OdeState {
  let first = derivative(state.time, state.values.copy())
  let predictor = ode_add_scaled(state.values, first, step)
  let second = derivative(state.time + step, predictor)
  if first.length() != state.values.length() ||
    second.length() != state.values.length() {
    return state
  }
  let result = state.values.copy()
  for i in 0..<result.length() {
    result[i] = result[i] + step * (first[i] + second[i]) / 2.0
  }
  ode_state(state.time + step, result)
}

///|
pub fn ode_midpoint_step(
  derivative : (Double, Array[Double]) -> Array[Double],
  state : OdeState,
  step : Double,
) -> OdeState {
  let first = derivative(state.time, state.values.copy())
  let midpoint = ode_add_scaled(state.values, first, step / 2.0)
  let second = derivative(state.time + step / 2.0, midpoint)
  if second.length() != state.values.length() {
    return state
  }
  ode_state(state.time + step, ode_add_scaled(state.values, second, step))
}

///|
pub fn ode_rk4_step(
  derivative : (Double, Array[Double]) -> Array[Double],
  state : OdeState,
  step : Double,
) -> OdeState {
  let first = derivative(state.time, state.values.copy())
  let second_state = ode_add_scaled(state.values, first, step / 2.0)
  let second = derivative(state.time + step / 2.0, second_state)
  let third_state = ode_add_scaled(state.values, second, step / 2.0)
  let third = derivative(state.time + step / 2.0, third_state)
  let fourth_state = ode_add_scaled(state.values, third, step)
  let fourth = derivative(state.time + step, fourth_state)
  if first.length() != state.values.length() ||
    second.length() != state.values.length() ||
    third.length() != state.values.length() ||
    fourth.length() != state.values.length() {
    return state
  }
  ode_state(
    state.time + step,
    ode_linear_combination(state.values, first, second, third, fourth, step),
  )
}

///|
fn ode_rk4_pair(
  derivative : (Double, Array[Double]) -> Array[Double],
  state : OdeState,
  step : Double,
) -> (OdeState, OdeState) {
  let full = ode_rk4_step(derivative, state, step)
  let half = ode_rk4_step(
    derivative,
    ode_rk4_step(derivative, state, step / 2.0),
    step / 2.0,
  )
  (full, half)
}

///|
pub fn ode_error_estimate(coarse : OdeState, fine : OdeState) -> Double {
  if coarse.values.length() != fine.values.length() {
    return 1.0e30
  }
  let mut maximum = 0.0
  for i in 0..<coarse.values.length() {
    let error = (fine.values[i] - coarse.values[i]).abs()
    if error > maximum {
      maximum = error
    }
  }
  maximum / 15.0
}

///|
pub fn ode_scaled_error(
  coarse : OdeState,
  fine : OdeState,
  config : OdeConfig,
) -> Double {
  if coarse.values.length() != fine.values.length() {
    return 1.0e30
  }
  let mut maximum = 0.0
  for i in 0..<coarse.values.length() {
    let scale = config.absolute_tolerance +
      config.relative_tolerance * fine.values[i].abs()
    let error = (fine.values[i] - coarse.values[i]).abs() / scale
    if error > maximum {
      maximum = error
    }
  }
  maximum / 15.0
}

///|
pub fn ode_step_size(
  config : OdeConfig,
  current : Double,
  error : Double,
) -> Double {
  let safe_error = if error <= 1.0e-30 { 1.0e-30 } else { error }
  let factor = if error <= 1.0 {
    0.9 * @math.pow(safe_error, -0.2)
  } else {
    0.5 * @math.pow(safe_error, -0.25)
  }
  let proposed = current * factor
  let bounded_min = if proposed < config.minimum_step {
    config.minimum_step
  } else {
    proposed
  }
  if bounded_min > config.maximum_step {
    config.maximum_step
  } else {
    bounded_min
  }
}

///|
fn ode_direction(start : Double, finish : Double) -> Double {
  if finish >= start {
    1.0
  } else {
    -1.0
  }
}

///|
fn ode_reached(time : Double, finish : Double, direction : Double) -> Bool {
  if direction > 0.0 {
    time >= finish
  } else {
    time <= finish
  }
}

///|
fn ode_clamp_step(
  time : Double,
  finish : Double,
  direction : Double,
  step : Double,
) -> Double {
  let remaining = (finish - time) * direction
  let magnitude = if step.abs() > remaining { remaining } else { step.abs() }
  direction * magnitude
}

///|
pub fn ode_integrate_fixed(
  derivative : (Double, Array[Double]) -> Array[Double],
  initial : OdeState,
  finish : Double,
  step : Double,
) -> OdeTrajectory {
  let direction = ode_direction(initial.time, finish)
  let magnitude = if step.abs() <= 0.0 { 1.0e-3 } else { step.abs() }
  let states : Array[OdeState] = [initial]
  let mut current = initial
  let mut count = 0
  while !ode_reached(current.time, finish, direction) && count < 100000 {
    let size = ode_clamp_step(current.time, finish, direction, magnitude)
    current = ode_rk4_step(derivative, current, size)
    states.push(current)
    count = count + 1
  }
  {
    states,
    accepted_steps: count,
    rejected_steps: 0,
    reached_end: ode_reached(current.time, finish, direction),
    event: None,
  }
}

///|
pub fn ode_integrate_adaptive(
  derivative : (Double, Array[Double]) -> Array[Double],
  initial : OdeState,
  finish : Double,
  config : OdeConfig,
) -> OdeTrajectory {
  let direction = ode_direction(initial.time, finish)
  let states : Array[OdeState] = [initial]
  let mut current = initial
  let mut step = config.initial_step * direction
  let mut accepted = 0
  let mut rejected = 0
  let mut count = 0
  while !ode_reached(current.time, finish, direction) &&
        count < config.maximum_steps {
    let actual = ode_clamp_step(current.time, finish, direction, step)
    let (coarse, fine) = ode_rk4_pair(derivative, current, actual)
    let error = ode_scaled_error(coarse, fine, config)
    if error <= 1.0 || actual.abs() <= config.minimum_step * 1.001 {
      current = fine
      states.push(current)
      accepted = accepted + 1
    } else {
      rejected = rejected + 1
    }
    let next = ode_step_size(config, actual.abs(), error)
    step = direction * next
    count = count + 1
  }
  {
    states,
    accepted_steps: accepted,
    rejected_steps: rejected,
    reached_end: ode_reached(current.time, finish, direction),
    event: None,
  }
}

///|
pub fn ode_integrate_with_event(
  derivative : (Double, Array[Double]) -> Array[Double],
  initial : OdeState,
  finish : Double,
  config : OdeConfig,
  event_value : (Double, Array[Double]) -> Double,
  stop_on_event : Bool,
) -> OdeTrajectory {
  let base = ode_integrate_adaptive(derivative, initial, finish, config)
  let mut event : OdeEvent? = None
  let mut previous_value = event_value(initial.time, initial.values)
  for state in base.states {
    if state.time != initial.time && event is None {
      let current_value = event_value(state.time, state.values)
      if previous_value == 0.0 || previous_value * current_value <= 0.0 {
        let rising = current_value >= previous_value
        event = Some({
          time: state.time,
          state: state.values.copy(),
          value: current_value,
          rising,
        })
      }
      previous_value = current_value
    }
  }
  if stop_on_event && event is Some(_) {
    let event_value = event.unwrap()
    let states : Array[OdeState] = []
    for state in base.states {
      states.push(state)
      if state.time == event_value.time {
        break
      }
    }
    {
      states,
      accepted_steps: states.length() - 1,
      rejected_steps: base.rejected_steps,
      reached_end: false,
      event: Some(event_value),
    }
  } else {
    {
      states: base.states,
      accepted_steps: base.accepted_steps,
      rejected_steps: base.rejected_steps,
      reached_end: base.reached_end,
      event,
    }
  }
}

///|
pub fn trajectory_last(trajectory : OdeTrajectory) -> OdeState {
  if trajectory.states.length() == 0 {
    { time: 0.0, values: [] }
  } else {
    trajectory.states[trajectory.states.length() - 1]
  }
}

///|
pub fn trajectory_times(trajectory : OdeTrajectory) -> Array[Double] {
  let result = Array::make(trajectory.states.length(), 0.0)
  for i in 0..<result.length() {
    result[i] = trajectory.states[i].time
  }
  result
}

///|
pub fn trajectory_component(
  trajectory : OdeTrajectory,
  component : Int,
) -> Array[Double] {
  let result : Array[Double] = []
  for state in trajectory.states {
    if component >= 0 && component < state.values.length() {
      result.push(state.values[component])
    }
  }
  result
}

///|
pub fn trajectory_sample(trajectory : OdeTrajectory, time : Double) -> OdeState {
  if trajectory.states.length() == 0 {
    return { time: 0.0, values: [] }
  }
  if trajectory.states.length() == 1 {
    return trajectory.states[0]
  }
  let times = trajectory_times(trajectory)
  let interval = interpolation_interval(time, times)
  let left = trajectory.states[interval.left]
  let right = trajectory.states[interval.right]
  let values = Array::make(left.values.length(), 0.0)
  for i in 0..<values.length() {
    values[i] = left.values[i] +
      interval.fraction * (right.values[i] - left.values[i])
  }
  { time, values }
}

///|
pub fn trajectory_integral(
  trajectory : OdeTrajectory,
  component : Int,
) -> Double {
  interpolation_integral(
    trajectory_times(trajectory),
    trajectory_component(trajectory, component),
  )
}

///|
pub fn trajectory_maximum(
  trajectory : OdeTrajectory,
  component : Int,
) -> Double {
  let values = trajectory_component(trajectory, component)
  if values.length() == 0 {
    return 0.0
  }
  let mut maximum = values[0]
  for value in values {
    if value > maximum {
      maximum = value
    }
  }
  maximum
}

///|
pub fn trajectory_minimum(
  trajectory : OdeTrajectory,
  component : Int,
) -> Double {
  let values = trajectory_component(trajectory, component)
  if values.length() == 0 {
    return 0.0
  }
  let mut minimum = values[0]
  for value in values {
    if value < minimum {
      minimum = value
    }
  }
  minimum
}

///|
pub fn trajectory_mass_balance(
  trajectory : OdeTrajectory,
  input_component : Int,
  output_component : Int,
  initial_inventory : Double,
) -> Double {
  let input = trajectory_integral(trajectory, input_component)
  let output = trajectory_integral(trajectory, output_component)
  initial_inventory + input - output
}

///|
pub fn ode_linear_decay(
  rate : Double,
) -> (Double, Array[Double]) -> Array[Double] {
  fn derivative(_time : Double, state : Array[Double]) -> Array[Double] {
    vector_scale(state, -rate)
  }
  derivative
}

///|
pub fn ode_first_order_relaxation(
  rate : Double,
  target : Double,
) -> (Double, Array[Double]) -> Array[Double] {
  fn derivative(_time : Double, state : Array[Double]) -> Array[Double] {
    let result = Array::make(state.length(), 0.0)
    for i in 0..<state.length() {
      result[i] = rate * (target - state[i])
    }
    result
  }
  derivative
}

///|
pub fn ode_competing_decay(
  rates : Array[Double],
) -> (Double, Array[Double]) -> Array[Double] {
  fn derivative(_time : Double, state : Array[Double]) -> Array[Double] {
    let result = Array::make(state.length(), 0.0)
    for i in 0..<state.length() {
      let rate = if i < rates.length() { rates[i] } else { 0.0 }
      result[i] = -rate * state[i]
    }
    result
  }
  derivative
}

///|
pub fn ode_rhs_scale(
  derivative : (Double, Array[Double]) -> Array[Double],
  factor : Double,
) -> (Double, Array[Double]) -> Array[Double] {
  fn scaled(time : Double, state : Array[Double]) -> Array[Double] {
    vector_scale(derivative(time, state), factor)
  }
  scaled
}

///|
pub fn ode_rhs_sum(
  left : (Double, Array[Double]) -> Array[Double],
  right : (Double, Array[Double]) -> Array[Double],
) -> (Double, Array[Double]) -> Array[Double] {
  fn combined(time : Double, state : Array[Double]) -> Array[Double] {
    vector_add(left(time, state), right(time, state))
  }
  combined
}

///|
pub fn ode_rhs_with_input(
  derivative : (Double, Array[Double]) -> Array[Double],
  input : (Double) -> Array[Double],
) -> (Double, Array[Double]) -> Array[Double] {
  fn combined(time : Double, state : Array[Double]) -> Array[Double] {
    vector_add(derivative(time, state), input(time))
  }
  combined
}

///|
pub fn ode_step_consistency(
  derivative : (Double, Array[Double]) -> Array[Double],
  state : OdeState,
  step : Double,
) -> Double {
  let euler = ode_euler_step(derivative, state, step)
  let heun = ode_heun_step(derivative, state, step)
  vector_distance(euler.values, heun.values)
}

///|
pub fn ode_state_error(left : OdeState, right : OdeState) -> Double {
  vector_distance(left.values, right.values)
}

///|
pub fn trajectory_endpoint_error(
  trajectory : OdeTrajectory,
  expected : Array[Double],
) -> Double {
  vector_distance(trajectory_last(trajectory).values, expected)
}

///|
pub fn trajectory_monotonic(
  trajectory : OdeTrajectory,
  component : Int,
  increasing : Bool,
) -> Bool {
  monotonicity_violations(
    trajectory_component(trajectory, component),
    increasing,
  ) ==
  0
}

///|
pub fn trajectory_nonnegative(
  trajectory : OdeTrajectory,
  component : Int,
) -> Bool {
  for value in trajectory_component(trajectory, component) {
    if value < -1.0e-12 {
      return false
    }
  }
  true
}

///|
pub fn trajectory_to_samples(
  trajectory : OdeTrajectory,
  component : Int,
) -> Array[InterpolationSample] {
  let times = trajectory_times(trajectory)
  let values = trajectory_component(trajectory, component)
  let result : Array[InterpolationSample] = []
  let size = if times.length() < values.length() {
    times.length()
  } else {
    values.length()
  }
  for i in 0..<size {
    result.push({ x: times[i], y: values[i] })
  }
  result
}

///|
pub fn event_time(trajectory : OdeTrajectory) -> Double {
  match trajectory.event {
    Some(event) => event.time
    None => 0.0
  }
}

///|
pub fn event_found(trajectory : OdeTrajectory) -> Bool {
  trajectory.event is Some(_)
}
