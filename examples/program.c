int foo () {
    return __VERIFIER_nondet_int();
}

int main () {
    int a = __VERIFIER_nondet_int();
    int b = foo();
    b = b + 1;
    if (a < b)
        reach_error();
    return 0;
}
