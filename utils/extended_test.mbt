///|
test "statistics empty" {
  inspect(@utils.summarize([]).count, content="0")
  inspect(@utils.linspace(2.0, 2.0, 3).length(), content="3")
  inspect(@utils.percentile([], 0.5), content="0")
}

///|
test "statistics boundary 0" {
  let xs = [1.0, 2.0, 3.0]
  let ys = [2.0, 3.0, 5.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 1" {
  let xs = [2.0, 3.0, 5.0]
  let ys = [3.0, 5.0, 8.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 2" {
  let xs = [3.0, 4.0, 7.0]
  let ys = [4.0, 7.0, 11.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 3" {
  let xs = [4.0, 5.0, 9.0]
  let ys = [5.0, 9.0, 14.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 4" {
  let xs = [5.0, 6.0, 11.0]
  let ys = [6.0, 11.0, 17.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 5" {
  let xs = [6.0, 7.0, 13.0]
  let ys = [7.0, 13.0, 20.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 6" {
  let xs = [7.0, 8.0, 15.0]
  let ys = [8.0, 15.0, 23.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 7" {
  let xs = [1.0, 9.0, 10.0]
  let ys = [9.0, 10.0, 19.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 8" {
  let xs = [2.0, 10.0, 12.0]
  let ys = [10.0, 12.0, 22.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 9" {
  let xs = [3.0, 11.0, 14.0]
  let ys = [11.0, 14.0, 25.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 10" {
  let xs = [4.0, 12.0, 16.0]
  let ys = [12.0, 16.0, 28.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 11" {
  let xs = [5.0, 2.0, 7.0]
  let ys = [2.0, 7.0, 9.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 12" {
  let xs = [6.0, 3.0, 9.0]
  let ys = [3.0, 9.0, 12.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 13" {
  let xs = [7.0, 4.0, 11.0]
  let ys = [4.0, 11.0, 15.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 14" {
  let xs = [1.0, 5.0, 6.0]
  let ys = [5.0, 6.0, 11.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 15" {
  let xs = [2.0, 6.0, 8.0]
  let ys = [6.0, 8.0, 14.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 16" {
  let xs = [3.0, 7.0, 10.0]
  let ys = [7.0, 10.0, 17.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 17" {
  let xs = [4.0, 8.0, 12.0]
  let ys = [8.0, 12.0, 20.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 18" {
  let xs = [5.0, 9.0, 14.0]
  let ys = [9.0, 14.0, 23.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 19" {
  let xs = [6.0, 10.0, 16.0]
  let ys = [10.0, 16.0, 26.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 20" {
  let xs = [7.0, 11.0, 18.0]
  let ys = [11.0, 18.0, 29.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 21" {
  let xs = [1.0, 12.0, 13.0]
  let ys = [12.0, 13.0, 25.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 22" {
  let xs = [2.0, 2.0, 4.0]
  let ys = [2.0, 4.0, 6.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 23" {
  let xs = [3.0, 3.0, 6.0]
  let ys = [3.0, 6.0, 9.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 24" {
  let xs = [4.0, 4.0, 8.0]
  let ys = [4.0, 8.0, 12.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 25" {
  let xs = [5.0, 5.0, 10.0]
  let ys = [5.0, 10.0, 15.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 26" {
  let xs = [6.0, 6.0, 12.0]
  let ys = [6.0, 12.0, 18.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 27" {
  let xs = [7.0, 7.0, 14.0]
  let ys = [7.0, 14.0, 21.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 28" {
  let xs = [1.0, 8.0, 9.0]
  let ys = [8.0, 9.0, 17.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 29" {
  let xs = [2.0, 9.0, 11.0]
  let ys = [9.0, 11.0, 20.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 30" {
  let xs = [3.0, 10.0, 13.0]
  let ys = [10.0, 13.0, 23.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 31" {
  let xs = [4.0, 11.0, 15.0]
  let ys = [11.0, 15.0, 26.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 32" {
  let xs = [5.0, 12.0, 17.0]
  let ys = [12.0, 17.0, 29.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 33" {
  let xs = [6.0, 2.0, 8.0]
  let ys = [2.0, 8.0, 10.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 34" {
  let xs = [7.0, 3.0, 10.0]
  let ys = [3.0, 10.0, 13.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 35" {
  let xs = [1.0, 4.0, 5.0]
  let ys = [4.0, 5.0, 9.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 36" {
  let xs = [2.0, 5.0, 7.0]
  let ys = [5.0, 7.0, 12.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 37" {
  let xs = [3.0, 6.0, 9.0]
  let ys = [6.0, 9.0, 15.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 38" {
  let xs = [4.0, 7.0, 11.0]
  let ys = [7.0, 11.0, 18.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 39" {
  let xs = [5.0, 8.0, 13.0]
  let ys = [8.0, 13.0, 21.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 40" {
  let xs = [6.0, 9.0, 15.0]
  let ys = [9.0, 15.0, 24.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 41" {
  let xs = [7.0, 10.0, 17.0]
  let ys = [10.0, 17.0, 27.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 42" {
  let xs = [1.0, 11.0, 12.0]
  let ys = [11.0, 12.0, 23.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 43" {
  let xs = [2.0, 12.0, 14.0]
  let ys = [12.0, 14.0, 26.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 44" {
  let xs = [3.0, 2.0, 5.0]
  let ys = [2.0, 5.0, 7.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 45" {
  let xs = [4.0, 3.0, 7.0]
  let ys = [3.0, 7.0, 10.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 46" {
  let xs = [5.0, 4.0, 9.0]
  let ys = [4.0, 9.0, 13.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 47" {
  let xs = [6.0, 5.0, 11.0]
  let ys = [5.0, 11.0, 16.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 48" {
  let xs = [7.0, 6.0, 13.0]
  let ys = [6.0, 13.0, 19.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 49" {
  let xs = [1.0, 7.0, 8.0]
  let ys = [7.0, 8.0, 15.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 50" {
  let xs = [2.0, 8.0, 10.0]
  let ys = [8.0, 10.0, 18.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 51" {
  let xs = [3.0, 9.0, 12.0]
  let ys = [9.0, 12.0, 21.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 52" {
  let xs = [4.0, 10.0, 14.0]
  let ys = [10.0, 14.0, 24.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 53" {
  let xs = [5.0, 11.0, 16.0]
  let ys = [11.0, 16.0, 27.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 54" {
  let xs = [6.0, 12.0, 18.0]
  let ys = [12.0, 18.0, 30.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 55" {
  let xs = [7.0, 2.0, 9.0]
  let ys = [2.0, 9.0, 11.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 56" {
  let xs = [1.0, 3.0, 4.0]
  let ys = [3.0, 4.0, 7.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 57" {
  let xs = [2.0, 4.0, 6.0]
  let ys = [4.0, 6.0, 10.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 58" {
  let xs = [3.0, 5.0, 8.0]
  let ys = [5.0, 8.0, 13.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 59" {
  let xs = [4.0, 6.0, 10.0]
  let ys = [6.0, 10.0, 16.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 60" {
  let xs = [5.0, 7.0, 12.0]
  let ys = [7.0, 12.0, 19.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 61" {
  let xs = [6.0, 8.0, 14.0]
  let ys = [8.0, 14.0, 22.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 62" {
  let xs = [7.0, 9.0, 16.0]
  let ys = [9.0, 16.0, 25.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 63" {
  let xs = [1.0, 10.0, 11.0]
  let ys = [10.0, 11.0, 21.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 64" {
  let xs = [2.0, 11.0, 13.0]
  let ys = [11.0, 13.0, 24.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 65" {
  let xs = [3.0, 12.0, 15.0]
  let ys = [12.0, 15.0, 27.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 66" {
  let xs = [4.0, 2.0, 6.0]
  let ys = [2.0, 6.0, 8.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 67" {
  let xs = [5.0, 3.0, 8.0]
  let ys = [3.0, 8.0, 11.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 68" {
  let xs = [6.0, 4.0, 10.0]
  let ys = [4.0, 10.0, 14.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 69" {
  let xs = [7.0, 5.0, 12.0]
  let ys = [5.0, 12.0, 17.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 70" {
  let xs = [1.0, 6.0, 7.0]
  let ys = [6.0, 7.0, 13.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 71" {
  let xs = [2.0, 7.0, 9.0]
  let ys = [7.0, 9.0, 16.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 72" {
  let xs = [3.0, 8.0, 11.0]
  let ys = [8.0, 11.0, 19.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 73" {
  let xs = [4.0, 9.0, 13.0]
  let ys = [9.0, 13.0, 22.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 74" {
  let xs = [5.0, 10.0, 15.0]
  let ys = [10.0, 15.0, 25.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 75" {
  let xs = [6.0, 11.0, 17.0]
  let ys = [11.0, 17.0, 28.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 76" {
  let xs = [7.0, 12.0, 19.0]
  let ys = [12.0, 19.0, 31.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 77" {
  let xs = [1.0, 2.0, 3.0]
  let ys = [2.0, 3.0, 5.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 78" {
  let xs = [2.0, 3.0, 5.0]
  let ys = [3.0, 5.0, 8.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "statistics boundary 79" {
  let xs = [3.0, 4.0, 7.0]
  let ys = [4.0, 7.0, 11.0]
  inspect(@utils.mae(xs, ys) >= 0.0, content="true")
  inspect(@utils.rmse(xs, ys) >= 0.0, content="true")
  inspect(@utils.correlation(xs, xs) > 0.99, content="true")
  inspect(@utils.strictly_increasing([1.0, 2.0, 3.0]), content="true")
}

///|
test "series and matrix 0" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 1" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 2" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 3" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 4" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 5" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 6" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 7" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 8" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 9" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 10" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 11" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 12" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 13" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 14" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 15" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 16" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 17" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 18" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 19" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 20" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 21" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 22" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 23" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 24" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 25" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 26" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 27" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 28" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 29" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 30" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 31" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 32" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 33" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 34" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 35" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 36" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 37" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 38" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 39" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 40" {
  let values = @utils.linspace(0.0, 1.0, 2)
  inspect(@utils.moving_average(values, 2).length(), content="2")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 41" {
  let values = @utils.linspace(0.0, 2.0, 3)
  inspect(@utils.moving_average(values, 2).length(), content="3")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 42" {
  let values = @utils.linspace(0.0, 3.0, 4)
  inspect(@utils.moving_average(values, 2).length(), content="4")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 43" {
  let values = @utils.linspace(0.0, 4.0, 5)
  inspect(@utils.moving_average(values, 2).length(), content="5")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}

///|
test "series and matrix 44" {
  let values = @utils.linspace(0.0, 5.0, 6)
  inspect(@utils.moving_average(values, 2).length(), content="6")
  inspect(@utils.matrix_trace(@utils.matrix_identity(2)), content="2")
  inspect(@utils.matrix_get(@utils.matrix_identity(2), 0, 1), content="0")
}
