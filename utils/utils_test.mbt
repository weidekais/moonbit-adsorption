///|
test "linear_regression simple" {
  let points = [
    @utils.Point::{ x: 1.0, y: 2.0 },
    @utils.Point::{ x: 2.0, y: 4.0 },
    @utils.Point::{ x: 3.0, y: 6.0 },
  ]
  let result = @utils.linear_regression(points)
  inspect(result.slope, content="2")
  inspect(result.intercept, content="0")
  inspect(result.r_squared, content="1")
}

///|
test "linear_regression with noise" {
  let points = [
    @utils.Point::{ x: 0.0, y: 1.0 },
    @utils.Point::{ x: 1.0, y: 2.1 },
    @utils.Point::{ x: 2.0, y: 2.9 },
    @utils.Point::{ x: 3.0, y: 4.2 },
  ]
  let result = @utils.linear_regression(points)
  // Check approximate values
  if !(result.slope > 0.9 && result.slope < 1.1) {
    panic()
  }
  if !(result.intercept > 0.8 && result.intercept < 1.2) {
    panic()
  }
  if !(result.r_squared > 0.95) {
    panic()
  }
}

///|
test "panic linear_regression empty" {
  let points : Array[@utils.Point] = []
  ignore(@utils.linear_regression(points))
}

///|
test "nelder_mead optimization" {
  // Test function: f(x, y) = (x - 3.0)^2 + (y - 5.0)^2 + 10.0
  // Minimum should be at [3.0, 5.0]
  let f = fn(params : Array[Double]) -> Double {
    let x = params[0]
    let y = params[1]
    (x - 3.0) * (x - 3.0) + (y - 5.0) * (y - 5.0) + 10.0
  }
  let init_guess = [0.0, 0.0]
  let result = @utils.nelder_mead(f, init_guess, 1.0e-6, 1000)

  if !(result[0] > 2.99 && result[0] < 3.01) {
    panic()
  }
  if !(result[1] > 4.99 && result[1] < 5.01) {
    panic()
  }
}
