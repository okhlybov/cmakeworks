#include <omp.h>
#include <iostream>

#include "ext.hpp"

void cxx_ext() {
    std::cout << "omp=" << omp_get_num_threads() << std::endl;
}