///|
/// Linear algebra primitives for inverse problems, parameter estimation, and transport models.
pub struct PivotedSystem {
  upper : Matrix
  permutation : Array[Int]
  pivot_sign : Int
  singular : Bool
}

///|
pub struct CholeskySystem {
  factor : Matrix
  positive_definite : Bool
}

///|
pub struct LeastSquaresResult {
  coefficients : Array[Double]
  residuals : Array[Double]
  residual_norm : Double
  rank : Int
  condition_estimate : Double
}

///|
pub struct EigenPair {
  value : Double
  vector : Array[Double]
  residual_norm : Double
}

///|
pub fn vector_dot(left : Array[Double], right : Array[Double]) -> Double {
  let size = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  let mut value = 0.0
  for i in 0..<size {
    value = value + left[i] * right[i]
  }
  value
}

///|
pub fn vector_norm(value : Array[Double]) -> Double {
  vector_dot(value, value).sqrt()
}

///|
pub fn vector_distance(left : Array[Double], right : Array[Double]) -> Double {
  let size = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  let mut total = 0.0
  for i in 0..<size {
    let delta = left[i] - right[i]
    total = total + delta * delta
  }
  total.sqrt()
}

///|
pub fn vector_add(left : Array[Double], right : Array[Double]) -> Array[Double] {
  if left.length() != right.length() {
    return []
  }
  let result = Array::make(left.length(), 0.0)
  for i in 0..<left.length() {
    result[i] = left[i] + right[i]
  }
  result
}

///|
pub fn vector_subtract(
  left : Array[Double],
  right : Array[Double],
) -> Array[Double] {
  if left.length() != right.length() {
    return []
  }
  let result = Array::make(left.length(), 0.0)
  for i in 0..<left.length() {
    result[i] = left[i] - right[i]
  }
  result
}

///|
pub fn vector_scale(value : Array[Double], factor : Double) -> Array[Double] {
  let result = Array::make(value.length(), 0.0)
  for i in 0..<value.length() {
    result[i] = value[i] * factor
  }
  result
}

///|
pub fn vector_normalize(value : Array[Double]) -> Array[Double] {
  let norm = vector_norm(value)
  if norm <= 1.0e-30 {
    Array::make(value.length(), 0.0)
  } else {
    vector_scale(value, 1.0 / norm)
  }
}

///|
pub fn vector_axpy(
  alpha : Double,
  x : Array[Double],
  y : Array[Double],
) -> Array[Double] {
  if x.length() != y.length() {
    return []
  }
  let result = y.copy()
  for i in 0..<x.length() {
    result[i] = alpha * x[i] + y[i]
  }
  result
}

///|
pub fn matrix_is_square(value : Matrix) -> Bool {
  value.rows == value.columns
}

///|
pub fn matrix_max_abs(value : Matrix) -> Double {
  let mut maximum = 0.0
  for item in value.values {
    if item.abs() > maximum {
      maximum = item.abs()
    }
  }
  maximum
}

///|
pub fn matrix_one_norm(value : Matrix) -> Double {
  let mut maximum = 0.0
  for column in 0..<value.columns {
    let mut total = 0.0
    for row in 0..<value.rows {
      total = total + value.values[row * value.columns + column].abs()
    }
    if total > maximum {
      maximum = total
    }
  }
  maximum
}

///|
pub fn matrix_diagonal(value : Matrix) -> Array[Double] {
  let size = if value.rows < value.columns { value.rows } else { value.columns }
  let result = Array::make(size, 0.0)
  for i in 0..<size {
    result[i] = value.values[i * value.columns + i]
  }
  result
}

///|
pub fn matrix_outer(left : Array[Double], right : Array[Double]) -> Matrix {
  let result = matrix_zero(left.length(), right.length())
  for row in 0..<left.length() {
    for column in 0..<right.length() {
      result.values[row * result.columns + column] = left[row] * right[column]
    }
  }
  result
}

///|
pub fn matrix_from_columns(columns : Array[Array[Double]]) -> Matrix {
  if columns.length() == 0 {
    return matrix_zero(0, 0)
  }
  let rows = columns[0].length()
  let result = matrix_zero(rows, columns.length())
  for column in 0..<columns.length() {
    if columns[column].length() != rows {
      return matrix_zero(0, 0)
    }
    for row in 0..<rows {
      result.values[row * result.columns + column] = columns[column][row]
    }
  }
  result
}

