patch -p 1 -N -d yaml-cpp < yaml-cpp.patch

cd klee

if [[ -d build ]]
then rm -r build
fi

mkdir build && cd build
cmake   -DENABLE_SOLVER_Z3=ON   -DENABLE_POSIX_RUNTIME=ON   -DENABLE_KLEE_UCLIBC=ON   -DKLEE_UCLIBC_PATH=/home/paula/Lab/thesis/witch-klee/klee-uclibc   -DENABLE_UNIT_TESTS=ON   -DGTEST_SRC_DIR=/home/paula/Lab/thesis/witch-klee/googletest-release-1.7.0  -DLLVM_CONFIG_BINARY=/usr/bin/llvm-config-10  -DLLVMCC=/usr/bin/clang-10   -DLLVMCXX=/usr/bin/clang++-10 .. && make -j6 
