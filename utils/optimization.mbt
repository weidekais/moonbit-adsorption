///|
priv struct SimplexPoint {
  params : Array[Double]
  mut score : Double
}

///|
fn sort_simplex(arr : Array[SimplexPoint]) -> Unit {
  for i = 1; i < arr.length(); i = i + 1 {
    let mut j = i
    while j > 0 && arr[j].score < arr[j - 1].score {
      let temp = arr[j]
      arr[j] = arr[j - 1]
      arr[j - 1] = temp
      j = j - 1
    }
  }
}

///|
/// Minimizes a function f using the Nelder-Mead simplex algorithm.
/// `init_guess`: the initial parameters.
/// `tol`: standard deviation tolerance of the simplex scores for convergence.
/// `max_iter`: maximum number of iterations.
pub fn nelder_mead(
  f : (Array[Double]) -> Double,
  init_guess : Array[Double],
  tol : Double,
  max_iter : Int,
) -> Array[Double] {
  let dim = init_guess.length()
  let num_points = dim + 1
  let simplex = Array::new(capacity=num_points)

  // 1. Initialize simplex
  simplex.push({ params: init_guess.copy(), score: f(init_guess) })

  for i = 0; i < dim; i = i + 1 {
    let p = init_guess.copy()
    let step = if p[i] == 0.0 { 0.05 } else { p[i] * 0.05 }
    p[i] = p[i] + step
    simplex.push({ params: p, score: f(p) })
  }

  sort_simplex(simplex)

  let alpha = 1.0
  let gamma = 2.0
  let rho = 0.5
  let sigma = 0.5

  for iter = 0; iter < max_iter; iter = iter + 1 {
    sort_simplex(simplex)

    // Check convergence: standard deviation of simplex scores
    let mut sum_score = 0.0
    for pt in simplex {
      sum_score = sum_score + pt.score
    }
    let mean_score = sum_score / num_points.to_double()
    let mut sum_sq_diff = 0.0
    for pt in simplex {
      let diff = pt.score - mean_score
      sum_sq_diff = sum_sq_diff + diff * diff
    }
    let std_dev = (sum_sq_diff / num_points.to_double()).sqrt()
    if std_dev < tol {
      break
    }

    // 2. Centroid of all points except the worst (simplex[dim])
    let centroid = Array::make(dim, 0.0)
    for i = 0; i < dim; i = i + 1 {
      let mut sum_coord = 0.0
      for j = 0; j < dim; j = j + 1 {
        sum_coord = sum_coord + simplex[j].params[i]
      }
      centroid[i] = sum_coord / dim.to_double()
    }

    // 3. Reflection
    let worst = simplex[dim]
    let reflected_params = Array::make(dim, 0.0)
    for i = 0; i < dim; i = i + 1 {
      reflected_params[i] = centroid[i] +
        alpha * (centroid[i] - worst.params[i])
    }
    let reflected_score = f(reflected_params)

    if reflected_score < simplex[dim - 1].score &&
      reflected_score >= simplex[0].score {
      simplex[dim] = { params: reflected_params, score: reflected_score }
      continue
    }

    // 4. Expansion
    if reflected_score < simplex[0].score {
      let expanded_params = Array::make(dim, 0.0)
      for i = 0; i < dim; i = i + 1 {
        expanded_params[i] = centroid[i] +
          gamma * (reflected_params[i] - centroid[i])
      }
      let expanded_score = f(expanded_params)
      if expanded_score < reflected_score {
        simplex[dim] = { params: expanded_params, score: expanded_score }
      } else {
        simplex[dim] = { params: reflected_params, score: reflected_score }
      }
      continue
    }

    // 5. Contraction
    if reflected_score >= simplex[dim - 1].score {
      let contracted_params = Array::make(dim, 0.0)
      let mut contracted_score = 0.0
      let mut is_contracted_better = false
      if reflected_score < worst.score {
        // Outside contraction
        for i = 0; i < dim; i = i + 1 {
          contracted_params[i] = centroid[i] +
            rho * (reflected_params[i] - centroid[i])
        }
        contracted_score = f(contracted_params)
        if contracted_score < reflected_score {
          simplex[dim] = { params: contracted_params, score: contracted_score }
          is_contracted_better = true
        }
      } else {
        // Inside contraction
        for i = 0; i < dim; i = i + 1 {
          contracted_params[i] = centroid[i] +
            rho * (worst.params[i] - centroid[i])
        }
        contracted_score = f(contracted_params)
        if contracted_score < worst.score {
          simplex[dim] = { params: contracted_params, score: contracted_score }
          is_contracted_better = true
        }
      }

      if is_contracted_better {
        continue
      }
    }

    // 6. Shrink
    let best_params = simplex[0].params
    for j = 1; j < num_points; j = j + 1 {
      for i = 0; i < dim; i = i + 1 {
        simplex[j].params[i] = best_params[i] +
          sigma * (simplex[j].params[i] - best_params[i])
      }
      simplex[j].score = f(simplex[j].params)
    }
  }

  sort_simplex(simplex)
  simplex[0].params
}