///|
pub fn matrix_from_rows(rows : Array[Array[Double]]) -> Matrix {
  if rows.length() == 0 {
    return matrix_zero(0, 0)
  }
  let columns = rows[0].length()
  let result = matrix_zero(rows.length(), columns)
  for row in 0..<rows.length() {
    if rows[row].length() != columns {
      return matrix_zero(0, 0)
    }
    for column in 0..<columns {
      result.values[row * columns + column] = rows[row][column]
    }
  }
  result
}

///|
pub fn matrix_power(value : Matrix, exponent : Int) -> Matrix {
  if !matrix_is_square(value) || exponent < 0 {
    return matrix_zero(0, 0)
  }
  let mut result = matrix_identity(value.rows)
  let mut base = value
  let mut power = exponent
  while power > 0 {
    if power % 2 == 1 {
      result = matrix_multiply(result, base)
    }
    base = matrix_multiply(base, base)
    power = power / 2
  }
  result
}

///|
pub fn matrix_symmetrize(value : Matrix) -> Matrix {
  if !matrix_is_square(value) {
    return matrix_zero(0, 0)
  }
  let result = value
  for row in 0..<value.rows {
    for column in 0..<row {
      let average = 0.5 *
        (matrix_get(value, row, column) + matrix_get(value, column, row))
      let _ = matrix_set(result, row, column, average)
      let _ = matrix_set(result, column, row, average)
    }
  }
  result
}

///|
pub fn matrix_replace_diagonal(
  value : Matrix,
  diagonal : Array[Double],
) -> Matrix {
  let result = value
  let size = if value.rows < value.columns { value.rows } else { value.columns }
  for i in 0..<size {
    if i < diagonal.length() {
      result.values[i * value.columns + i] = diagonal[i]
    }
  }
  result
}

///|
pub fn matrix_diagonal_shift(value : Matrix, shift : Double) -> Matrix {
  let result = value
  let size = if value.rows < value.columns { value.rows } else { value.columns }
  for i in 0..<size {
    result.values[i * value.columns + i] = result.values[i * value.columns + i] +
      shift
  }
  result
}

///|
pub fn lu_factor(value : Matrix, tolerance : Double) -> PivotedSystem {
  if !matrix_is_square(value) {
    return {
      upper: matrix_zero(0, 0),
      permutation: [],
      pivot_sign: 1,
      singular: true,
    }
  }
  let n = value.rows
  let upper = value
  let permutation = Array::make(n, 0)
  for i in 0..<n {
    permutation[i] = i
  }
  let tol = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  let mut pivot_sign = 1
  let mut singular = false
  for column in 0..<n {
    let mut pivot = column
    let mut largest = upper.values[column * n + column].abs()
    for row in (column + 1)..<n {
      let candidate = upper.values[row * n + column].abs()
      if candidate > largest {
        largest = candidate
        pivot = row
      }
    }
    if largest <= tol {
      singular = true
    } else {
      if pivot != column {
        for j in 0..<n {
          let tmp = upper.values[column * n + j]
          upper.values[column * n + j] = upper.values[pivot * n + j]
          upper.values[pivot * n + j] = tmp
        }
        let p = permutation[column]
        permutation[column] = permutation[pivot]
        permutation[pivot] = p
        pivot_sign = -pivot_sign
      }
      for row in (column + 1)..<n {
        upper.values[row * n + column] = upper.values[row * n + column] /
          upper.values[column * n + column]
        for j in (column + 1)..<n {
          upper.values[row * n + j] = upper.values[row * n + j] -
            upper.values[row * n + column] * upper.values[column * n + j]
        }
      }
    }
  }
  { upper, permutation, pivot_sign, singular }
}

///|
pub fn lu_solve(system : PivotedSystem, rhs : Array[Double]) -> Array[Double] {
  let n = system.upper.rows
  if system.singular || n == 0 || rhs.length() != n {
    return []
  }
  let lower = system.upper
  let permuted = Array::make(n, 0.0)
  for i in 0..<n {
    permuted[i] = rhs[system.permutation[i]]
  }
  let forward = Array::make(n, 0.0)
  for i in 0..<n {
    let mut value = permuted[i]
    for j in 0..<i {
      value = value - lower.values[i * n + j] * forward[j]
    }
    forward[i] = value
  }
  let solution = Array::make(n, 0.0)
  for i = n - 1; i >= 0; i = i - 1 {
    let mut value = forward[i]
    for j in (i + 1)..<n {
      value = value - lower.values[i * n + j] * solution[j]
    }
    let pivot = lower.values[i * n + i]
    if pivot.abs() <= 1.0e-30 {
      return []
    }
    solution[i] = value / pivot
  }
  solution
}

