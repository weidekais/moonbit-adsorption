///|
/// Calculates the breakthrough time using the Yoon-Nelson or Thomas model simplified forms.
/// We use a simplified Thomas model here for demonstration:
/// C/C0 = 1 / (1 + exp((k_th * q_0 * w / Q) - k_th * C_0 * t))
/// Where:
/// k_th = Thomas rate constant
/// q_0 = Adsorption capacity (mg/g)
/// w = Mass of adsorbent (g)
/// q = Volumetric flow rate (mL/min)
/// c_0 = Initial concentration (mg/L)
/// t = Time (min)
pub fn calculate_thomas_breakthrough(
  t : Double,
  k_th : Double,
  q_0 : Double,
  w : Double,
  q : Double,
  c_0 : Double
) -> Double {
  let exponent = (k_th * q_0 * w / q) - (k_th * c_0 * t)
  1.0 / (1.0 + @math.exp(exponent))
}

///|
/// Estimates the breakthrough time at a specific C/C0 ratio.
pub fn estimate_thomas_time(
  ratio : Double,
  k_th : Double,
  q_0 : Double,
  w : Double,
  q : Double,
  c_0 : Double
) -> Double {
  if ratio <= 0.0 || ratio >= 1.0 {
    0.0
  } else {
    // ln((1/(C/C0)) - 1) = (k_th * q_0 * w / Q) - k_th * C_0 * t
    // t = [ (k_th * q_0 * w / Q) - ln(1/ratio - 1) ] / (k_th * C_0)
    let ln_term = @math.ln((1.0 / ratio) - 1.0)
    let term1 = (k_th * q_0 * w) / q
    (term1 - ln_term) / (k_th * c_0)
  }
}
