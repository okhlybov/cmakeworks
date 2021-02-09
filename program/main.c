#include <mpi.h>
#include <gmp.h>
#include <omp.h>
#include <stdio.h>

#include "inc.h"
#include "inc.hpp"
extern int f_inc(int);

int main(int argc, char** argv) {
    mpz_t t;
    mpz_init(t);
    MPI_Init(&argc, &argv);
    printf("%d\n", c_inc(cxx_inc(f_inc(mpz_get_si(t)))));
    MPI_Finalize();
    mpz_clear(t);
}