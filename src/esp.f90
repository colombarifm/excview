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
!> @file   esp.f90
!
!> @brief  calculate the electrostatic potential from average loewdin atomic partial charge    
!>         variations and write vmd scripts for visualization
!> @author Felippe M. Colombari 
!> @email bug reports to: colombarifm@hotmail.com
!> @date - Jan, 2019                                                                              #
!> - first code written                                                                           #
!> @date - Aug, 2021                                                                              #
!> - documentation and revision                                                                   #
!> @date - Apr, 2022                                                                              #
!> - documentation and revision                                                                   #
!---------------------------------------------------------------------------------

module write_vmd_files

  contains

    subroutine write_vmd_surfaces( filename, min_pot, max_pot, field )

      implicit none

      integer, parameter                        :: DP = selected_real_kind(14)
      character(len=256), intent(IN)            :: filename
      real(kind=DP), intent(IN)                 :: min_pot, max_pot
      integer, intent(IN)                       :: field

      open( unit = 10, file = trim(filename)//'.tcl', status = "replace" )

      write(10,'("# Generates an electrostatic surface potential along the grid")')
      write(10,*)
      write(10,'("display resize        800 600")')
      write(10,'("display height        3.800000")')
      write(10,'("display distance      -1.000000")')
      write(10,'("display depthcue      on")')
      write(10,'("display cuedensity    0.30")')
      write(10,'("display nearclip set  0.01")')
      write(10,'("display projection    orthographic")')
      write(10,'("axes location off")')
      write(10,'("light 0 on")')
      write(10,'("light 1 on")')
      write(10,'("light 2 off")')
      write(10,'("light 3 off")')
      write(10,*)
      write(10,'("color Display Background white")')
      write(10,*)
      write(10,'("mol new final_esp.xyz type xyz")')
      write(10,'("set data_file [ open ""final_esp.xyz"" r ]")')
      write(10,'("set num_atoms [ molinfo top get numatoms ]")')      
      write(10,'("mol modmaterial 0 0 Edgy")')
      write(10,'("mol modstyle 0 0 QuickSurf 1.00 0.50 0.50 3.00")')
      write(10,'("mol modselect 0 0 {all}")')
      write(10,'("mol modcolor 0 top User")')
      write(10,'("mol scaleminmax top 0", 2(2x,f6.1))') min_pot, max_pot
      write(10,*)
      write(10,'("set file_line_1 [ gets $data_file ]")')
      write(10,'("set file_line_2 [ gets $data_file ]")')
      write(10,'("for { set j 0 } { $j < ( $num_atoms ) } { incr j } {")')
      write(10,'("  set field_color [ gets $data_file ]")')
      write(10,'("  set data_field [ lindex $field_color",i2," ]")') field
      write(10,'("  set atom_select [ atomselect top ""index $j"" ]")')
      write(10,'("  $atom_select set user $data_field")')
      write(10,'("  $atom_select delete")')
      write(10,'("}")')
      write(10,*)
      write(10,'("scale by _SCALE_")')
      write(10,'("rotate z by _ROTZ_")')
      write(10,'("rotate y by _ROTY_")')
      write(10,'("rotate x by _ROTX_")')
      write(10,'("translate by _TRANSX_ _TRANSY_ _TRANSZ_")')
      write(10,*)
      write(10,'("render TachyonInternal ",(A))') trim(filename)//'.tga'
      write(10,*)
      write(10,'("exit")')

      close(10)

    end subroutine write_vmd_surfaces

    subroutine write_color_bar( filename, min_pot, max_pot )

      implicit none

      integer, parameter                        :: DP = selected_real_kind(14)
      character(len=256), intent(IN)            :: filename
      real(kind=DP), intent(IN)                 :: min_pot, max_pot
      real(kind=DP)                             :: min_value, max_value

      open( unit = 10, file = trim(filename)//'.tcl', status = "replace" )

      if ( ( dabs(min_pot) < 0.05_DP ) .and. ( dabs(max_pot) < 0.05_DP ) ) then

        min_value = 0.0_DP
        max_value = 0.0_DP

      else

        min_value = 0.0_DP
        max_value = 100.0_DP

      endif

      write(10,'("# Generates an electrostatic surface potential along the grid")')
      write(10,*)
      write(10,'("display resize        800 600")')
      write(10,'("display depthcue      on")')
      write(10,'("display cuedensity    0.30")')
      write(10,'("display nearclip set  0.01")')
      write(10,'("display projection    orthographic")')
      write(10,'("axes location off")')
      write(10,'("light 0 on")')
      write(10,'("light 1 on")')
      write(10,'("light 2 off")')
      write(10,'("light 3 off")')
      write(10,*)
      write(10,'("color Display Background white")')
      write(10,*)
      write(10,'("mol modmaterial 0 0 Edgy")')
      write(10,'("mol modstyle 0 0 QuickSurf 1.20 0.50 0.50 3.00")')
      write(10,'("mol modcolor 0 top PosY")')
      write(10,'("mol scaleminmax top 0 ", f7.2, 2x, f7.2)') min_value, max_value
      write(10,'("scale by 1.10")')
      write(10,*)
      write(10,'("render TachyonInternal ",(A))') trim(filename)//'.tga'
      write(10,*)
      write(10,'("exit")')

      close(10)

      end subroutine write_color_bar

  end module write_vmd_files

program calculate_esp

  use write_vmd_files

  implicit none

  integer, parameter                                :: DP = selected_real_kind(14)

  real(kind=DP), parameter                          :: K_COUL = 8.9876_DP*10.0_DP**(9) ! coulomb constant
  real(kind=DP), parameter                          :: E2C = 1.6022_DP*10.0_DP**(-19)  ! converts e to Coulomb
  real(kind=DP), parameter                          :: A2M = 10.0_DP**(-10)            ! converts Angstrom to m
  real(kind=DP), parameter                          :: mV  = 10.0_DP**(3)              ! converts mV to V

  integer                                           :: i, j, numat, npoints

  real(kind=DP), allocatable, dimension(:)          :: q, pot_tot, pot_M, pot_lig
  real(kind=DP), allocatable, dimension(:,:)        :: xyz, grid_xyz
  character(len=3), allocatable, dimension(:)       :: label

  character(len=3)                                  :: dummy
  character(len=256)                                :: infile_charges, infile_coords, infile_grid, filename

  real(kind=DP)                                     :: rij, min_pot, max_pot

  call get_command_argument( 1, infile_coords )
  call get_command_argument( 2, infile_charges )
  call get_command_argument( 3, infile_grid )

  infile_coords  = trim(infile_coords)
  infile_charges = trim(infile_charges)
  infile_grid    = trim(infile_grid)

  open( unit = 666, file = infile_coords, status = "old" )
  open( unit = 665, file = infile_charges, status = "old" )

  read(666,*) numat
  read(666,*)

  allocate( q(numat) )
  allocate( label(numat) )
  allocate( xyz(3,numat) )

  do i = 1, numat

    read(666,*) label(i), xyz(:,i)
    read(665,*) q(i)

  enddo

  close(665)
  close(666)

  open( unit = 667, file = infile_grid, status = "old" )

  read(667,*) npoints
  read(667,*)

  allocate( pot_tot(npoints) )
  allocate( pot_M(npoints) )
  allocate( pot_lig(npoints) )
  allocate( grid_xyz(3,npoints) )

  do j = 1, npoints

    read(667,*) dummy, grid_xyz(:,j)

  enddo

  close(667)

  open( unit = 668, file = "final_esp.xyz", status = "replace" )

  write(668,*) npoints
  write(668,'(a2,3(3x,a12),3(3x,a12))') "   ", "X", "Y", "Z", "pot. total", "pot. M", "pot. lig."

  pot_tot  = 0.0_DP
  pot_M    = 0.0_DP
  pot_lig  = 0.0_DP

  do j = 1, npoints

    do i = 1, numat

      rij = dsqrt( sum( ( grid_xyz(:,j) - xyz(:,i) )**2 ) )
                                ! N*m^2/C^2* e    * C/e  /  A  *  m/A
                                ! N*m^2/C^2*    C        /     m
                                ! N*m  /  C
                                ! J / C = V
      pot_tot(j) = pot_tot(j) + k_coul * q(i) * e2c * mV / ( rij * a2m ) 

      if ( ( label(i) == 'Cu' ) .or. ( label(i) == 'S' ) ) then

        pot_M(j) = pot_M(j) + k_coul * q(i) * e2c * mV / ( rij * a2m ) 

      else 

        pot_lig(j) = pot_lig(j) + k_coul * q(i) * e2c * mV / ( rij * a2m ) 

      endif

    enddo

    write(668,'(a2,3(3x,f12.6),5(3x,f12.5))') "XX ", grid_xyz(:,j), pot_tot(j), pot_M(j), pot_lig(j)

  enddo

  close(668)

  write(*,*)
  write(*,'(" TOTAL ESP ")')
  write(*,'("----------------------------------------------------")')
  write(*,'(" Min. ESP / Max. ESP : ", f7.3, " mV", f7.3, " mV")') minval(pot_tot), maxval(pot_tot)
  write(*,'(" Delta V             : ", f7.3, " mV")') maxval(pot_tot) - minval(pot_tot)

  write(*,*)
  write(*,'(" NP ESP ")')
  write(*,'("----------------------------------------------------")')
  write(*,'(" Min. ESP / Max. ESP : ", f7.3, " mV", f7.3, " mV")') minval(pot_M), maxval(pot_M)
  write(*,'(" Delta V             : ", f7.3, " mV")') maxval(pot_M) - minval(pot_M)
  
  write(*,*)
  write(*,'(" LIG. ESP ")')
  write(*,'("----------------------------------------------------")')
  write(*,'(" Min. ESP / Max. ESP : ", f7.3, " mV", f7.3, " mV")') minval(pot_lig), maxval(pot_lig)
  write(*,'(" Delta V             : ", f7.3, " mV")') maxval(pot_lig) - minval(pot_lig)
  
  write(*,*)

  min_pot =  ( minval(pot_M) + minval(pot_lig) ) / 2.0_DP

  if ( dabs(min_pot) > 0.0_DP ) then

    max_pot = -1.0_DP * min_pot
    write(*,'(SP,f7.1,2x,f7.1)') max_pot, min_pot 

  else

    max_pot = 0.0_DP 
    write(*,'(f7.1,2x,f7.1)') max_pot, min_pot 

  endif

  filename = "esp_Total"

  call write_vmd_surfaces( filename, min_pot, max_pot, 4 )

  filename = "esp_M"

  call write_vmd_surfaces( filename, min_pot, max_pot, 5 )

  filename = "esp_Ligands"
  
  call write_vmd_surfaces( filename, min_pot, max_pot, 6 )

  filename = "bar"

  call write_color_bar( filename, min_pot, max_pot )

  deallocate(xyz)
  deallocate(label)
  deallocate(grid_xyz)
  deallocate(q)
  deallocate(pot_tot)
  deallocate(pot_M)
  deallocate(pot_lig)

end program calculate_esp
