///|
/// Small dense matrix primitives for calibration and experimental design.
pub(all) struct Matrix {
  rows : Int
  columns : Int
  values : Array[Double]
} derive(Debug, Eq)

///|
pub fn matrix(rows : Int, columns : Int, values : Array[Double]) -> Matrix {
  let safe_rows = if rows < 0 { 0 } else { rows }
  let safe_columns = if columns < 0 { 0 } else { columns }
  let result = Array::make(safe_rows * safe_columns, 0.0)
  for i in 0..<result.length() {
    if i < values.length() {
      result[i] = values[i]
    }
  }
  { rows: safe_rows, columns: safe_columns, values: result }
}

///|
pub fn matrix_zero(rows : Int, columns : Int) -> Matrix {
  matrix(rows, columns, [])
}

///|
pub fn matrix_identity(size : Int) -> Matrix {
  let result = matrix_zero(size, size)
  for i in 0..<size {
    result.values[i * size + i] = 1.0
  }
  result
}

///|
pub fn matrix_get(value : Matrix, row : Int, column : Int) -> Double {
  if row < 0 || column < 0 || row >= value.rows || column >= value.columns {
    0.0
  } else {
    value.values[row * value.columns + column]
  }
}

///|
pub fn matrix_set(
  value : Matrix,
  row : Int,
  column : Int,
  item : Double,
) -> Matrix {
  if row >= 0 && column >= 0 && row < value.rows && column < value.columns {
    value.values[row * value.columns + column] = item
  }
  value
}

///|
pub fn matrix_add(left : Matrix, right : Matrix) -> Matrix {
  if left.rows != right.rows || left.columns != right.columns {
    return matrix_zero(0, 0)
  }
  let result = matrix_zero(left.rows, left.columns)
  for i in 0..<result.values.length() {
    result.values[i] = left.values[i] + right.values[i]
  }
  result
}

///|
pub fn matrix_subtract(left : Matrix, right : Matrix) -> Matrix {
  if left.rows != right.rows || left.columns != right.columns {
    return matrix_zero(0, 0)
  }
  let result = matrix_zero(left.rows, left.columns)
  for i in 0..<result.values.length() {
    result.values[i] = left.values[i] - right.values[i]
  }
  result
}

///|
pub fn matrix_scale(value : Matrix, factor : Double) -> Matrix {
  let result = matrix_zero(value.rows, value.columns)
  for i in 0..<result.values.length() {
    result.values[i] = value.values[i] * factor
  }
  result
}

///|
pub fn matrix_transpose(value : Matrix) -> Matrix {
  let result = matrix_zero(value.columns, value.rows)
  for row in 0..<value.rows {
    for column in 0..<value.columns {
      result.values[column * value.rows + row] = value.values[row *
        value.columns +
        column]
    }
  }
  result
}

///|
pub fn matrix_multiply(left : Matrix, right : Matrix) -> Matrix {
  if left.columns != right.rows {
    return matrix_zero(0, 0)
  }
  let result = matrix_zero(left.rows, right.columns)
  for row in 0..<left.rows {
    for column in 0..<right.columns {
      let mut total = 0.0
      for k in 0..<left.columns {
        total = total +
          left.values[row * left.columns + k] *
          right.values[k * right.columns + column]
      }
      result.values[row * result.columns + column] = total
    }
  }
  result
}

///|
pub fn matrix_vector(value : Matrix, vector : Array[Double]) -> Array[Double] {
  if value.columns != vector.length() {
    return []
  }
  let result = Array::make(value.rows, 0.0)
  for row in 0..<value.rows {
    for column in 0..<value.columns {
      result[row] = result[row] +
        value.values[row * value.columns + column] * vector[column]
    }
  }
  result
}

///|
pub fn matrix_trace(value : Matrix) -> Double {
  let size = if value.rows < value.columns { value.rows } else { value.columns }
  let mut total = 0.0
  for i in 0..<size {
    total = total + value.values[i * value.columns + i]
  }
  total
}

///|
pub fn matrix_frobenius(value : Matrix) -> Double {
  let mut total = 0.0
  for item in value.values {
    total = total + item * item
  }
  total.sqrt()
}

///|
pub fn determinant_2x2(value : Matrix) -> Double {
  if value.rows != 2 || value.columns != 2 {
    0.0
  } else {
    value.values[0] * value.values[3] - value.values[1] * value.values[2]
  }
}

///|
pub fn solve_2x2(value : Matrix, rhs : Array[Double]) -> Array[Double] {
  if value.rows != 2 || value.columns != 2 || rhs.length() != 2 {
    return []
  }
  let determinant = determinant_2x2(value)
  if determinant == 0.0 {
    return []
  }
  [
    (value.values[3] * rhs[0] - value.values[1] * rhs[1]) / determinant,
    (value.values[0] * rhs[1] - value.values[2] * rhs[0]) / determinant,
  ]
}

///|
pub fn normal_equations(points : Array[Point]) -> Matrix {
  let mut xx = 0.0
  let mut xy = 0.0
  let mut x = 0.0
  let mut y = 0.0
  for point in points {
    xx = xx + point.x * point.x
    xy = xy + point.x * point.y
    x = x + point.x
    y = y + point.y
  }
  matrix(2, 2, [xx, x, x, points.length().to_double()])
}

///|
pub fn normal_rhs(points : Array[Point]) -> Array[Double] {
  let mut xy = 0.0
  let mut y = 0.0
  for point in points {
    xy = xy + point.x * point.y
    y = y + point.y
  }
  [xy, y]
}

///|
pub fn solve_linear_fit(points : Array[Point]) -> LinearRegressionResult {
  if points.length() < 2 {
    return { slope: 0.0, intercept: 0.0, r_squared: 0.0 }
  }
  let solution = solve_2x2(normal_equations(points), normal_rhs(points))
  if solution.length() != 2 {
    linear_regression(points)
  } else {
    let estimate = []
    for point in points {
      estimate.push(solution[0] * point.x + solution[1])
    }
    {
      slope: solution[0],
      intercept: solution[1],
      r_squared: r_squared(points.map(fn(p) { p.y }), estimate),
    }
  }
}

///|
pub fn matrix_row(value : Matrix, row : Int) -> Array[Double] {
  if row < 0 || row >= value.rows {
    return []
  }
  let result = Array::make(value.columns, 0.0)
  for column in 0..<value.columns {
    result[column] = value.values[row * value.columns + column]
  }
  result
}

///|
pub fn matrix_column(value : Matrix, column : Int) -> Array[Double] {
  if column < 0 || column >= value.columns {
    return []
  }
  let result = Array::make(value.rows, 0.0)
  for row in 0..<value.rows {
    result[row] = value.values[row * value.columns + column]
  }
  result
}

///|
pub fn matrix_is_symmetric(value : Matrix, tolerance : Double) -> Bool {
  if value.rows != value.columns {
    false
  } else {
    let mut ok = true
    for row in 0..<value.rows {
      for column in 0..<row {
        if (value.values[row * value.columns + column] -
          value.values[column * value.columns + row]).abs() >
          tolerance {
          ok = false
        }
      }
    }
    ok
  }
}

///|
pub fn matrix_condition_proxy(value : Matrix) -> Double {
  let norm = matrix_frobenius(value)
  let diagonal = value.rows + value.columns
  if diagonal == 0 {
    0.0
  } else {
    norm / diagonal.to_double()
  }
}
