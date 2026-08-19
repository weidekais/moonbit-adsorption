///|
/// Bounded optimization and experiment-design tools for model fitting and process operation.
pub struct ParameterBound {
  lower : Double
  upper : Double
  scale : Double
  fixed : Bool
}

///|
pub struct OptimizationTrace {
  parameters : Array[Array[Double]]
  objective : Array[Double]
  iterations : Int
  converged : Bool
}

///|
pub struct OptimizationSolution {
  parameters : Array[Double]
  objective : Double
  gradient_norm : Double
  iterations : Int
  converged : Bool
  trace : OptimizationTrace
}

///|
pub struct ConstraintResult {
  feasible : Bool
  penalty : Double
  violations : Array[Double]
}

///|
pub struct DesignPoint {
  parameters : Array[Double]
  score : Double
  feasible : Bool
}

///|
pub fn parameter_bound(
  lower : Double,
  upper : Double,
  scale : Double,
  fixed : Bool,
) -> ParameterBound {
  {
    lower: if lower <= upper {
      lower
    } else {
      upper
    },
    upper: if upper >= lower {
      upper
    } else {
      lower
    },
    scale: if scale.abs() <= 1.0e-30 {
      1.0
    } else {
      scale.abs()
    },
    fixed,
  }
}

///|
pub fn parameter_bound_default(
  lower : Double,
  upper : Double,
) -> ParameterBound {
  parameter_bound(lower, upper, 1.0, false)
}

///|
pub fn bounded_parameters(
  parameters : Array[Double],
  bounds : Array[ParameterBound],
) -> Array[Double] {
  let result = parameters.copy()
  for i in 0..<result.length() {
    if i < bounds.length() {
      let bound = bounds[i]
      result[i] = if bound.fixed {
        clamp(bound.lower, bound.lower, bound.upper)
      } else {
        clamp(result[i], bound.lower, bound.upper)
      }
    }
  }
  result
}

///|
pub fn normalized_parameters(
  parameters : Array[Double],
  bounds : Array[ParameterBound],
) -> Array[Double] {
  let result = Array::make(parameters.length(), 0.0)
  for i in 0..<parameters.length() {
    if i < bounds.length() {
      let bound = bounds[i]
      let width = bound.upper - bound.lower
      result[i] = if width == 0.0 {
        0.0
      } else {
        (parameters[i] - bound.lower) / width
      }
    } else {
      result[i] = parameters[i]
    }
  }
  result
}

///|
pub fn denormalized_parameters(
  normalized : Array[Double],
  bounds : Array[ParameterBound],
) -> Array[Double] {
  let result = Array::make(normalized.length(), 0.0)
  for i in 0..<normalized.length() {
    if i < bounds.length() {
      result[i] = bounds[i].lower +
        normalized[i] * (bounds[i].upper - bounds[i].lower)
    } else {
      result[i] = normalized[i]
    }
  }
  bounded_parameters(result, bounds)
}

///|
pub fn constraint_check(
  parameters : Array[Double],
  lower : Array[Double],
  upper : Array[Double],
  tolerance : Double,
) -> ConstraintResult {
  let size = parameters.length()
  let violations : Array[Double] = []
  let mut penalty = 0.0
  let tol = if tolerance < 0.0 { 0.0 } else { tolerance }
  for i in 0..<size {
    let low = if i < lower.length() { lower[i] } else { -1.0e30 }
    let high = if i < upper.length() { upper[i] } else { 1.0e30 }
    let low_violation = low - parameters[i] - tol
    let high_violation = parameters[i] - high - tol
    let violation = if low_violation > 0.0 {
      low_violation
    } else if high_violation > 0.0 {
      high_violation
    } else {
      0.0
    }
    violations.push(violation)
    penalty = penalty + violation * violation
  }
  { feasible: penalty <= 0.0, penalty, violations }
}

///|
pub fn penalized_objective(
  objective : (Array[Double]) -> Double,
  parameters : Array[Double],
  lower : Array[Double],
  upper : Array[Double],
  penalty_factor : Double,
) -> Double {
  let constraints = constraint_check(parameters, lower, upper, 0.0)
  let factor = if penalty_factor <= 0.0 { 1.0e6 } else { penalty_factor }
  objective(parameters) + factor * constraints.penalty
}