///|
pub fn matrix_inverse(value : Matrix, tolerance : Double) -> Matrix {
  if !matrix_is_square(value) {
    return matrix_zero(0, 0)
  }
  let n = value.rows
  let system = lu_factor(value, tolerance)
  if system.singular {
    return matrix_zero(0, 0)
  }
  let result = matrix_zero(n, n)
  for column in 0..<n {
    let rhs = Array::make(n, 0.0)
    rhs[column] = 1.0
    let solution = lu_solve(system, rhs)
    if solution.length() != n {
      return matrix_zero(0, 0)
    }
    for row in 0..<n {
      result.values[row * n + column] = solution[row]
    }
  }
  result
}

///|
pub fn matrix_determinant(value : Matrix, tolerance : Double) -> Double {
  if !matrix_is_square(value) {
    return 0.0
  }
  let system = lu_factor(value, tolerance)
  if system.singular {
    return 0.0
  }
  let mut result = system.pivot_sign.to_double()
  for i in 0..<value.rows {
    result = result * system.upper.values[i * value.rows + i]
  }
  result
}

///|
pub fn cholesky_factor(value : Matrix, tolerance : Double) -> CholeskySystem {
  if !matrix_is_square(value) {
    return { factor: matrix_zero(0, 0), positive_definite: false }
  }
  let n = value.rows
  let factor = matrix_zero(n, n)
  let tol = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  let mut valid = true
  for row in 0..<n {
    for column in 0..<(row + 1) {
      let mut sum = matrix_get(value, row, column)
      for k in 0..<column {
        sum = sum - factor.values[row * n + k] * factor.values[column * n + k]
      }
      if row == column {
        if sum <= tol {
          valid = false
        } else {
          factor.values[row * n + column] = sum.sqrt()
        }
      } else {
        let pivot = factor.values[column * n + column]
        if pivot.abs() <= tol {
          valid = false
        } else {
          factor.values[row * n + column] = sum / pivot
        }
      }
    }
  }
  { factor, positive_definite: valid }
}

///|
pub fn cholesky_solve(
  system : CholeskySystem,
  rhs : Array[Double],
) -> Array[Double] {
  let n = system.factor.rows
  if !system.positive_definite || rhs.length() != n {
    return []
  }
  let forward = Array::make(n, 0.0)
  for i in 0..<n {
    let mut value = rhs[i]
    for j in 0..<i {
      value = value - system.factor.values[i * n + j] * forward[j]
    }
    forward[i] = value / system.factor.values[i * n + i]
  }
  let result = Array::make(n, 0.0)
  for i = n - 1; i >= 0; i = i - 1 {
    let mut value = forward[i]
    for j in (i + 1)..<n {
      value = value - system.factor.values[j * n + i] * result[j]
    }
    result[i] = value / system.factor.values[i * n + i]
  }
  result
}

///|
pub fn gram_schmidt(
  value : Matrix,
  tolerance : Double,
) -> (Matrix, Matrix, Int) {
  let rows = value.rows
  let columns = value.columns
  let q = matrix_zero(rows, columns)
  let r = matrix_zero(columns, columns)
  let tol = if tolerance <= 0.0 { 1.0e-12 } else { tolerance }
  let mut rank = 0
  for column in 0..<columns {
    let vector = matrix_column(value, column)
    for previous in 0..<column {
      let basis = matrix_column(q, previous)
      let coefficient = vector_dot(vector, basis)
      r.values[previous * columns + column] = coefficient
      for row in 0..<rows {
        vector[row] = vector[row] - coefficient * basis[row]
      }
    }
    let norm = vector_norm(vector)
    r.values[column * columns + column] = norm
    if norm > tol {
      rank = rank + 1
      for row in 0..<rows {
        q.values[row * columns + column] = vector[row] / norm
      }
    }
  }
  (q, r, rank)
}

