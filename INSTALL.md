# How to compile Excview utilitaries


##  1. Download the code

The source code of Excview package containing the scripts, utilities and documentation is available on 
[Excview repository](https://github.com/colombarifm/excview)

## 2. Install prerequisites

Excview run depends on multiple linux programs to run

* [VMD](https://www.ks.uiuc.edu/Research/vmd/)
* [ImageMagick](https://imagemagick.org/)
* [Gnuplot](http://www.gnuplot.info/)
* [PDFLatex](https://www.tug.org/texlive/)
* [FFmpeg](https://ffmpeg.org/)

## 3. Compile utilitary programs

Excview contains two fortran utilitaries provides at the src/ directory

  * esp.f90
  * excited_charges.f90

which require the gfortran 5.4+ package and can be compiled with the provided makefile.

## 4. Talk to me

For doubts and troubleshooting, please contact me:

  * Felippe Mariano Colombari (colombarifm@hotmail.com)
