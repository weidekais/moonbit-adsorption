///|
/// Formats an array of points into a CSV string.
pub fn to_csv(points : Array[Point], header? : String = "x,y") -> String {
  let mut csv = header + "\n"
  for p in points {
    csv = csv + "\{p.x},\{p.y}\n"
  }
  csv
}
