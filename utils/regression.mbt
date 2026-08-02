///|
/// Represents a point in 2D space.
pub(all) struct Point {
  x : Double
  y : Double
} derive(Show, Debug, Eq)

///|
/// Represents the result of a linear regression.
pub(all) struct LinearRegressionResult {
  /// The slope of the line (a in y = ax + b)
  slope : Double
  /// The intercept of the line (b in y = ax + b)
  intercept : Double
  /// The coefficient of determination (R^2)
  r_squared : Double
} derive(Show, Debug, Eq)

///|
/// Performs linear regression on a set of points.
/// Returns the slope, intercept, and R^2 value.
/// 
/// Panics if the number of points is less than 2.
pub fn linear_regression(points : Array[Point]) -> LinearRegressionResult {
  if points.length() < 2 {
    panic()
  }
  let n = points.length().to_double()
  let mut sum_x = 0.0
  let mut sum_y = 0.0
  let mut sum_xy = 0.0
  let mut sum_xx = 0.0
  
  for p in points {
    sum_x = sum_x + p.x
    sum_y = sum_y + p.y
    sum_xy = sum_xy + p.x * p.y
    sum_xx = sum_xx + p.x * p.x
  }
  
  let mean_x = sum_x / n
  let mean_y = sum_y / n
  
  // Calculate slope (a) and intercept (b)
  let denominator = n * sum_xx - sum_x * sum_x
  
  let slope = if denominator == 0.0 {
    0.0
  } else {
    (n * sum_xy - sum_x * sum_y) / denominator
  }
  
  let intercept = mean_y - slope * mean_x
  
  // Calculate R^2
  let mut ss_tot = 0.0
  let mut ss_res = 0.0
  for p in points {
    let y_pred = slope * p.x + intercept
    let d_tot = p.y - mean_y
    ss_tot = ss_tot + d_tot * d_tot
    let d_res = p.y - y_pred
    ss_res = ss_res + d_res * d_res
  }
  
  let r_squared = if ss_tot == 0.0 {
    1.0
  } else {
    1.0 - ss_res / ss_tot
  }
  
  { slope, intercept, r_squared }
}
