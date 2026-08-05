# moonbit-adsorption

A comprehensive, high-performance MoonBit library for adsorption processes, featuring:
- **Rigorous Parameter Fitting**: Direct Non-Linear Least Squares (NLLS) optimization of isotherm parameters using the derivative-free Nelder-Mead simplex algorithm.
- **Process Simulation Boundary**: Dynamic numerical simulation of 1D fixed-bed column breakthrough curves using the Finite Difference Method (FDM) and Runge-Kutta 4th-order (RK4) time integration.

## Features

- **Isotherm Models**: Langmuir, Freundlich, and Temkin models. Supports robust fitting starting from linearized regression initialization to find the global optimum.
- **Fixed Bed Simulation**:
  - *Analytical Models*: Simplified Thomas and Yoon-Nelson models.
  - *Dynamic Numerical Simulation*: Solves the 1D convection-adsorption PDE mass-balance system with the Linear Driving Force (LDF) kinetics model. Supports time-varying feed concentrations $C_{feed}(t)$.
- **Utils**: Nelder-Mead multi-dimensional optimizer, linear regression, and exporting tools.

## Example

### Isotherm Parameter Fitting (NLLS)

```mbt check
test {
  // Example of using Langmuir adsorption model fitting
  let data = [
    @isotherm.AdsorptionData::{ c: 1.0, q: 5.0 / 1.5 },
    @isotherm.AdsorptionData::{ c: 2.0, q: 10.0 / 2.0 },
    @isotherm.AdsorptionData::{ c: 4.0, q: 20.0 / 3.0 },
    @isotherm.AdsorptionData::{ c: 8.0, q: 40.0 / 5.0 },
  ]
  
  let params = @isotherm.fit_langmuir(data)
  inspect(params.q_m > 9.9 && params.q_m < 10.1, content="true")
  inspect(params.k_l > 0.49 && params.k_l < 0.51, content="true")
}
```

### Dynamic Fixed-Bed Column Simulation

```mbt check
test {
  // Example of running dynamic column simulation
  let config = @fixed_bed.ColumnSimulationConfig::{
    bed_length: 10.0,
    velocity: 2.0,
    porosity: 0.4,
    bulk_density: 0.8,
    ldf_coefficient: 0.5,
    grid_points: 11,
    time_step: 0.05,
    total_time: 1.0,
  }
  
  let isotherm = fn(c : Double) -> Double {
    let q_m = 10.0
    let k_l = 0.5
    q_m * k_l * c / (1.0 + k_l * c)
  }
  
  // Feed concentration constant at 10.0 mg/L
  let feed = fn(_t : Double) -> Double {
    10.0
  }
  
  let res = @fixed_bed.simulate_column(config, isotherm, feed)
  inspect(res.final_concentration_profile.length() == 11, content="true")
}
```

## License
Apache-2.0

