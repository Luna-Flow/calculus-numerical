# Changelog

All notable changes to this project are documented in this file. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- **Breaking:** the existing packages moved under `legacy/`. Only the import
  path changed; every function, type and constant keeps its name, signature
  and behaviour. Update your `moon.pkg` imports as follows.

  | Old import path | New import path |
  | --- | --- |
  | `Luna-Flow/calculus-numerical/basic` | `Luna-Flow/calculus-numerical/legacy/basic` |
  | `Luna-Flow/calculus-numerical/deriv` | `Luna-Flow/calculus-numerical/legacy/deriv` |
  | `Luna-Flow/calculus-numerical/diff` | `Luna-Flow/calculus-numerical/legacy/diff` |
  | `Luna-Flow/calculus-numerical/integration` | `Luna-Flow/calculus-numerical/legacy/integration` |
  | `Luna-Flow/calculus-numerical/internal` | `Luna-Flow/calculus-numerical/legacy/internal` |

  The path `Luna-Flow/calculus-numerical/integration` is reserved for the
  next-generation integration package and no longer exposes the old API.
- The module is described by `moon.mod` instead of the deprecated
  `moon.mod.json`, and the sources and packages build with the latest MoonBit
  toolchain (`moon check --target all --deny-warn` is clean). Dependencies were
  reduced to the ones that the code imports (`Kaida-Amethyst/math`).
- `legacy/basic`: `Func_Math` and `Quad_GK` are declared with `pub type` aliases
  instead of the removed `pub typealias` syntax. Both remain transparent aliases
  of the same function types.
- `legacy/integration`: `ErrCode` keeps its `Eq` and `Show` methods through
  explicit `pub extend` declarations.
- `legacy/deriv` and `legacy/diff` read the shared helper `arr_sum` from the new
  internal package `legacy/support` (not part of the public API).

### Added

- A CI workflow (`.github/workflows/ci.yml`) that installs the latest MoonBit
  toolchain and runs `moon check --target <backend> --deny-warn` and
  `moon test --target <backend>` on `wasm`, `wasm-gc`, `js` and `native`, plus
  `moon fmt --check` and a check that the committed `.mbti` files are current.
- `legacy/compatibility` tests that pin the behaviour of the moved packages
  (all Kronrod rules, the adaptive and non-adaptive integrators, and the
  derivative estimators against closed-form results).

### Fixed

- `moon check` and `moon test` no longer fail on the current toolchain
  ([#125](https://github.com/Luna-Flow/calculus-numerical/issues/125)).
