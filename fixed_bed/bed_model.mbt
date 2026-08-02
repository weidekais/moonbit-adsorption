///|
/// Parameters for a fixed-bed adsorption column.
pub(all) struct FixedBedParams {
  /// Bed depth / length (Z, cm or m)
  bed_length : Double
  /// Linear flow velocity (v, cm/min or m/s)
  velocity : Double
  /// Bed porosity or void fraction (epsilon)
  porosity : Double
  /// Adsorbent bulk density (rho_b)
  bulk_density : Double
  /// Initial concentration of adsorbate (C_0)
  initial_concentration : Double
} derive(Debug, Eq)
