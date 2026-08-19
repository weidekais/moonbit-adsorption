///|
/// Boundary tests for production numerical and data-processing APIs.
test "production interpolation boundaries" {
  inspect(interpolation_interval_value(0.0, [], []), content="0")
  inspect(interpolation_interval_value(2.0, [0.0], [4.0]), content="4")
  inspect(
    interpolation_interval_value(-1.0, [0.0, 1.0], [2.0, 4.0]),
    content="0",
  )
  let spline = fit_natural_cubic_spline([0.0, 1.0, 2.0], [0.0, 1.0, 4.0], false)
  inspect(spline_value(spline, 1.0) >= 0.99, content="true")
  inspect(
    crossing_locations([0.0, 1.0, 2.0], [-1.0, 1.0, -1.0], 0.0).length(),
    content="2",
  )
}

///|
test "production root and integration boundaries" {
  let root = bisection(fn(x) { x * x - 2.0 }, 0.0, 2.0, 1.0e-10, 100)
  inspect(root.converged, content="true")
  inspect((root.root - 1.41421356237).abs() < 1.0e-6, content="true")
  inspect(
    (integrate_simpson(fn(x) { x * x }, 0.0, 1.0, 100) - 1.0 / 3.0).abs() <
    1.0e-4,
    content="true",
  )
  inspect(
    roots_unique(
      [root, root_result_at(fn(x) { x * x - 2.0 }, root.root + 1.0e-10)],
      1.0e-6,
    ).length(),
    content="1",
  )
}

///|
test "production linear algebra boundaries" {
  let system = matrix(2, 2, [4.0, 1.0, 1.0, 3.0])
  let solution = lu_solve(lu_factor(system, 1.0e-12), [1.0, 2.0])
  inspect(solution.length(), content="2")
  inspect(
    (4.0 * solution[0] + solution[1] - 1.0).abs() < 1.0e-6,
    content="true",
  )
  let inverse = matrix_inverse(system, 1.0e-12)
  inspect(matrix_condition_estimate(system, 1.0e-12) > 1.0, content="true")
  inspect(matrix_multiply(system, inverse).values[0] > 0.99, content="true")
  let chol = cholesky_solve(cholesky_factor(system, 1.0e-12), [1.0, 2.0])
  inspect(chol.length(), content="2")
}

///|
test "production ode boundaries" {
  let derivative = ode_linear_decay(1.0)
  let trajectory = ode_integrate_adaptive(
    derivative,
    ode_state(0.0, [1.0]),
    1.0,
    ode_config(0.1, 1.0e-8, 0.2, 1.0e-8, 1.0e-6, 1000),
  )
  inspect(trajectory.reached_end, content="true")
  inspect(
    (trajectory_last(trajectory).values[0] - 0.367879).abs() < 1.0e-3,
    content="true",
  )
  inspect(trajectory_nonnegative(trajectory, 0), content="true")
  let event = ode_integrate_with_event(
    ode_first_order_relaxation(1.0, 1.0),
    ode_state(0.0, [0.0]),
    3.0,
    ode_default_config(),
    fn(_t, state) { state[0] - 0.5 },
    true,
  )
  inspect(event_found(event), content="true")
}

///|
test "production process data boundaries" {
  inspect(quantity_si_value(grams(1000.0)) == 1.0, content="true")
  inspect(
    (quantity_si_value(celsius(0.0)) - 273.15).abs() < 1.0e-8,
    content="true",
  )
  let table = observation_table([2.0, 1.0, 1.0], [4.0, 2.0, 3.0])
  let clean = table_deduplicate_time(table, 1.0e-8)
  inspect(table_length(clean), content="2")
  inspect(table_summary(clean).valid_count, content="2")
  inspect(process_moving_average([1.0, 3.0, 5.0], 2)[2] == 4.0, content="true")
}

///|
test "production signal and quality boundaries" {
  let peaks = signal_find_peaks(
    [0.0, 1.0, 2.0, 3.0],
    [0.0, 2.0, 0.0, 1.0],
    0.5,
    1,
  )
  inspect(peaks.length(), content="1")
  let limits = robust_control_limits([1.0, 1.0, 1.0, 10.0], 3.0)
  inspect(
    control_out_of_limits([1.0, 1.0, 1.0, 10.0], limits).length() >= 1,
    content="true",
  )
  inspect(quality_gate([1.0, 1.01, 0.99], 0.0, 2.0, 3.0, 0.0), content="true")
}

///|
test "production optimization boundaries" {
  let result = coordinate_descent(
    fn(params) { (params[0] - 2.0) * (params[0] - 2.0) },
    [0.0],
    [parameter_bound_default(-5.0, 5.0)],
    0.2,
    1.0e-8,
    100,
  )
  inspect(result.parameters[0] > 1.0, content="true")
  inspect(result.objective < 2.0, content="true")
  let best = bounded_golden_search(
    fn(x) { (x - 3.0) * (x - 3.0) },
    -2.0,
    8.0,
    1.0e-8,
    100,
  )
  inspect((best.root - 3.0).abs() < 1.0e-4, content="true")
}
