# integration 设计

This subsystem owns adaptive and non-adaptive quadrature paths, shared error codes, and workspace management.

## 职责

- 让代码和文档围绕 `src/integration` 保持一致。
- 如实保留执行模型，不掩盖重要的内部差异。
- 记录维护者必须稳定保留的扩展点、不变量和限制。

## 维护说明

- 只要模块边界、核心算法或可观察语义变化，就更新本页。
- 如果模块仍然不完整，也要明确写出，不要伪造未来 API。