///|
pub fn finite_difference_gradient(
  objective : (Array[Double]) -> Double,
  parameters : Array[Double],
  steps : Array[Double],
) -> Array[Double] {
  let result = Array::make(parameters.length(), 0.0)
  for i in 0..<parameters.length() {
    let step = if i < steps.length() && steps[i].abs() > 1.0e-12 {
      steps[i].abs()
    } else {
      1.0e-6 * (1.0 + parameters[i].abs())
    }
    let left = parameters.copy()
    let right = parameters.copy()
    left[i] = left[i] - step
    right[i] = right[i] + step
    result[i] = (objective(right) - objective(left)) / (2.0 * step)
  }
  result
}

///|
pub fn finite_difference_hessian_diagonal(
  objective : (Array[Double]) -> Double,
  parameters : Array[Double],
  steps : Array[Double],
) -> Array[Double] {
  let result = Array::make(parameters.length(), 0.0)
  let center = objective(parameters)
  for i in 0..<parameters.length() {
    let step = if i < steps.length() && steps[i].abs() > 1.0e-12 {
      steps[i].abs()
    } else {
      1.0e-5 * (1.0 + parameters[i].abs())
    }
    let left = parameters.copy()
    let right = parameters.copy()
    left[i] = left[i] - step
    right[i] = right[i] + step
    result[i] = (objective(left) - 2.0 * center + objective(right)) /
      (step * step)
  }
  result
}

///|
pub fn coordinate_descent(
  objective : (Array[Double]) -> Double,
  initial : Array[Double],
  bounds : Array[ParameterBound],
  step_fraction : Double,
  tolerance : Double,
  maximum_iterations : Int,
) -> OptimizationSolution {
  let current = bounded_parameters(initial, bounds)
  let trace_parameters : Array[Array[Double]] = [current.copy()]
  let trace_objective : Array[Double] = [objective(current)]
  let mut score = trace_objective[0]
  let fraction = if step_fraction <= 0.0 { 0.1 } else { step_fraction }
  let tol = if tolerance <= 0.0 { 1.0e-8 } else { tolerance }
  let limit = if maximum_iterations <= 0 { 1000 } else { maximum_iterations }
  let mut converged = false
  let mut iteration = 0
  while iteration < limit && !converged {
    let before = score
    for i in 0..<current.length() {
      if i < bounds.length() && bounds[i].fixed {
        continue
      }
      let width = if i < bounds.length() {
        bounds[i].upper - bounds[i].lower
      } else {
        1.0
      }
      let step = width * fraction / (iteration + 1).to_double()
      let left = current.copy()
      let right = current.copy()
      left[i] = left[i] - step
      right[i] = right[i] + step
      let left_score = objective(bounded_parameters(left, bounds))
      let right_score = objective(bounded_parameters(right, bounds))
      if left_score < score && left_score <= right_score {
        current[i] = bounded_parameters(left, bounds)[i]
        score = left_score
      }
      if right_score < score && right_score < left_score {
        current[i] = bounded_parameters(right, bounds)[i]
        score = right_score
      }
    }
    trace_parameters.push(current.copy())
    trace_objective.push(score)
    converged = (before - score).abs() <= tol
    iteration = iteration + 1
  }
  let gradient = finite_difference_gradient(objective, current, [])
  {
    parameters: current,
    objective: score,
    gradient_norm: vector_norm(gradient),
    iterations: iteration,
    converged,
    trace: {
      parameters: trace_parameters,
      objective: trace_objective,
      iterations: iteration,
      converged,
    },
  }
}

///|
pub fn pattern_search(
  objective : (Array[Double]) -> Double,
  initial : Array[Double],
  bounds : Array[ParameterBound],
  initial_step : Double,
  shrink : Double,
  tolerance : Double,
  maximum_iterations : Int,
) -> OptimizationSolution {
  let current = bounded_parameters(initial, bounds)
  let trace_parameters : Array[Array[Double]] = [current.copy()]
  let trace_objective : Array[Double] = [objective(current)]
  let mut score = trace_objective[0]
  let mut step = if initial_step <= 0.0 { 0.1 } else { initial_step }
  let reduction = clamp(shrink, 0.1, 0.9)
  let tol = if tolerance <= 0.0 { 1.0e-8 } else { tolerance }
  let limit = if maximum_iterations <= 0 { 1000 } else { maximum_iterations }
  let mut iteration = 0
  let mut converged = false
  while iteration < limit && !converged {
    let mut improved = false
    for i in 0..<current.length() {
      let left = current.copy()
      let right = current.copy()
      left[i] = left[i] - step
      right[i] = right[i] + step
      let left_bounded = bounded_parameters(left, bounds)
      let right_bounded = bounded_parameters(right, bounds)
      let left_score = objective(left_bounded)
      let right_score = objective(right_bounded)
      if left_score < score && left_score <= right_score {
        current[i] = left_bounded[i]
        score = left_score
        improved = true
      } else if right_score < score {
        current[i] = right_bounded[i]
        score = right_score
        improved = true
      }
    }
    if !improved {
      step = step * reduction
    }
    trace_parameters.push(current.copy())
    trace_objective.push(score)
    converged = step <= tol
    iteration = iteration + 1
  }
  let gradient = finite_difference_gradient(objective, current, [])
  {
    parameters: current,
    objective: score,
    gradient_norm: vector_norm(gradient),
    iterations: iteration,
    converged,
    trace: {
      parameters: trace_parameters,
      objective: trace_objective,
      iterations: iteration,
      converged,
    },
  }
}

