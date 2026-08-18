# moonbit-adsorption

`moonbit-adsorption` 是一个纯 MoonBit 的吸附过程计算库，面向水处理、气体净化、材料表征和固定床工艺的可复现实验计算。项目以可组合的数值 API 为核心，不依赖 Python、C 或闭源运行时。

## 能力范围

- 等温线：Langmuir、Freundlich、Temkin、Sips、Toth、Redlich–Peterson、BET、Dubinin–Radushkevich、Halsey、Harkin–Jura。
- 参数辨识：原始非线性空间的 NLLS 拟合、Nelder–Mead 优化、R²、RMSE、MAE、AIC/BIC 和局部敏感性。
- 动力学：拟一级、拟二级、Elovich 和颗粒内扩散模型，带半吸附时间、初始速率和线性回归评估。
- 固定床：Thomas、Yoon–Nelson、Clark、BDST 工程公式，以及一维迎风 FDM + RK4 动态列模拟。
- 工程工具：突破曲线插值、5/10/50/90% 突破时间、处理体积、去除容量、MTZ、EBCT、Ergun 压降、Courant/Péclet/Da 数。
- 数据工具：统计摘要、误差指标、百分位数、移动平均、插值、矩阵和 2×2 线性求解、实验设计与敏感性分析。

## 快速开始

```bash
moon add weidekais/moonbit-adsorption
moon check
moon test
moon run --target native benchmarks
```

最小拟合示例：

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

固定床模拟结果可以进一步用 `@fixed_bed.summarize_breakthrough` 转换成工程指标：

```mbt nocheck
let metrics = @fixed_bed.summarize_breakthrough(result.breakthrough_curve, 10.0, 2.0)
println(metrics.c50_time)
println(metrics.removal_capacity)
```

## 可复现实验基准

基准入口位于 `benchmarks/main.mbt`，使用 5 个 Langmuir 数据点拟合参数，并运行 51 个空间网格、1,000 个时间步的固定床模拟。一次本地 Windows native 运行的输出为：

| 指标 | 实测值 |
| --- | ---: |
| 拟合 `q_m` | 10.000000000024196 |
| 拟合 `k_l` | 0.499999999996915 |
| `R²` | 1 |
| 模拟步数 | 1,000 |
| 50% 突破时间 | 9.99 |
| 去除容量指标 | 199.1335926829373 |
| 命令端到端耗时 | 1,781.84 ms |

端到端耗时会受机器、首次编译和 MoonBit 缓存影响；模型输出和步数是可复现的数值基准。

## 测试与质量门禁

仓库当前包含 8,287 行 `.mbt` 源码（含测试）和 306 个测试用例。CI 覆盖 `moon check --target all`、`moon test --target all`、native 测试、`moon fmt --check`、`moon info` 和接口漂移检查。建议本地提交前执行：

```bash
moon fmt
moon check --target all --deny-warn
moon test --target all --deny-warn
moon info
git diff --exit-code
```

## 包结构

```text
utils/       统计、回归、优化、矩阵、实验设计和数据校验
isotherm/    等温线、动力学、拟合和模型比较
fixed_bed/   固定床动态模拟、突破曲线和工程设计
benchmarks/  可直接运行的端到端基准
```

## 许可证与来源

本项目为独立的 MoonBit 原生实现，不复制第三方源代码；公式来自公开的化学工程与吸附过程文献中的经典模型。项目以 Apache-2.0 发布，详见根目录 [LICENSE](LICENSE)。

