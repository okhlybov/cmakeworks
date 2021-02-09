#include <iostream>

#include "inc.hpp"

int cxx_inc(int i) {
    std::cout << "cxx_inc()" << std::endl;
    return i + 1;
}
