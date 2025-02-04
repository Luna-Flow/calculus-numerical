# CALCULUS-NUMERICAL
[![](https://img.shields.io/badge/Maintainer-KCN--judu-pink)](https://github.com/KCN-judu) [![](https://img.shields.io/badge/License-MIT-blue)](https://github.com/moonbit-community/calculus-numerical/blob/main/LICENSE) ![](https://img.shields.io/badge/State-active-success)

<br>

# Content（目录）

- __Introduction（简介）__[en_US](#introduction)|[zh_CN](#简介)
- __Project Progress（项目进度）__[en_US](#project-progress)|[zh_CN](#项目进度)
- __How to Contribute（如何参与贡献）__[en_US](#how-to-contribute)|[zh_CN](#如何参与贡献)

<br>

# Introduction

This is a calculus numerical solution library written using [__MoonBit__](https://www.moonbitlang.com), aiming to fill the gap in scientific computing applications in the MoonBit ecosystem.

This project provides basic numerical solutions for calculus, and multiple optional numerical solution methods for the integral part. On this basis, we will also provide support for complex number related calculations such as Fourier transform.

__*Starting from the first official beta release, the completeness of the English and Chinese documents will be guaranteed. Japanese documents may be added in subsequent version updates.*__

<br>

# Feat List

**[LATEST]** 25.01.20: Defined the `Complex` struct and implemented some basic functions.

- **25.01.20**: Implemented operation and property functions for `MatrixDbl`.
- **25.01.19**: Implemented basic functions for `MatrixViewDbl`.
- **25.01.18**: Defined the `MatrixViewDbl` struct.
- **25.01.17**: Implemented functions for `VectorDbl`.
- **25.01.17**: Defined the `VectorDbl` struct.
- **25.01.17**: Implemented basic functions for `MatrixDbl`.
- **25.01.16**: Defined the `MatrixDbl` struct.
- **25.01.16**: Introduced the developer tool `ready_to_pr.sh`.
- **25.01.13**: Implemented adaptive quadrature using Gauss quadrature and the Kronrod extension.
- **25.01.12**: Added basic functions such as `min[T:Compare](T, T) -> T` and `max[T:Compare](T, T) -> T`.
- **25.01.11**: Introduced type aliases for complex function signatures, such as `Func_Math` and `Quad_GK`.
- **25.01.02**: Implemented quadrature using Gauss quadrature and the Kronrod extension.
- **24.12.30**: Implemented derivative and differential functions using forward, backward, and central difference methods.
- **24.12.29**: Enhanced the `Integer` type to accept all kinds of integers and implemented the fast power function `pow_integer_exp()`.

<br>

# How to Contribute

We are excited to welcome contributions from the community, external developers, and individual enthusiasts! Whether you’re looking to fix a bug, add a new feature, or improve the documentation, your involvement is highly appreciated. To help you get started, here are a few simple steps:

First, please take a look at the `TODO.md` file or the current list of issues to pick a task that interests you. We recommend selecting something you’re passionate about or familiar with, as it’ll make the process more enjoyable and easier to dive into.

Next, fork the project and create a new branch in your personal repository. This allows you to work on your changes without affecting the main project.

While coding, please follow the guidelines and coding conventions outlined in the `CONTRIBUTING.md` file. If your changes involve adding new features or fixing bugs, be sure to thoroughly test your code to ensure everything runs smoothly.

Once you’re done, submit a pull request (PR) with a clear description of your changes. This helps us understand what you’ve worked on and speeds up the review process.

Your PR will be reviewed, and we might suggest improvements or fixes. Don’t worry—this is just to make sure the code quality is top-notch. Once your PR is approved, we’ll merge your contributions into the main branch.

Thank you once again for your time and effort! Every contribution makes a big difference in improving this project. We look forward to seeing your amazing work!

<br>

# 简介

这是一个使用[__MoonBit__](https://www.moonbitlang.cn)编写的微积分数值求解库，旨在填补MoonBit生态在科学计算领域的空白。

本项目将会提供基本的微积分数值求解方法，在积分部分会提供多种可选的数值求解方法。在此基础上，我们还会对如傅里叶变换等复数相关的计算提供支持。

__*从第一个测试版本正式发布开始，会保证英文和中文文档的完整性。在后续的版本更新中可能会加入日语文档。*__

<br>

# 项目进度

**[最新]** 25.01.20: 定义结构体 `Complex` 及其基础功能实现

- **25.01.20**: 实现 `MatrixDbl` 的运算与性质函数
- **25.01.19**: 实现 `MatrixViewDbl` 的基础功能
- **25.01.18**: 定义结构体 `MatrixViewDbl`
- **25.01.17**: 实现 `VectorDbl` 的相关函数
- **25.01.17**: 定义结构体 `VectorDbl`
- **25.01.17**: 实现 `MatrixDbl` 的基础功能
- **25.01.16**: 定义结构体 `MatrixDbl`
- **25.01.16**: 开发者工具 `ready_to_pr.sh`
- **25.01.13**: 自适应求积法实现（使用高斯求积法及 Kronrod 扩展）
- **25.01.12**: 基础函数实现：如 `min[T:Compare](T, T) -> T` 和 `max[T:Compare](T, T) -> T`
- **25.01.11**: 为复杂函数签名定义类型别名，如 `Func_Math` 和 `Quad_GK`
- **25.01.02**: 求积法实现（使用高斯求积法及 Kronrod 扩展）
- **24.12.30**: 导数与微分功能实现（使用前向、后向及中心差分法）
- **24.12.29**: `Integer` 类型支持各种整数类型，提供快速幂函数 `pow_integer_exp()`

<br>

# 如何参与贡献

我们非常欢迎社区、外部开发者以及个人爱好者的贡献！无论你是想解决某个bug、增加新功能，还是改进文档，都非常欢迎你的参与。为了帮助你顺利贡献，以下是一些简单的步骤：

首先，请从`TODO.md`文件或者当前的`issue`列表中挑选一个你感兴趣的任务。我们建议选择自己有兴趣或熟悉的内容，这样你会更容易上手，也能享受其中的过程。

接着，Fork我们的项目，并在你的个人仓库中创建一个新的分支。这样，你就可以在自己的分支上开始进行开发工作，而不会影响到主项目的进展。

在编码过程中，请尽量遵循`CONTRIBUTING.md`中提供的代码风格和规范。如果你的修改涉及到新功能或修复bug，请确保进行充分的测试，确保一切正常运行。

完成后，请提交你的PR，并在提交时提供一个清晰的描述，帮助我们了解你所做的更改。这样有助于更快地进行代码审查和合并。

我们会对你的PR进行审查，并可能会提出一些改进意见。没关系，这只是为了确保代码质量。待审查通过后，我们会将你的贡献合并到主分支中。

再次感谢你的参与和贡献！每一份努力都能让这个项目变得更好。我们期待看到你的精彩代码！