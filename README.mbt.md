# moonbit-adsorption

A pure MoonBit library for adsorption equilibrium models, batch kinetics, and fixed-bed column analysis. It is designed for reproducible calculations in water treatment, gas purification, materials characterization, and adsorption-process engineering.

## Project positioning

The library provides composable numerical building blocks rather than a single application workflow:

- fit adsorption models directly in the original physical space;
- evaluate batch-kinetic and equilibrium curves;
- simulate one-dimensional fixed-bed breakthrough behavior;
- derive engineering metrics from experimental or simulated curves;
- keep the core implementation portable across MoonBit targets.

## Core capabilities

### Equilibrium models

Langmuir, Freundlich, Temkin, Sips, Toth, Redlich–Peterson, BET, Dubinin–Radushkevich, Halsey, and Harkin–Jura prediction and fitting APIs.

### Kinetic models

Pseudo-first-order, pseudo-second-order, Elovich, and intraparticle-diffusion models, including parameter fitting, initial-rate calculations, half-time estimates, and regression metrics.

### Fixed-bed analysis

Thomas, Yoon–Nelson, Clark, and BDST equations; breakthrough interpolation; 5%, 10%, 50%, and 90% threshold times; treated volume; removal-capacity estimates; MTZ, EBCT, Ergun pressure drop, and common dimensionless groups.

### Numerical utilities

Nelder–Mead optimization, linear regression, error metrics, descriptive statistics, interpolation, smoothing, dense-matrix operations, experiment design, and sensitivity analysis.

## Quick start

Install the module in a MoonBit project:

```bash
moon add weidekais/moonbit-adsorption
```

Run the checks and tests:

```bash
moon check
moon test
```

Fit a Langmuir model:

```mbt check
test {
  let data = [
    @isotherm.AdsorptionData::{ c: 1.0, q: 3.3333333333 },
    @isotherm.AdsorptionData::{ c: 2.0, q: 5.0 },
    @isotherm.AdsorptionData::{ c: 4.0, q: 6.6666666667 },
    @isotherm.AdsorptionData::{ c: 8.0, q: 8.0 },
  ]
  let result = @isotherm.fit_langmuir(data)
  inspect(result.q_m > 9.9 && result.q_m < 10.1, content="true")
  inspect(result.k_l > 0.49 && result.k_l < 0.51, content="true")
}
```

## Command-line example

The repository includes a runnable benchmark and end-to-end example:

```bash
moon run --target native benchmarks
```

The example fits equilibrium data, runs a fixed-bed simulation, and prints the resulting breakthrough metrics. It is intended as a small executable reference for integrating the library into a command-line workflow.

## Architecture

```text
utils/
  optimization, regression, statistics, validation, matrix, series, experiment design
isotherm/
  equilibrium models, kinetic models, fitting, model comparison
fixed_bed/
  dynamic column simulation, breakthrough analysis, engineering design helpers
benchmarks/
  runnable native example and reproducible numerical workload
```

The package boundaries follow the computational flow: `utils` provides reusable numerical primitives, `isotherm` owns equilibrium and batch-kinetic models, and `fixed_bed` consumes model callbacks to simulate and analyze column behavior.

## Benchmark

The benchmark uses five Langmuir observations and a fixed-bed workload with 51 spatial grid points and 1,000 time steps. One local Windows native run produced:

| Measurement | Result |
| --- | ---: |
| fitted `q_m` | 10.000000000024196 |
| fitted `k_l` | 0.499999999996915 |
| `R²` | 1 |
| simulation steps | 1,000 |
| 50% breakthrough time | 9.99 |
| removal-capacity metric | 199.1335926829373 |
| end-to-end command time | 1,781.84 ms |

Numerical outputs are the stable reference values. End-to-end time depends on the host, compiler cache, and first-build state.

## Tests

Run the complete local validation sequence:

```bash
moon fmt --check
moon check --target all --deny-warn
moon test --target all --deny-warn
moon info
git diff --exit-code
```

The test suite covers equilibrium fitting, kinetic fitting, optimizer behavior, fixed-bed simulation, breakthrough metrics, numerical utilities, invalid inputs, and boundary conditions.

## CI

GitHub Actions runs on Ubuntu, macOS, and Windows. The workflow installs the current MoonBit stable toolchain using the official platform installers and runs:

- `moon fmt --check`;
- `moon check --target all --deny-warn`;
- `moon test --target all --deny-warn`;
- native regression tests;
- generated public-interface checks;
- the runnable benchmark.

## License

Apache-2.0. See [LICENSE](LICENSE).

