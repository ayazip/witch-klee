# Witch-KLEE

Witch-KLEE is an error witness checker based on the symbolic executor KLEE (https://klee.github.io/).

To build the KLEE-based submodule, follow the instructions available here: https://klee.github.io/build-llvm9/ (also works wiith LLVM 10).

To run Witch-KLEE, execute the bash script `witch.sh`: 
  
    To run witness validation: path/to/witch.sh program witness
    To see the help message:   path/to/witch.sh help



Witch-KLEE is also integrated into the program analysis tool Symbiotic (https://github.com/staticafi/symbiotic/tree/witch-klee). 
To run Witch-KLEE with Symbiotic, make sure the path to the Witch-KLEE executable is in $PATH. Run Symbiotic as:

`path/to/symbiotic --witness-check witness program`. 

Violated property and architecture must be provided as arguments, using `--prp property_name` for property and `--64` or `--32` for architecture. For additional options, run `path/to/symbiotic --help`.
