# Toolchain audit

## Host

- Ubuntu 22.04.5 LTS on WSL2
- x86_64
- Python 3.10

## Installed tools

| Tool | Role | Version checked |
|---|---|---|
| Verilator | 主力 SystemVerilog lint/仿真 | 4.038 |
| Icarus Verilog | 教学 testbench/兼容性备用 | 11.0 |
| Yosys | RTL 综合 | 0.9 |
| GTKWave | VCD 波形查看 | 3.3.104 |
| CMake | 后续构建辅助 | 3.22.1 |
| Ninja | 后续构建辅助 | 1.10.1 |
| Git | 版本管理 | 2.34.1 |
| GitHub CLI | 远程仓库管理 | 2.4.0 |

## Python environment

项目虚拟环境位于：

```text
~/projects/MiniTensor-RV/.venv
```

已安装：

- cocotb 2.1.0；
- pytest 9.1.1；
- NumPy 2.2.6。

## 选择说明

- Verilator 是主仿真和 lint 工具；
- Icarus 保留用于教学例子和兼容性验证；
- Yosys 只承担早期综合和面积统计；
- OpenLane/OpenROAD 暂不安装，等 V3/V4 稳定后再进入 ASIC 后端；
- Vivado、Quartus、Docker、Gemmini 和 Chipyard 当前不属于项目必需依赖。
