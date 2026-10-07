# calculus-numerical

[![img](https://img.shields.io/badge/Maintainer-KCN--judu-pink)](https://github.com/KCN-judu) [![img](https://img.shields.io/badge/License-Apache%202.0-blue)](https://github.com/Luna-Flow/calculus-numerical/blob/main/LICENSE) ![img](https://img.shields.io/badge/State-active-success)

## Introduction

This is a numerical calculus library written in [**MoonBit**](https://www.moonbitlang.cn/), designed to fill the gap in the MoonBit ecosystem for scientific computing.

The library works on functions of type `(Double) -> Double` and is divided into five packages:

| Package | Contents |
| --- | --- |
| [`basic`](api/basic.md) | The function types `Func_Math` and `Quad_GK` and mathematical constants. |
| [`deriv`](api/deriv.md) | Derivatives by forward, backward and central differences from a given initial step size. |
| [`diff`](api/diff.md) | Derivatives by forward, backward and central differences with a step size chosen automatically. |
| [`integration`](api/integration.md) | Gauss–Kronrod rules and adaptive and non-adaptive integrators. |
| [`internal`](api/internal.md) | Machine constants used by the other packages. |

## Guides

- [Architecture RFC](architecture_rfc.md): the next-generation architecture under research, an independent, trait-compatible numerical foundation with explicit floating-point contexts and first-class Decimal support.

## Feature list

**[Latest]** 25.01.31: Non-adaptive integration implementation (using Gaussian quadrature and Kronrod extension)

- **25.01.13**: Adaptive integration implementation (using Gaussian quadrature and Kronrod extension)
- **25.01.02**: Quadrature methods implementation (using Gaussian quadrature and Kronrod extension)
- **24.12.30**: Derivatives and differential functionality implementation (using forward, backward, and central difference methods)

## How to contribute

We welcome contributions from the community, external developers, and individual enthusiasts! Whether you want to fix a bug, add a new feature, or improve the documentation, your participation is highly encouraged. To help you contribute smoothly, here are some simple steps:

1. Please choose a task from the [`TODO.md`](../../TODO.md) file or the current `issue` list that interests you. We recommend selecting something you are interested in or familiar with, as it will make it easier to get started and enjoy the process.
2. Fork our project and create a new branch in your personal repository. This way, you can start working on your changes without affecting the main project.
3. During development, please adhere to the coding style and guidelines in the [contribution guidelines](contributing.md). If your changes involve new features or bug fixes, please make sure to perform thorough testing to ensure everything works as expected.
4. Once you're done, submit your PR and provide a clear description of your changes to help us understand the modifications you've made. This will help us review and merge your code more quickly.
5. We will review your PR and may suggest improvements to ensure code quality. After approval, your contributions will be merged into the main branch.

Thank you again for your participation and contributions! Every effort helps make this project better. We look forward to seeing your great code!
