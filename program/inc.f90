module inc

use iso_c_binding

contains

integer(c_int) function f_inc(i) result(r) bind(c)
    use iso_c_binding, only: c_int
    integer(c_int), value :: i
    print *, 'f_inc()'
    r = i + 1
end function

end module
