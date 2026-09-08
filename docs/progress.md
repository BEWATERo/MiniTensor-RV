# Progress

## 2026-09-07

- 建立 MiniTensor-RV 项目目录；
- 配置 Ubuntu 22.04 WSL2 工具链；
- 完成 V0 同步复位累加器；
- 添加 Icarus testbench、VCD 波形和 Verilator lint；
- 下一步：实现 V1 INT8 MAC。

## 2026-09-07 - V1 started

- 定义 INT8 MAC 接口和优先级；
- 添加 INT8×INT8、INT32 累加 RTL；
- 添加独立 NumPy/Python 风格 golden model；
- 添加 cocotb 定向测试和 500 周期随机对拍；
- 添加 V1 规格文档。

## 2026-09-08 - V1 verified

- 补充 INT8 极值乘法测试；
- 验证 `rst > clear > valid > hold` 优先级；
- 500 周期确定性随机对拍通过；
- Verilator lint 通过；
- Yosys 综合通过，识别出乘法器、加法器、累加寄存器和控制多路选择器；
- 明确正常负载不得使 INT32 累加器溢出，饱和将在输出再量化阶段处理。
