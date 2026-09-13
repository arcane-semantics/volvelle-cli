# TODO

## Rewrite the CLI in Rust

- [ ] Capture each public subcommand's behavior in black-box contract tests.
- [ ] Introduce a Rust `volvelle` executable alongside the Python reference.
- [ ] Port subcommands in behaviorally complete slices, including errors and
  filesystem side effects.
- [ ] Remove the Python implementation and packaging only after the Rust CLI
  passes the complete contract suite.
