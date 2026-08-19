///|
/// Boundary and integration tests for extended equilibrium models.
test "extended equilibrium models" {
  let point = thermodynamic_point(298.15, 4.0, 1.0)
  inspect(point.temperature > 298.0, content="true")
  inspect(predict_henry(2.0, 0.0) == 0.0, content="true")
  inspect(predict_hill(10.0, 2.0, 1.0, 1.0) > 0.0, content="true")
  inspect(
    predict_fowler_guggenheim(10.0, 1.0, 0.5, 1.0, 20) > 0.0,
    content="true",
  )
  inspect(
    temperature_corrected_affinity(1.0, -10000.0, 298.15, 308.15) > 0.0,
    content="true",
  )
}

///|
test "competitive loading boundaries" {
  let components = [
    mixture_component("A", 1.0, 10.0, 2.0, 1.0),
    mixture_component("B", 2.0, 8.0, 1.0, 1.0),
  ]
  let loading = competitive_langmuir_loading(components)
  inspect(loading.loadings.length(), content="2")
  inspect(loading.total_loading > 0.0, content="true")
  inspect(mixture_selectivity(loading, 0, 1) > 0.0, content="true")
  let sips = competitive_sips_loading(components)
  inspect(mixture_normalized_loadings(sips).length(), content="2")
}

///|
test "batch equilibrium and diagnostics" {
  let batch = batch_single_component(5.0, 1.0, 1.0, fn(c) { 0.5 * c }, 1.0e-8)
  inspect(batch.final_concentrations.length(), content="1")
  inspect(batch.final_concentrations[0] >= 0.0, content="true")
  let observed = [1.0, 2.0, 3.0, 4.0]
  let predicted = [1.1, 1.9, 3.1, 3.9]
  let diagnostics = diagnostic_fit(observed, predicted, [0.1, 0.5, 1.0, 2.0])
  inspect(diagnostics.rmse < 0.2, content="true")
  inspect(diagnostic_outliers(diagnostics, 5.0).length() == 0, content="true")
  let score = model_score("baseline", 2, observed, predicted, [
    0.1, 0.5, 1.0, 2.0,
  ])
  inspect(score.observations == 4, content="true")
}
