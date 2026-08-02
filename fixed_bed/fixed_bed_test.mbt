///|
test "calculate_thomas_breakthrough" {
  // Let's assume some parameters
  let c_ratio = @fixed_bed.calculate_thomas_breakthrough(
    10.0, // t
     0.5, // k_th
     100.0, // q_0
     2.0, // w
     5.0, // q
     10.0, // c_0
  )

  // Exponent = (0.5 * 100 * 2 / 5) - (0.5 * 10 * 10) = 20 - 50 = -30
  // C/C0 = 1 / (1 + exp(-30)) ~ 1.0
  if !(c_ratio > 0.99) {
    panic()
  }
}

///|
test "estimate_thomas_time" {
  // To reach exactly 0.5 ratio, ln(1/0.5 - 1) = ln(1) = 0
  // t = (0.5 * 100 * 2 / 5) / (0.5 * 10) = 20 / 5 = 4
  let t = @fixed_bed.estimate_thomas_time(0.5, 0.5, 100.0, 2.0, 5.0, 10.0)
  if !(t > 3.99 && t < 4.01) {
    panic()
  }
}
