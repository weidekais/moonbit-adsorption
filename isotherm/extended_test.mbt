///|
test "model boundary 0" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 1.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 1.0]).length(), content="2")
}

///|
test "model boundary 1" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 2.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 2.0]).length(), content="2")
}

///|
test "model boundary 2" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 3.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 3.0]).length(), content="2")
}

///|
test "model boundary 3" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 4.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 4.0]).length(), content="2")
}

///|
test "model boundary 4" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 5.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 5.0]).length(), content="2")
}

///|
test "model boundary 5" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 6.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 6.0]).length(), content="2")
}

///|
test "model boundary 6" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 7.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 7.0]).length(), content="2")
}

///|
test "model boundary 7" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 8.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 8.0]).length(), content="2")
}

///|
test "model boundary 8" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 9.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 9.0]).length(), content="2")
}

///|
test "model boundary 9" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 1.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 1.0]).length(), content="2")
}

///|
test "model boundary 10" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 2.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 2.0]).length(), content="2")
}

///|
test "model boundary 11" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 3.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 3.0]).length(), content="2")
}

///|
test "model boundary 12" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 4.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 4.0]).length(), content="2")
}

///|
test "model boundary 13" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 5.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 5.0]).length(), content="2")
}

///|
test "model boundary 14" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 6.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 6.0]).length(), content="2")
}

///|
test "model boundary 15" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 7.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 7.0]).length(), content="2")
}

///|
test "model boundary 16" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 8.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 8.0]).length(), content="2")
}

///|
test "model boundary 17" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 9.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 9.0]).length(), content="2")
}

///|
test "model boundary 18" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 1.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 1.0]).length(), content="2")
}

///|
test "model boundary 19" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 2.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 2.0]).length(), content="2")
}

///|
test "model boundary 20" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 3.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 3.0]).length(), content="2")
}

///|
test "model boundary 21" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 4.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 4.0]).length(), content="2")
}

///|
test "model boundary 22" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 5.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 5.0]).length(), content="2")
}

///|
test "model boundary 23" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 6.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 6.0]).length(), content="2")
}

///|
test "model boundary 24" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 7.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 7.0]).length(), content="2")
}

///|
test "model boundary 25" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 8.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 8.0]).length(), content="2")
}

///|
test "model boundary 26" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 9.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 9.0]).length(), content="2")
}

///|
test "model boundary 27" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 1.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 1.0]).length(), content="2")
}

///|
test "model boundary 28" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 2.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 2.0]).length(), content="2")
}

///|
test "model boundary 29" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 3.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 3.0]).length(), content="2")
}

///|
test "model boundary 30" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 4.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 4.0]).length(), content="2")
}

///|
test "model boundary 31" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 5.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 5.0]).length(), content="2")
}

///|
test "model boundary 32" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 6.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 6.0]).length(), content="2")
}

///|
test "model boundary 33" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 7.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 7.0]).length(), content="2")
}

///|
test "model boundary 34" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 8.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 8.0]).length(), content="2")
}

///|
test "model boundary 35" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 9.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 9.0]).length(), content="2")
}

///|
test "model boundary 36" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 1.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 1.0]).length(), content="2")
}

///|
test "model boundary 37" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 2.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 2.0]).length(), content="2")
}

///|
test "model boundary 38" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 3.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 3.0]).length(), content="2")
}

///|
test "model boundary 39" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 4.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 4.0]).length(), content="2")
}

///|
test "model boundary 40" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 5.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 5.0]).length(), content="2")
}

///|
test "model boundary 41" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 6.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 6.0]).length(), content="2")
}

///|
test "model boundary 42" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 7.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 7.0]).length(), content="2")
}

///|
test "model boundary 43" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 8.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 8.0]).length(), content="2")
}

///|
test "model boundary 44" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 9.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 9.0]).length(), content="2")
}

///|
test "model boundary 45" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 1.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 1.0]).length(), content="2")
}

///|
test "model boundary 46" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 2.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 2.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 2.0]).length(), content="2")
}

///|
test "model boundary 47" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 3.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 3.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 3.0]).length(), content="2")
}

///|
test "model boundary 48" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 4.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 4.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 4.0]).length(), content="2")
}

///|
test "model boundary 49" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 5.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 5.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 5.0]).length(), content="2")
}

///|
test "model boundary 50" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 6.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 6.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 6.0]).length(), content="2")
}

///|
test "model boundary 51" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 7.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 7.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 7.0]).length(), content="2")
}

///|
test "model boundary 52" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 8.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 8.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 8.0]).length(), content="2")
}

///|
test "model boundary 53" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 9.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 9.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 9.0]).length(), content="2")
}

///|
test "model boundary 54" {
  let lang = @isotherm.LangmuirParams::{ q_m: 10.0, k_l: 0.5, r_squared: 1.0 }
  let fre = @isotherm.FreundlichParams::{ k_f: 2.0, n: 2.0, r_squared: 1.0 }
  let _tem = @isotherm.TemkinParams::{ a_t: 2.0, b: 3.0, r_squared: 1.0 }
  let sips = @isotherm.SipsParams::{
    q_m: 10.0,
    k_s: 0.5,
    n_s: 1.0,
    r_squared: 1.0,
  }
  let toth = @isotherm.TothParams::{
    q_m: 10.0,
    k_t: 0.5,
    n_t: 1.0,
    r_squared: 1.0,
  }
  inspect(@isotherm.predict_langmuir(lang, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_freundlich(fre, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_sips(sips, 1.0) >= 0.0, content="true")
  inspect(@isotherm.predict_toth(toth, 1.0) >= 0.0, content="true")
  inspect(@isotherm.langmuir_curve(lang, [0.0, 1.0]).length(), content="2")
}

///|
test "kinetic boundary 0" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 1" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 2" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 3" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 4" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 5" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 6" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 7" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 8" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 9" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 10" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 11" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 12" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 13" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 14" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 15" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 16" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 17" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 18" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 19" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 20" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 21" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 22" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 23" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 24" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 25" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 26" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 27" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 28" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}

///|
test "kinetic boundary 29" {
  let data = [
    @isotherm.KineticData::{ time: 0.0, q: 0.0 },
    @isotherm.KineticData::{ time: 1.0, q: 1.0 },
    @isotherm.KineticData::{ time: 2.0, q: 1.5 },
  ]
  let pfo = @isotherm.fit_pseudo_first_order(data)
  let pso = @isotherm.fit_pseudo_second_order(data)
  inspect(@isotherm.predict_pseudo_first_order(pfo, 0.0), content="0")
  inspect(@isotherm.predict_pseudo_second_order(pso, 0.0), content="0")
  inspect(@isotherm.half_time_pseudo_first_order(pfo) >= 0.0, content="true")
}