///|
pub fn bounded_golden_search(
  objective : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  maximum_iterations : Int,
) -> RootResult {
  let interval = normalize_root_interval(lower, upper)
  let a = interval[0]
  let b = interval[1]
  let tol = if tolerance <= 0.0 { 1.0e-8 } else { tolerance }
  let limit = if maximum_iterations <= 0 { 1000 } else { maximum_iterations }
  let phi = (5.0.sqrt() - 1.0) / 2.0
  let mut left = a
  let mut right = b
  let mut x1 = right - phi * (right - left)
  let mut x2 = left + phi * (right - left)
  let mut f1 = objective(x1)
  let mut f2 = objective(x2)
  let mut iteration = 0
  while iteration < limit && (right - left).abs() > tol {
    if f1 < f2 {
      right = x2
      x2 = x1
      f2 = f1
      x1 = right - phi * (right - left)
      f1 = objective(x1)
    } else {
      left = x1
      x1 = x2
      f1 = f2
      x2 = left + phi * (right - left)
      f2 = objective(x2)
    }
    iteration = iteration + 1
  }
  let root = 0.5 * (left + right)
  {
    root,
    value: objective(root),
    iterations: iteration,
    converged: (right - left).abs() <= tol,
    bracketed: true,
  }
}

///|
pub fn maximize_bounded_scalar(
  objective : (Double) -> Double,
  lower : Double,
  upper : Double,
  tolerance : Double,
  maximum_iterations : Int,
) -> RootResult {
  bounded_golden_search(
    fn(x) { -objective(x) },
    lower,
    upper,
    tolerance,
    maximum_iterations,
  )
}

///|
pub fn fit_least_squares(
  predictor : (Array[Double], Double) -> Double,
  parameters : Array[Double],
  x_values : Array[Double],
  y_values : Array[Double],
  weights : Array[Double],
  bounds : Array[ParameterBound],
  maximum_iterations : Int,
) -> OptimizationSolution {
  fn objective(candidate : Array[Double]) -> Double {
    let mut total = 0.0
    let size = if x_values.length() < y_values.length() {
      x_values.length()
    } else {
      y_values.length()
    }
    for i in 0..<size {
      let residual = predictor(candidate, x_values[i]) - y_values[i]
      let weight = if i < weights.length() && weights[i] > 0.0 {
        weights[i]
      } else {
        1.0
      }
      total = total + weight * residual * residual
    }
    total
  }
  coordinate_descent(
    objective, parameters, bounds, 0.1, 1.0e-10, maximum_iterations,
  )
}

///|
pub fn fit_weighted_linear(
  x_values : Array[Double],
  y_values : Array[Double],
  weights : Array[Double],
) -> LeastSquaresResult {
  let rows = if x_values.length() < y_values.length() {
    x_values.length()
  } else {
    y_values.length()
  }
  let design = matrix_zero(rows, 2)
  let observations = Array::make(rows, 0.0)
  for i in 0..<rows {
    let weight = if i < weights.length() && weights[i] > 0.0 {
      weights[i].sqrt()
    } else {
      1.0
    }
    design.values[i * 2] = weight * x_values[i]
    design.values[i * 2 + 1] = weight
    observations[i] = weight * y_values[i]
  }
  least_squares_qr(design, observations, 1.0e-12)
}

///|
pub fn objective_rms(residuals : Array[Double]) -> Double {
  if residuals.length() == 0 {
    return 0.0
  }
  (vector_dot(residuals, residuals) / residuals.length().to_double()).sqrt()
}

