# MiniTensor-RV

一个面向数字 IC 与 AI 芯片学习的渐进式项目：从可验证的 RTL 累加器开始，逐步实现 INT8 MAC、脉动阵列、RISC-V 控制和量化神经网络推理。

## 当前里程碑

**V0：同步复位累加器**

```text
输入 x --┐
         ├── 加法器 ──> acc 寄存器
acc  ----┘             ↑
                       clk
```

当前模块行为：

- `rst=1`：在时钟上升沿将 `acc` 清零；
- `en=1`：在时钟上升沿执行 `acc <= acc + x`；
- `en=0`：保持 `acc` 不变；
- 输出 `acc` 为 32 位无符号值。

## 运行

```bash
cd ~/projects/MiniTensor-RV
make test
make lint
```

波形文件位于 `results/waveforms/accumulator.vcd`，如果 WSLg 或 X11 可用，可以执行：

```bash
make wave
```

## 工具链

- Verilator：主 lint/仿真工具；
- Icarus Verilog：V0 教学 testbench 和兼容性备用；
- cocotb + pytest：后续自动化 Python 验证；
- NumPy：软件参考模型；
- Yosys：综合和面积分析；
- GTKWave：波形查看。

## 路线

```text
V0 累加器
→ V1 INT8 MAC
→ V2 2×2 PE 脉动阵列
→ V3 可配置 4×4 GEMM 加速器
→ V4 RISC-V MMIO 控制
→ V5 MNIST INT8 推理
→ V6 综合、STA 和可选 ASIC 后端
```
