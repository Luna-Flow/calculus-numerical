# TODO List



## Content 目录

- [Documentation Writing](#Documentation-Writing)

- [Feature Implementation](#Feature-implementation)

<br>

## Documentation Writing

Since the project primarily focuses on numerical solutions related to calculus, documentation in this project is not only the foundation for sustainable development but also a key medium for helping developers understand and apply numerical solving methods, while also enabling them to deeply master the implementation and application of algorithms.

Improving and updating the documentation is an ongoing effort, requiring continuous contributions from the community. Whether it is detailed algorithm explanations or tutorials and usage instructions for beginners, every small improvement will greatly enhance the accessibility and maintainability of the project.

Therefore, we sincerely invite all developers to participate, especially those who are already familiar with various numerical computation libraries. Their experience will provide valuable insights for improving the quality of the documentation. We also encourage beginners to contribute to writing and refining the documentation, as it will not only help them better understand the project but also deepen their understanding of calculus and numerical computation through their contributions.

Through joint effort, we believe that the project documentation will become a driving force for the growth of every contributor in the community, helping the project progress further in the future.

<br>

## Feature Implementation

This project primarily focuses on implementing numerical solutions for calculus. In the next few versions, the focus will shift primarily to integration. Therefore, only integration-related functions are listed below.

Below is a table of function name components and their meanings:

| **Component** |                         **Meaning**                          |
| :-----------: | :----------------------------------------------------------: |
|     `dbl`     | Double (e.g., doubly adaptive, indicating multiple levels of adaptation). |
|    `adap`     | Adaptive (dynamic adjustment of strategy, e.g., error control or interval subdivision). |
|     `gen`     |   General-purpose (suitable for a wide range of problems).   |
|     `osc`     | Oscillatory (handling functions with oscillatory behavior).  |
|    `sing`     |   Singularities (handling functions with singular points).   |
|     `wgt`     | Weighted (handling functions with specific weight functions). |
|    `quad`     |             Quadrature (numerical integration).              |
|     `cpv`     | Cauchy Principal Value (handling singularities or infinite intervals). |
|   `fourier`   | Fourier (specific oscillatory properties, often related to Fourier transforms). |
|     `gk`      |   Gauss-Kronrod (a specific numerical integration method).   |
|   `simpson`   | Simpson’s rule (a numerical integration method with higher accuracy). |
|    `trap`     |   Trapezoidal rule (a basic numerical integration method).   |

<br>

Below is a table of functions that need to be implemented. The table includes the package each function belongs to, its name, purpose, and implementation difficulty, providing developers with a convenient reference to choose contribution goals based on their individual needs and abilities.

|    Package     |      **Function**       |                         **Purpose**                          | **Difficulty** |
| :------------: | :---------------------: | :----------------------------------------------------------: | :------------: |
| `@integration` |       `quad_trap`       |             Trapezoidal method for integration.              |      Easy      |
| `@integration` |     `quad_simpson`      |              Simpson's method for integration.               |     Medium     |
| `@integration` | `adap_osc_wgt_quad_gk`  | Adaptive integration method for infinite intervals (e.g., integration over `[a, ∞)`). |      Hard      |
| `@integration` |   `adap_sing_quad_gk`   | Adaptive integration method for functions with singularities over a given interval. |      Hard      |
| `@integration` |   `dbl_adap_gen_quad`   | Doubly-adaptive general-purpose quadrature for handling most types of singularities |      Hard      |
| `@integration` |   `adap_wgt_quad_cpv`   | Adaptive method for infinite interval integration, suitable for oscillatory functions. |      Hard      |
| `@integration` | `adap_wgt_quad_fourier` | Adaptive integration for infinite intervals, for functions with specific oscillatory properties. |      Hard      |

<br>
