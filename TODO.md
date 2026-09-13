# TODO

## Rewrite the CLI in Rust

- [ ] Capture each public subcommand's behavior in black-box contract tests.
- [ ] Replace `emojis.txt` with versioned structured data that keeps glyphs,
  upstream identifiers, display labels, search aliases, categories, and source
  metadata separate. Keep raw `nf-*` identifiers visible, but add curated terms
  so symbols can be found by meaning.
- [ ] Introduce a Rust `volvelle` executable alongside the Python reference.
- [ ] Port subcommands in behaviorally complete slices, including errors and
  filesystem side effects.
- [ ] Remove the Python implementation and packaging only after the Rust CLI
  passes the complete contract suite.
