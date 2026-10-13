set shell := ["sh", "-eu", "-c"]

# Check and test every backend, as CI does.
check:
    moon check --target all --deny-warn
    moon test --target wasm
    moon test --target wasm-gc
    moon test --target js
    moon test --target native