///|
pub fn least_squares_qr(
  design : Matrix,
  observations : Array[Double],
  tolerance : Double,
) -> LeastSquaresResult {
  if design.rows != observations.length() || design.columns == 0 {
    return {
      coefficients: [],
      residuals: [],
      residual_norm: 0.0,
      rank: 0,
      condition_estimate: 0.0,
    }
  }
  let (q, r, rank) = gram_schmidt(design, tolerance)
  let columns = design.columns
  let rhs = Array::make(columns, 0.0)
  for column in 0..<columns {
    rhs[column] = vector_dot(matrix_column(q, column), observations)
  }
  let coefficients = Array::make(columns, 0.0)
  for i = columns - 1; i >= 0; i = i - 1 {
    let mut value = rhs[i]
    for j in (i + 1)..<columns {
      value = value - r.values[i * columns + j] * coefficients[j]
    }
    let pivot = r.values[i * columns + i]
    coefficients[i] = if pivot.abs() <= 1.0e-30 { 0.0 } else { value / pivot }
  }
  let predicted = matrix_vector(design, coefficients)
  let residuals = Array::make(observations.length(), 0.0)
  for i in 0..<residuals.length() {
    residuals[i] = observations[i] - predicted[i]
  }
  let mut maximum = 0.0
  let mut minimum = 1.0e30
  for i in 0..<columns {
    let pivot = r.values[i * columns + i].abs()
    if pivot > maximum {
      maximum = pivot
    }
    if pivot > 1.0e-30 && pivot < minimum {
      minimum = pivot
    }
  }
  {
    coefficients,
    residuals,
    residual_norm: vector_norm(residuals),
    rank,
    condition_estimate: if minimum == 1.0e30 {
      1.0e30
    } else {
      maximum / minimum
    },
  }
}

///|
pub fn ridge_least_squares(
  design : Matrix,
  observations : Array[Double],
  regularization : Double,
  tolerance : Double,
) -> LeastSquaresResult {
  if design.rows != observations.length() || design.columns == 0 {
    return {
      coefficients: [],
      residuals: [],
      residual_norm: 0.0,
      rank: 0,
      condition_estimate: 0.0,
    }
  }
  let gram = matrix_multiply(matrix_transpose(design), design)
  let shifted = matrix_diagonal_shift(
    gram,
    if regularization < 0.0 {
      0.0
    } else {
      regularization
    },
  )
  let rhs = matrix_vector(matrix_transpose(design), observations)
  let system = lu_factor(shifted, tolerance)
  let coefficients = lu_solve(system, rhs)
  let safe_coefficients = if coefficients.length() == design.columns {
    coefficients
  } else {
    Array::make(design.columns, 0.0)
  }
  let predicted = matrix_vector(design, safe_coefficients)
  let residuals = Array::make(observations.length(), 0.0)
  for i in 0..<residuals.length() {
    residuals[i] = observations[i] - predicted[i]
  }
  {
    coefficients: safe_coefficients,
    residuals,
    residual_norm: vector_norm(residuals),
    rank: design.columns,
    condition_estimate: matrix_one_norm(shifted),
  }
}

///|
pub fn solve_normal_equations(
  design : Matrix,
  observations : Array[Double],
  regularization : Double,
) -> Array[Double] {
  ridge_least_squares(design, observations, regularization, 1.0e-12).coefficients
}

///|
pub fn jacobi_eigenpair(
  value : Matrix,
  iterations : Int,
  tolerance : Double,
) -> EigenPair {
  if !matrix_is_square(value) || value.rows == 0 {
    return { value: 0.0, vector: [], residual_norm: 0.0 }
  }
  let n = value.rows
  let working = matrix_symmetrize(value)
  let mut vector = Array::make(n, 0.0)
  vector[0] = 1.0
  let count = if iterations < 1 { 1 } else { iterations }
  for _ in 0..<count {
    let next = matrix_vector(working, vector)
    vector = vector_normalize(next)
    if vector_norm(vector) <= tolerance {
      break
    }
  }
  let transformed = matrix_vector(working, vector)
  let eigenvalue = vector_dot(vector, transformed)
  let residual = vector_distance(transformed, vector_scale(vector, eigenvalue))
  { value: eigenvalue, vector, residual_norm: residual }
}

