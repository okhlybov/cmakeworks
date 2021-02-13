module ext

use iso_c_binding

contains

subroutine f_ext() bind(c)
    use mpi
    integer ierr, size
    call mpi_init(ierr)
    call mpi_comm_size(mpi_comm_world, size, ierr)
    print *, 'mpi=', size
    call mpi_finalize(ierr)
end

end
