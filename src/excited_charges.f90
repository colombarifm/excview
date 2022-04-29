!---------------------------------------------------------------------------------------------------
! EXCVIEW: a set of tools to analyze excitations from xTB/sTDA calculations
! --------------------------------------------------------------------------------------------------
!
!   Free software, licensed under GNU GPL v3
!
!   Copyright (c) 2019 - 2022 Felippe M. Colombari
!
!   This file was written by Felippe M. Colombari.
!
!---------------------------------------------------------------------------------------------------
!
!   This is free software: you can redistribute it and/or modify it under the terms of the GNU 
!   General Public License as published by the Free Software Foundation, either version 3 of the 
!   License, or (at your option) any later version.
!
!   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
!   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See 
!   the GNU General Public License for more details.
!
!   You should have received a copy of the GNU General Public License along with this program. If 
!   not, see <https://www.gnu.org/licenses/>.
!
!---------------------------------------------------------------------------------------------------
!> @file   excited_charges.f90
!
!> @brief  calculate average loewdin atomic partial charges from the .exc stda file in a given 
!>         wavelength range
!> @author Felippe M. Colombari 
!> @email bug reports to: colombarifm@hotmail.com
!> @date - Jan, 2019                                                                              #
!> - first code written                                                                           #
!> @date - Aug, 2021                                                                              #
!> - documentation and revision                                                                   #
!> @date - Apr, 2022                                                                              #
!> - documentation and revision                                                                   #
!---------------------------------------------------------------------------------

program excited_charges

  implicit none

  integer, parameter                             :: DP = selected_real_kind(14)
  real(kind=DP), parameter                       :: H_PLANCK = 4.13566743_DP * 10.0d-15 !10.0_DP**(-15) ! eV . s
  real(kind=DP), parameter                       :: C_LIGHT  = 2.99792458_DP * 10.0d5 !10.0_DP**(5)   ! m / s

  integer                                        :: i, j, n_atom, n_states
  integer, allocatable, dimension(:)             :: z_atom
  real(kind=DP), allocatable, dimension(:,:)     :: xyz, delta_q
  real(kind=DP), allocatable, dimension(:)       :: energy, wavelength
  character(len=5)                               :: dummy, char_init_lambda, char_final_lambda
  character(len=256)                             :: infile_exc, filename

  integer                                        :: n_roots
  integer, dimension(:)                          :: lowest_root(1), highest_root(1)
  real(kind=DP)                                  :: lambda_min, lambda_max, lowest_lambda, highest_lambda
  real(kind=DP), allocatable, dimension(:)       :: avg_q

  logical, allocatable, dimension(:)             :: logical_wavelength

  call get_command_argument( 1, char_init_lambda )
  call get_command_argument( 2, char_final_lambda )
  call get_command_argument( 3, infile_exc )

  read( char_init_lambda, * ) lambda_min
  read( char_final_lambda, * ) lambda_max

  infile_exc = trim(infile_exc)

  write(*,*)
  write(*,'("  Looking for transitions between ",A, " and ", A," nm...")',advance="NO") trim(char_init_lambda), &
                                                                                        trim(char_final_lambda)
  open( unit = 10, file = infile_exc, status = "old" )

  read(10,*) n_atom, n_states
  read(10,*)

  allocate( avg_q(n_atom) )
  allocate( z_atom(n_atom) )
  allocate( xyz(3,n_atom) )

  allocate( energy(n_states) )
  allocate( wavelength(n_states) )
  allocate( logical_wavelength(n_states) )
  
  allocate( delta_q(n_atom,n_states) )

  do i = 1, n_atom

    read(10,*) xyz(:,i), z_atom(i)
          
  enddo
   
  read(10,*) 
  
  do j = 1, n_states

    read(10,*) dummy, energy(j)
    read(10,*)
    read(10,*)
    read(10,*)

    wavelength(j) = 10d9 * H_PLANCK * C_LIGHT / energy(j) 

    do i = 1, n_atom

      read(10,*) delta_q(i,j)

    enddo

  enddo

  close(10)

  n_roots = 0
  avg_q = 0.0_DP

  logical_wavelength = ( ( wavelength >= lambda_min ) .and. ( wavelength <= lambda_max ) )

  n_roots = count( logical_wavelength )
  
  write(*,'(" DONE")')
  write(*,*)
  
  filename = "average_"//trim( char_init_lambda )//"-"//trim( char_final_lambda )//".dat"

  open( unit = 999, file = trim( filename ), status = "replace")

  if ( n_roots > 0 ) then

    write(*,'("  Number of roots found : ",i5)') n_roots 
    write(*,*)
    write(*,'(18x,5x,"Lambda (nm)",5x,"Energy (eV)")')

    lowest_lambda = minval( wavelength, mask = wavelength >= lambda_min )
    lowest_root = minloc( wavelength, mask = wavelength >= lambda_min )

    write(*,*)
    write(*,'("  First root:",i5,5x,f11.3,5x,f10.5)' ) lowest_root, lowest_lambda, energy( lowest_root(1))

    highest_lambda = maxval( wavelength, mask = wavelength <= lambda_max )
    highest_root = maxloc( wavelength, mask = wavelength <= lambda_max )

    write(*,'("  Last root :",i5,5x,f11.3,5x,f10.5)' ) highest_root, highest_lambda, energy( highest_root(1))
    write(*,*)

    write( *, '("  Calculating averages... ")',advance="NO" )

    do i = 1, n_atom

      avg_q(i) = -sum( delta_q( i, highest_root(1):lowest_root(1) ) ) / n_roots

      write(999,'(f12.8)') avg_q(i) 

    enddo

  else

    do i = 1, n_atom

      write(999,'(f12.8)') avg_q(i) 

    enddo

  endif

  close(999)

  write(*,'("DONE")')
  write(*,*)
  write(*,'("  File written: ",A)') trim(filename)
  write(*,*)

  deallocate( avg_q )
  deallocate( xyz )
  deallocate( z_atom )
  deallocate( delta_q )
  deallocate( energy )
  deallocate( wavelength )
  deallocate( logical_wavelength )

end program
