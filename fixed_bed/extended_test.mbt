///|
test "design boundary 0" {
  inspect(@fixed_bed.bed_volume(1.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(1.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(1.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(1.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 1" {
  inspect(@fixed_bed.bed_volume(2.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(2.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(2.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(2.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 2" {
  inspect(@fixed_bed.bed_volume(3.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(3.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(3.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(3.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 3" {
  inspect(@fixed_bed.bed_volume(4.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(4.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(4.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(4.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 4" {
  inspect(@fixed_bed.bed_volume(5.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(5.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(5.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(5.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 5" {
  inspect(@fixed_bed.bed_volume(6.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(6.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(6.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(6.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 6" {
  inspect(@fixed_bed.bed_volume(7.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(7.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(7.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(7.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 7" {
  inspect(@fixed_bed.bed_volume(8.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(8.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(8.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(8.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 8" {
  inspect(@fixed_bed.bed_volume(1.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(1.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(1.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(1.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 9" {
  inspect(@fixed_bed.bed_volume(2.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(2.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(2.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(2.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 10" {
  inspect(@fixed_bed.bed_volume(3.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(3.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(3.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(3.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 11" {
  inspect(@fixed_bed.bed_volume(4.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(4.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(4.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(4.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 12" {
  inspect(@fixed_bed.bed_volume(5.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(5.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(5.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(5.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 13" {
  inspect(@fixed_bed.bed_volume(6.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(6.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(6.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(6.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 14" {
  inspect(@fixed_bed.bed_volume(7.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(7.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(7.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(7.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 15" {
  inspect(@fixed_bed.bed_volume(8.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(8.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(8.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(8.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 16" {
  inspect(@fixed_bed.bed_volume(1.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(1.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(1.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(1.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 17" {
  inspect(@fixed_bed.bed_volume(2.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(2.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(2.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(2.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 18" {
  inspect(@fixed_bed.bed_volume(3.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(3.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(3.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(3.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 19" {
  inspect(@fixed_bed.bed_volume(4.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(4.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(4.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(4.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 20" {
  inspect(@fixed_bed.bed_volume(5.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(5.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(5.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(5.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 21" {
  inspect(@fixed_bed.bed_volume(6.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(6.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(6.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(6.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 22" {
  inspect(@fixed_bed.bed_volume(7.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(7.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(7.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(7.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 23" {
  inspect(@fixed_bed.bed_volume(8.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(8.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(8.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(8.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 24" {
  inspect(@fixed_bed.bed_volume(1.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(1.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(1.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(1.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 25" {
  inspect(@fixed_bed.bed_volume(2.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(2.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(2.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(2.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 26" {
  inspect(@fixed_bed.bed_volume(3.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(3.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(3.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(3.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 27" {
  inspect(@fixed_bed.bed_volume(4.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(4.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(4.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(4.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 28" {
  inspect(@fixed_bed.bed_volume(5.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(5.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(5.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(5.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 29" {
  inspect(@fixed_bed.bed_volume(6.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(6.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(6.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(6.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 30" {
  inspect(@fixed_bed.bed_volume(7.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(7.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(7.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(7.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 31" {
  inspect(@fixed_bed.bed_volume(8.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(8.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(8.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(8.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 32" {
  inspect(@fixed_bed.bed_volume(1.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(1.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(1.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(1.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 33" {
  inspect(@fixed_bed.bed_volume(2.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(2.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(2.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(2.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 34" {
  inspect(@fixed_bed.bed_volume(3.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(3.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(3.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(3.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 35" {
  inspect(@fixed_bed.bed_volume(4.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(4.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(4.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(4.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 36" {
  inspect(@fixed_bed.bed_volume(5.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(5.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(5.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(5.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 37" {
  inspect(@fixed_bed.bed_volume(6.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(6.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(6.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(6.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 38" {
  inspect(@fixed_bed.bed_volume(7.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(7.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(7.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(7.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 39" {
  inspect(@fixed_bed.bed_volume(8.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(8.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(8.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(8.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 40" {
  inspect(@fixed_bed.bed_volume(1.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(1.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(1.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(1.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 41" {
  inspect(@fixed_bed.bed_volume(2.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(2.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(2.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(2.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 42" {
  inspect(@fixed_bed.bed_volume(3.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(3.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(3.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(3.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 43" {
  inspect(@fixed_bed.bed_volume(4.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(4.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(4.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(4.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 44" {
  inspect(@fixed_bed.bed_volume(5.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(5.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(5.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(5.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 45" {
  inspect(@fixed_bed.bed_volume(6.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(6.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(6.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(6.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 46" {
  inspect(@fixed_bed.bed_volume(7.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(7.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(7.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(7.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 47" {
  inspect(@fixed_bed.bed_volume(8.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(8.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(8.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(8.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 48" {
  inspect(@fixed_bed.bed_volume(1.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(1.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(1.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(1.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 49" {
  inspect(@fixed_bed.bed_volume(2.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(2.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(2.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(2.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 50" {
  inspect(@fixed_bed.bed_volume(3.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(3.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(3.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(3.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 51" {
  inspect(@fixed_bed.bed_volume(4.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(4.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(4.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(4.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 52" {
  inspect(@fixed_bed.bed_volume(5.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(5.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(5.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(5.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 53" {
  inspect(@fixed_bed.bed_volume(6.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(6.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(6.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(6.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "design boundary 54" {
  inspect(@fixed_bed.bed_volume(7.0, 1.0) > 0.0, content="true")
  inspect(@fixed_bed.hydraulic_residence_time(7.0, 2.0) > 0.0, content="true")
  inspect(
    @fixed_bed.empty_bed_contact_time(7.0, 0.4, 2.0) > 0.0,
    content="true",
  )
  inspect(@fixed_bed.courant_number(1.0, 0.1, 0.5) > 0.0, content="true")
  inspect(
    @fixed_bed.pressure_drop_ergun(7.0, 1.0, 0.001, 0.01, 0.4) > 0.0,
    content="true",
  )
}

///|
test "curve metric 0" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 1" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 2" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 3" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 4" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 5" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 6" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 7" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 8" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 9" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 10" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 11" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 12" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 13" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 14" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 15" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 16" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 17" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 18" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 19" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 20" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 21" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 22" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 23" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 24" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 25" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 26" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 27" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 28" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}

///|
test "curve metric 29" {
  let curve = [
    @fixed_bed.BreakthroughPoint::{
      time: 0.0,
      outlet_concentration: 0.0,
      outlet_ratio: 0.0,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 1.0,
      outlet_concentration: 2.0,
      outlet_ratio: 0.2,
    },
    @fixed_bed.BreakthroughPoint::{
      time: 2.0,
      outlet_concentration: 8.0,
      outlet_ratio: 0.8,
    },
  ]
  inspect(@fixed_bed.monotonic_breakthrough(curve), content="true")
  inspect(@fixed_bed.interpolate_time(curve, 0.5) > 1.0, content="true")
  inspect(@fixed_bed.breakthrough_area(curve) > 0.0, content="true")
  inspect(@fixed_bed.breakthrough_width(curve, 0.1, 0.9) > 0.0, content="true")
}
