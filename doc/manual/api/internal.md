# internal API

The `internal` package holds the machine constants that the other packages use to choose step sizes and to bound roundoff error. It contains no functions. The constants are those of `gsl_machine.h` in the GNU Scientific Library.

## Machine constants

Every constant is a `Double` named `machine_<prefix><quantity>`. The quantity names a limit of a floating-point format:

| Quantity | Meaning |
| --- | --- |
| `dbl_epsilon` | The machine epsilon of double precision, $2^{-52} \approx 2.22 \cdot 10^{-16}$. |
| `dbl_min` | The smallest positive normal double, $\approx 2.23 \cdot 10^{-308}$. |
| `dbl_max` | The largest finite double, $\approx 1.80 \cdot 10^{308}$. |
| `flt_epsilon` | The machine epsilon of single precision, $2^{-23}$. |
| `flt_min` | The smallest positive normal single-precision value. |
| `flt_max` | The largest finite single-precision value. |
| `sflt_epsilon` | The machine epsilon of the short float format of GSL, $2^{-11}$. |
| `eps` | The rounded machine tolerances of `GSL_MACH_EPS`, which exist only with a prefix. |

The prefix names a function of that quantity:

| Prefix | Value | Available for |
| --- | --- | --- |
| none | the quantity itself | `dbl_*`, `flt_*`, `sflt_epsilon` |
| `sqrt_` | its square root | all quantities |
| `root_3_` to `root_6_` | its third to sixth root | all quantities |
| `log_` | its natural logarithm | all quantities |

For example, `machine_sqrt_dbl_epsilon` is $\sqrt{\varepsilon} \approx 1.49 \cdot 10^{-8}$ and `machine_log_dbl_max` is $\ln(\text{dbl\_max}) \approx 709.78$. The rounded `eps` values are `machine_sqrt_eps` ($3.2 \cdot 10^{-8}$), `machine_root_3_eps` ($10^{-5}$), `machine_root_4_eps` ($1.78 \cdot 10^{-4}$), `machine_root_5_eps` ($10^{-3}$), `machine_root_6_eps` ($3.16 \cdot 10^{-3}$) and `machine_log_eps` ($-34.54$).
