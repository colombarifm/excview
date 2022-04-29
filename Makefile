# makefile for 

PROGRAMS = esp excited_charges

FC = gfortran

FFLAGS = -g -Wall -O3 -fcheck=bounds -Wno-compare-reals -Wno-conversion -fbacktrace -fcheck=all -Wextra -no-pie -ffpe-summary=none

# objects created
OBJS = esp.o excited_charges.o 
	    
# modules created
MODS =	write_vmd_files.mod

all: $(OBJS)

#$(OBJS): %: %.f90

#(FC) $(SRC) $(FFLAGS) -o $@ $<
#@printf "\n"
#@printf "  GENERATING EXECUTABLES...\n"
#@printf "\n"

esp.o: src/esp.f90
	@printf "\n"
	@printf "  CREATING OBJECTS...\n"
	@printf "\n"
	@$(FC) -c src/esp.f90 $(FFLAGS) -o src/esp.o -Jsrc
	@printf "   ** Compiling $@\n"      
	@mkdir -p programs/
	@$(FC) src/esp.o $(FFLAGS) -o programs/esp
	@printf "  CLEANING FILES...\n"
	@printf "\n"
	@rm src/*.o src/*.mod

excited_charges.o: src/excited_charges.f90
	@printf "\n"
	@printf "  CREATING OBJECTS...\n"
	@printf "\n"
	@$(FC) -c src/excited_charges.f90 $(FFLAGS) -o src/excited_charges.o
	@printf "   ** Compiling $@\n"       
	@$(FC) src/excited_charges.o $(FFLAGS) -o programs/excited_charges 
	@printf "  CLEANING FILES...\n"
	@printf "\n"
	@rm src/*.o 


