# Witch-KLEE

Witch-KLEE is a [Klee-based](https://klee.github.io/) module of the violation witness verifier Witch. It is intended to use as a backend in the program analysis tool [Symbiotic](https://github.com/ayazip/symbiotic/tree/witch-klee).

To run Witch, build Symbiotic with the option `witch-klee`, or build the components separately and make sure the path to the built Witch-KLEE executable is in $PATH. Then, run Symbiotic as:

`path/to/symbiotic --witness-check witness program`.

Violated property and architecture must be provided as arguments, using `--prp property_name` for property and `--64` or `--32` for architecture. For additional options, run `path/to/symbiotic --help`.
