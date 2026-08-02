# moonbit-adsorption

A comprehensive MoonBit library for adsorption processes, focusing on parameter fitting for isotherm models and fixed-bed breakthrough curve calculations.

## Features

- **Isotherm Models**: Langmuir, Freundlich, and Temkin models. Parameter fitting via linear regression.
- **Fixed Bed Models**: Simplified Thomas model and Yoon-Nelson model parameters, breakthrough time estimations.
- **Utils**: General purpose linear regression, point struct, and exporting tools.

## Example

```mbt check
test {
  // Example of using Langmuir adsorption model
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

```mbt check
test {
  // Example of using fixed-bed Thomas model
  let c_ratio = @fixed_bed.calculate_thomas_breakthrough(
    10.0, // t
    0.5, // k_th
    100.0, // q_0
    2.0, // w
    5.0, // q
    10.0 // c_0
  )
  inspect(c_ratio > 0.99, content="true")
}
```

## License
Apache-2.0
