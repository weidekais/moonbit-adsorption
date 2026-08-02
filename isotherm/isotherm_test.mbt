///|
test "fit_langmuir basic" {
  // Let's create some data points that perfectly fit a Langmuir model
  // q_m = 10.0, k_l = 0.5
  // q = 5.0 * c / (1 + 0.5 * c)
  let data = [
    @isotherm.AdsorptionData::{ c: 1.0, q: 5.0 / 1.5 },
    @isotherm.AdsorptionData::{ c: 2.0, q: 10.0 / 2.0 },
    @isotherm.AdsorptionData::{ c: 4.0, q: 20.0 / 3.0 },
    @isotherm.AdsorptionData::{ c: 8.0, q: 40.0 / 5.0 },
  ]
  let params = @isotherm.fit_langmuir(data)
  // Due to floating point math, check boundaries
  if !(params.q_m > 9.9 && params.q_m < 10.1) { panic() }
  if !(params.k_l > 0.49 && params.k_l < 0.51) { panic() }
  
  let pred = @isotherm.predict_langmuir(params, 2.0)
  if !(pred > 4.9 && pred < 5.1) { panic() }
}

///|
test "fit_freundlich basic" {
  // K_F = 2.0, n = 2.0
  // q = 2.0 * c^0.5
  let data = [
    @isotherm.AdsorptionData::{ c: 1.0, q: 2.0 },
    @isotherm.AdsorptionData::{ c: 4.0, q: 4.0 },
    @isotherm.AdsorptionData::{ c: 9.0, q: 6.0 },
    @isotherm.AdsorptionData::{ c: 16.0, q: 8.0 },
  ]
  let params = @isotherm.fit_freundlich(data)
  if !(params.k_f > 1.9 && params.k_f < 2.1) { panic() }
  if !(params.n > 1.9 && params.n < 2.1) { panic() }
  
  let pred = @isotherm.predict_freundlich(params, 4.0)
  if !(pred > 3.9 && pred < 4.1) { panic() }
}

///|
test "fit_temkin basic" {
  // B = 3.0, A_T = 2.0
  // q = 3.0 * ln(2.0 * C)
  let data = [
    @isotherm.AdsorptionData::{ c: 0.5, q: 3.0 * @math.ln(1.0) },
    @isotherm.AdsorptionData::{ c: 1.0, q: 3.0 * @math.ln(2.0) },
    @isotherm.AdsorptionData::{ c: 5.0, q: 3.0 * @math.ln(10.0) },
  ]
  let params = @isotherm.fit_temkin(data)
  if !(params.b > 2.9 && params.b < 3.1) { panic() }
  if !(params.a_t > 1.9 && params.a_t < 2.1) { panic() }
  
  let pred = @isotherm.predict_temkin(params, 1.0)
  if !(pred > 3.0 * @math.ln(2.0) - 0.01 && pred < 3.0 * @math.ln(2.0) + 0.01) { panic() }
}
