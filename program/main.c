#include <gmp.h>
#include <stdio.h>

#include "inc.h"
#include "inc.hpp"
extern int f_inc(int);

#include "ext.hpp"

int main(int argc, char** argv) {
    mpz_t t;
    mpz_init(t);
    mpz_set_si(t, 1);
    printf("%d\n", c_inc(cxx_inc(f_inc(mpz_get_si(t)))));
    mpz_clear(t);
}