///|
pub fn matrix_condition_estimate(value : Matrix, tolerance : Double) -> Double {
  let inverse = matrix_inverse(value, tolerance)
  if inverse.rows == 0 {
    1.0e30
  } else {
    matrix_one_norm(value) * matrix_one_norm(inverse)
  }
}

///|
pub fn matrix_regularize(value : Matrix, floor : Double) -> Matrix {
  let result = value
  let minimum = if floor <= 0.0 { 1.0e-12 } else { floor }
  let size = if value.rows < value.columns { value.rows } else { value.columns }
  for i in 0..<size {
    let diagonal = result.values[i * value.columns + i]
    if diagonal.abs() < minimum {
      result.values[i * value.columns + i] = if diagonal < 0.0 {
        -minimum
      } else {
        minimum
      }
    }
  }
  result
}

///|
pub fn covariance_from_residuals(
  design : Matrix,
  residuals : Array[Double],
  tolerance : Double,
) -> Matrix {
  if design.rows != residuals.length() || design.rows <= design.columns {
    return matrix_zero(design.columns, design.columns)
  }
  let gram_inverse = matrix_inverse(
    matrix_multiply(matrix_transpose(design), design),
    tolerance,
  )
  let variance = vector_dot(residuals, residuals) /
    (design.rows - design.columns).to_double()
  matrix_scale(gram_inverse, variance)
}

///|
pub fn standard_errors(covariance : Matrix) -> Array[Double] {
  let size = if covariance.rows < covariance.columns {
    covariance.rows
  } else {
    covariance.columns
  }
  let result = Array::make(size, 0.0)
  for i in 0..<size {
    result[i] = if covariance.values[i * covariance.columns + i] < 0.0 {
      0.0
    } else {
      covariance.values[i * covariance.columns + i].sqrt()
    }
  }
  result
}

///|
pub fn matrix_project(
  value : Array[Double],
  basis : Array[Array[Double]],
) -> Array[Double] {
  let result = Array::make(value.length(), 0.0)
  for item in basis {
    if item.length() == value.length() {
      let coefficient = vector_dot(value, item) /
        (vector_dot(item, item) + 1.0e-30)
      for i in 0..<value.length() {
        result[i] = result[i] + coefficient * item[i]
      }
    }
  }
  result
}

///|
pub fn vector_remove_mean(value : Array[Double]) -> Array[Double] {
  if value.length() == 0 {
    return []
  }
  let mut mean = 0.0
  for item in value {
    mean = mean + item
  }
  mean = mean / value.length().to_double()
  let result = value.copy()
  for i in 0..<result.length() {
    result[i] = result[i] - mean
  }
  result
}

///|
pub fn vector_correlation(
  left : Array[Double],
  right : Array[Double],
) -> Double {
  let a = vector_remove_mean(left)
  let b = vector_remove_mean(right)
  let denominator = vector_norm(a) * vector_norm(b)
  if denominator <= 1.0e-30 {
    0.0
  } else {
    vector_dot(a, b) / denominator
  }
}

///|
pub fn solve_tridiagonal(
  lower : Array[Double],
  diagonal : Array[Double],
  upper : Array[Double],
  rhs : Array[Double],
) -> Array[Double] {
  let n = diagonal.length()
  if n == 0 ||
    lower.length() != n - 1 ||
    upper.length() != n - 1 ||
    rhs.length() != n {
    return []
  }
  let c = Array::make(n - 1, 0.0)
  let d = Array::make(n, 0.0)
  let pivot = if diagonal[0].abs() < 1.0e-30 { 1.0e-30 } else { diagonal[0] }
  if n > 1 {
    c[0] = upper[0] / pivot
  }
  d[0] = rhs[0] / pivot
  for i in 1..<n {
    let denominator = diagonal[i] - lower[i - 1] * c[i - 1]
    let safe = if denominator.abs() < 1.0e-30 { 1.0e-30 } else { denominator }
    if i < n - 1 {
      c[i] = upper[i] / safe
    }
    d[i] = (rhs[i] - lower[i - 1] * d[i - 1]) / safe
  }
  let result = Array::make(n, 0.0)
  result[n - 1] = d[n - 1]
  for i = n - 2; i >= 0; i = i - 1 {
    result[i] = d[i] - c[i] * result[i + 1]
  }
  result
}
