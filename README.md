# Excview

Excview consists in a set of scripts/tools designed to visualize/analyze the 
electronic excitations from a xTB/sTDA calculation. 

Excview is a free software, contaning bash scripts and Fortran programs, being 
available at https://github.com/colombarifm/excview under the GPLv3+ License. 
It runs under Linux environment with gfortran/gcc 5.4+ compilers and with vmd, 
imagemagick, ffmpeg, gnuplot and pdflatex softwares.

# For installation details and required programs to run Excview 

See [installation instructions](./INSTALL.md)  

# Directory organization

* [`src`](./src): The source code for Excview utilitaries
* [`files_graphics`](./utils): Scripts to generate sTDA spectrum and graphic representations
* [`test`](./test): Input files for testing (from UV-Vis xTB/sTDA calculation of phthalocyanin)

  ** UV-Vis or ECD spectrum calculated with xtb4stda/stda programs (spec.dat, renamed to basename.dat);
  ** exciton file from stda calculation (tda.exc, obtained with the -excprint flag and renamed to basename.exc);
  ** molecular structure in XYZ format (basename.xyz);
  ** SAS grid for molecular structure in XYZ format (for esp calculations only; sas_basename.xyz)
