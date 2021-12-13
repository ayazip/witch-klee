#!/bin/bash

# Help
help() {
    echo
    echo "Witch-KLEE - a violation witness checker based on KLEE"
    echo "Usage:"
    echo
    echo "     To run witness validation:     witch.sh program witness"
    echo
    echo "     To display this help message:  witch.sh help"
    echo
    echo "NOTE: Make sure that KLEE has been built and the executable binary is in witch-klee/klee/build/bin"
}


if [[ "$1" == "help" ]]
then help; exit
fi

if [[ -z "$1" ]] || [[ -z $2 ]]
then help; exit 1
fi

witchklee="`dirname $0`/klee/build/bin/witch-klee"
program=$1
witness=$2

if [[ ! -f $program ]]; then echo "Program file does not exist"; exit 1; fi
if [[ ! -f $witness ]]; then echo "Witness file does not exist"; exit 1; fi


flags="-c -emit-llvm -D__inline= -Wno-implicit-function-declaration -Wno-unused-parameter -Wno-unknown-attributes -Wno-unused-label -Wno-unknown-pragmas -Wno-unused-command-line-argument -O0 -disable-llvm-passes -g -fbracket-depth=-1"

prp=0
spec=`grep -o '<data key="specification">.*</data>' $witness | grep -o CHECK\(.*LTL\(.*\)`
arch=`grep '<data key="architecture">' $witness | sed -e 's/.*<data key="architecture">\([3264]*\)bit<\/data>.*/\1/'`

echo

if [[ -z "$arch" ]] || [[ -z $spec ]]
then echo "Invalid witness specification or architecture"; exit
fi

if echo $spec | grep -q "F end"
then 
	echo "Unsupported witness specification" && exit
fi

if echo $spec | grep -q "G valid-free" || echo $spec | grep -q "G valid-memtrack" || echo $spec | grep -q "G valid-deref"
then 
	echo "Memory safety witness validation"
	flags="$flags -fsanitize-address-use-after-scope"
	prp=1
fi

if echo $spec | grep -q "G ! overflow"
then 	
	echo "No overflow witness validation"
	flags="$flags -fsanitize=signed-integer-overflow -fsanitize=shift"
	prp=1
fi

if echo $spec | grep  -q "G valid-memcleanup"
then 
	echo "Memory cleanup witness validation" 
	prp=1
fi

if [[ $prp -eq 0 ]]
then
	echo "Reach safety witness validation"
fi

flags="$flags -m${arch}"
echo "PROGRAMFILE: $program"
echo "WITNESSFILE: $witness"
echo

name=`basename -s .c program`
bitcode=`mktemp -t ${name}_XXXXXXXX`.bc
result=`mktemp -t ${name}_XXXXXXXX`.result

clang $flags -o $bitcode $program

$witchklee -dump-states-on-halt=0 --output-stats=0 --use-call-paths=0 --optimize=false -silent-klee-assume=1 -istats-write-interval=60s -timer-interval=10 -only-output-states-covering-new=1 -use-forked-solver=0 -external-calls=pure -max-memory=8000 -max-time=0 -malloc-symbolic-contents $bitcode $witness 2>&1 | tee $result

r=`cat $result | grep "Valid violation witness"`

echo
echo RESULT: 
if [[ -n "$r" ]]
then
        echo -e "\033[33;32m${r#KLEE: }";
	echo -e "\033[33;32mVerification result confirmed.";
else 
	echo "Verification result unconfirmed."
fi

rm $result $bitcode