///|
pub fn objective_mae(residuals : Array[Double]) -> Double {
  if residuals.length() == 0 {
    return 0.0
  }
  let mut total = 0.0
  for residual in residuals {
    total = total + residual.abs()
  }
  total / residuals.length().to_double()
}

///|
pub fn objective_huber(residuals : Array[Double], threshold : Double) -> Double {
  let delta = if threshold <= 0.0 { 1.0 } else { threshold }
  let mut total = 0.0
  for residual in residuals {
    let magnitude = residual.abs()
    let contribution = if magnitude <= delta {
      0.5 * magnitude * magnitude
    } else {
      delta * (magnitude - 0.5 * delta)
    }
    total = total + contribution
  }
  total
}

///|
pub fn jacobian_from_model(
  model : (Array[Double], Double) -> Double,
  parameters : Array[Double],
  x_values : Array[Double],
  steps : Array[Double],
) -> Matrix {
  let result = matrix_zero(x_values.length(), parameters.length())
  for row in 0..<x_values.length() {
    for column in 0..<parameters.length() {
      let step = if column < steps.length() && steps[column].abs() > 1.0e-12 {
        steps[column].abs()
      } else {
        1.0e-6
      }
      let left = parameters.copy()
      let right = parameters.copy()
      left[column] = left[column] - step
      right[column] = right[column] + step
      result.values[row * result.columns + column] = (
          model(right, x_values[row]) - model(left, x_values[row])
        ) /
        (2.0 * step)
    }
  }
  result
}

///|
pub fn local_sensitivity(
  model : (Array[Double], Double) -> Double,
  parameters : Array[Double],
  x : Double,
  steps : Array[Double],
) -> Array[Double] {
  let matrix = jacobian_from_model(model, parameters, [x], steps)
  matrix_row(matrix, 0)
}

///|
pub fn design_grid(
  bounds : Array[ParameterBound],
  levels : Int,
) -> Array[DesignPoint] {
  let count = if levels < 2 { 2 } else { levels }
  let points : Array[DesignPoint] = []
  fn recurse(index : Int, current : Array[Double]) -> Unit {
    if index == bounds.length() {
      points.push({ parameters: current.copy(), score: 0.0, feasible: true })
    } else {
      for level in 0..<count {
        let candidate = current.copy()
        let fraction = level.to_double() / (count - 1).to_double()
        candidate.push(
          bounds[index].lower +
          fraction * (bounds[index].upper - bounds[index].lower),
        )
        recurse(index + 1, candidate)
      }
    }
  }
  recurse(0, [])
  points
}

///|
pub fn score_designs(
  designs : Array[DesignPoint],
  score : (Array[Double]) -> Double,
  constraints : (Array[Double]) -> Bool,
) -> Array[DesignPoint] {
  let result : Array[DesignPoint] = []
  for design in designs {
    let feasible = constraints(design.parameters)
    result.push({
      parameters: design.parameters,
      score: if feasible {
        score(design.parameters)
      } else {
        1.0e30
      },
      feasible,
    })
  }
  result
}

///|
pub fn best_design(designs : Array[DesignPoint]) -> DesignPoint {
  if designs.length() == 0 {
    return { parameters: [], score: 1.0e30, feasible: false }
  }
  let mut best = designs[0]
  for design in designs {
    if design.feasible && design.score < best.score {
      best = design
    }
  }
  best
}

///|
pub fn pareto_front(designs : Array[DesignPoint]) -> Array[DesignPoint] {
  let result : Array[DesignPoint] = []
  for candidate in designs {
    let mut dominated = false
    for other in designs {
      if other.feasible && other.score < candidate.score {
        dominated = true
      }
    }
    if candidate.feasible && !dominated {
      result.push(candidate)
    }
  }
  result
}

///|
pub fn optimization_converged(
  solution : OptimizationSolution,
  tolerance : Double,
) -> Bool {
  let limit = if tolerance <= 0.0 { 1.0e-6 } else { tolerance }
  solution.converged && solution.gradient_norm <= limit
}

///|
pub fn optimization_improvement(trace : OptimizationTrace) -> Double {
  if trace.objective.length() < 2 {
    0.0
  } else {
    trace.objective[0] - trace.objective[trace.objective.length() - 1]
  }
}

///|
pub fn optimization_trace_best(trace : OptimizationTrace) -> Int {
  argmin(trace.objective)
}
