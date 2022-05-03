#--------------------------------------------------------------------------------------------------#
#   EXCVIEW: a set of tools to analyze excitations from xTB/sTDA calculations                      #
# -------------------------------------------------------------------------------------------------#
#                                                                                                  #       
#   Free software, licensed under GNU GPL v3                                                       #
#                                                                                                  #       
#   Copyright (c) 2019 - 2022 Felippe M. Colombari                                                 #   
#                                                                                                  #       
#   This file was written by Felippe M. Colombari.                                                 #
#                                                                                                  #       
#--------------------------------------------------------------------------------------------------#
#                                                                                                  #       
#   This is free software: you can redistribute it and/or modify it under the terms of the GNU     # 
#   General Public License as published by the Free Software Foundation, either version 3 of the   #
#   License, or (at your option) any later version.                                                #
#                                                                                                  #       
#   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;      #
#   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See  #
#   the GNU General Public License for more details.                                               #
#                                                                                                  #
#   You should have received a copy of the GNU General Public License along with this program. If  #
#   not, see <https://www.gnu.org/licenses/>.                                                      #
#                                                                                                  #
#--------------------------------------------------------------------------------------------------#
#> @file   excview.sh                                                                              #
#                                                                                                  #
#> @brief  analyze excitons from xTB/sTDA calculations along the spectrum.                         #
#> @author Felippe M. Colombari                                                                    #
#> @email bug reports to: colombarifm@hotmail.com                                                  #
#> @date - Jan, 2019                                                                               #
#> - first script created                                                                          #
#> @date - Aug, 2021                                                                               #
#> - documentation and revision                                                                    #
#> @date - Apr, 2022                                                                               #
#> - added "--plot" flag                                                                           #
#> - added "--spec" flag                                                                           #
#> - added "--name" flag                                                                           #
#> - documentation and revision                                                                    #
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#
#!/bin/bash                                      
#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

export LC_NUMERIC="en_US.UTF-8"

#####----- define program name, version and author

program_name="EXCVIEW"
program_version="version 1.0"
program_author="Felippe M. Colombari"

#####----- define column width for terminal

column_width="80"

#####----- define program directories

SCRIPTHOME="/home/felippe/repos/excview"

#####----- define directory where stda files are placed

STDAFILES="/home/felippe/teste_stda_excitons/files_stda"

#####----- load some VMD options

export VMDFORCECPUCOUNT=2
vmd="vmd -nt -size 800 600 -dispdev none"

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Print_header () {

  printf "\t"
  printf "=%.0s" {1..80}
  printf "\n\n"
  printf "\t%*s\n" $(((${#program_name}+$column_width)/2))    "${program_name}"
  printf "\t%*s\n" $(((${#program_version}+$column_width)/2)) "${program_version}"
  printf "\t%*s\n" $(((${#program_author}+$column_width)/2))  "${program_author}"
  printf "\n\t"
  printf "=%.0s" {1..80}
  printf "\n\t"

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Print_footer () {

  printf "\t"
  printf "=%.0s" {1..80}
  printf "\n"

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Show_usage () {

  printf "\n"
  printf "\t\t%6s" "Usage:"

  printf "\n\n"

  line[1]="$0" 
  line[2]="   --min <minimum wavelength (nm)>" 
  line[3]="   --max <maximum wavelength (nm)>" 
  line[4]="   --step <wavelength range to average (nm)>"
  line[5]="   --plot [charges|esp]"
  line[6]="   --spec [uv|ecd|gfactor]"
  line[7]="   --name <basename>"
  line[8]="" 
  line[9]="   --help (shows this help)"
  line[10]=""

  for i in $( seq 1 1 10 )
  do

    printf "\t\t\t%s\n" "${line[$i]}"

  done

  printf "\t\t%6s\n" "For more info and troubleshooting: colombarifm@hotmail.com"
  
  Print_footer

  exit -1

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Check_paths () {

  if [ -z "$SCRIPTHOME" ]
  then

    printf "\t"
    printf "=%.0s" {1..80}
    printf "\n"
    printf "\n\tERROR : \$SCRIPTHOME path is empty.\n\t" 
    printf "\tEdit the %s file.\n\t" $0
    printf "\n"

    Print_footer

    exit

  fi

  if [ -z "$STDAFILES" ]
  then

    printf "\t"
    printf "=%.0s" {1..80}
    printf "\n"
    printf "\n\tERROR : \$STDAFILES path is empty.\n\t" 
    printf "\tEdit the %s file.\n\n\t" $0
    printf "\n"

    Print_footer

    exit

  fi

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Check_arg_num () {

  if [ -z "$arg_num" ] || [[ "$arg_num" == -[0-9]* ]] || [[ "$arg_num" == *[a-z]* ]]
  then

    printf "\n\t\t"
    printf "ERROR : invalid option for %s\n\t\t" $flag_meaning
    printf "TIP   : integer in flag %2s must be > 0\n\n\t" $flag
    printf "        Enter '--help' option for help.\n\n"
   
    Print_footer

    exit
  
  fi

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Check_arg_str () {

  if [ -z "$arg_str" ] || [[ "$arg_str" == -[a-z]* ]]
  then
 
    printf "\n\t\t"
    printf "ERROR : invalid option for %s\n\t\t" $flag_meaning
    printf "TIP   : no valid argument supplied for flag %2s\n\n\t" $flag
    printf "        Enter '-h' option for help.\n\n\n"
  
    Print_footer

    exit
  
  fi

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Call_cmd_line () {

  while [[ "$1" == -* ]] 
  do
  
    case "$1" in
      --help) Show_usage
              exit 0
              ;;
      --min) flag=$1
          flag_meaning="minimum_wavelength"
          shift
          arg_num=$1
          Check_arg_num
          init_nm=$arg_num 
          ;;
      --max) flag=$1
          flag_meaning="maximum_wavelength"
          shift
          arg_num=$1
          Check_arg_num
          final_nm=$arg_num
          ;;
      --step) flag=$1
          flag_meaning="wavelength_range"
          shift
          arg_num=$1
          Check_arg_num
          step_nm=$arg_num
          ;;
      --plot) flag=$1
          flag_meaning="representation_type"
          shift
          arg_str=$1
          Check_arg_str
          plot_opt=$arg_str
          ;;
      --name) flag=$1
          flag_meaning="basename_files"
          shift
          arg_str=$1
          Check_arg_str
          filenames=$arg_str
          ;;
      --spec) flag=$1
          flag_meaning="spectrum_type"
          shift
          arg_str=$1
          Check_arg_str
          spec_type=$arg_str
          ;;
      --)
          shift
          break
          ;;
    esac
    shift
  done

  return 1

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Check_options () {
  
  if [ -z "$init_nm" ] || [ -z "$final_nm" ] || [ -z "$step_nm" ]; then
    
    printf "\n\t\t"
    printf "ERROR : Not enough arguments in command line.\n\t\t"
    
    Show_usage

    exit
  
  else
  
    printf "\n\n\tCalculating excitations from %4s to %4s nm...\n" $init_nm $final_nm 
    
    nframes=$( echo "1 + ($final_nm - $init_nm)/$step_nm" | bc )
    
    printf "\n\tTotal of %i frames\n" $nframes

  fi
 
  if [ "$init_nm" -gt "$final_nm" ]; then

    printf "\t"
    printf "=%.0s" {1..80}
    printf "\n\n\t\t"
    printf "ERROR : Inconsistent arguments in command line.\n\t\t" 
    printf "TIP   : --min value must be smaller than --max\n\t\t"
    
    Show_usage
    
    exit

  fi
  
  if [ "$plot_opt" == "charges" ]
  then
    
    printf "\n\n\tAtoms will be colored according to charge variations...\n" 

  elif [ "$plot_opt" == "esp" ]
  then
    
    printf "\n\n\tAn electrostatic potential variation will generated around the molecule...\n" 

  else

    printf "\t"
    printf "=%.0s" {1..80}
    printf "\n\n\t\t"
    printf "ERROR : Inconsistent arguments in command line.\n\t\t" 
    printf "TIP   : --plot type must be 'esp' or 'charges'.\n\t\t" 
    
    Show_usage
    
    exit
 
  fi   

  if [ "$spec_type" == "uv" ]
  then

    printf "\n\n\tUV-VIS spectrum will be analyzed...\n"

  elif [ "$spec_type" == "ecd" ]
  then

    printf "\n\n\tECD spectrum will be analyzed...\n"

  elif [ "$spec_type" == "gfactor" ]
  then

    printf "\n\n\tg-factor spectrum will be analyzed...\n"

  else

    printf "\t"
    printf "=%.0s" {1..80}
    printf "\n\n\t\t"
    printf "ERROR : Inconsistent arguments in command line.\n\t\t" 
    printf "TIP   : --spec type must be 'ecd' or 'uv'.\n\t\t" 
    
    Show_usage
    
    exit
 
  fi   

  if [ -z "$filenames" ]
  then

    printf "\t"
    printf "=%.0s" {1..80}
    printf "\n\n\t\t"
    printf "ERROR : Inconsistent arguments in command line.\n\t\t" 
    printf "TIP   : --name argument is missing.\n\n" 
    
    Show_usage
    
    exit

  fi

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Inquire_files () {
  
  excview_directories="files_graphics programs"

  for i in $excview_directories
  do

    if [ -d "$SCRIPTHOME/$i" ]
    then

      printf "\n\tReading directory \"$i/\"... DONE\n"
  
    else
    
      printf "\n\tMissing directory \"$i/\". Aborting.\n"
    
      exit
  
    fi

  done

  if [ -d "$STDAFILES" ]
  then

    printf "\n\tReading directory \"$i/\"... DONE\n"
  
  else
    
    printf "\n\tMissing directory \"$i/\". Aborting.\n"
    
    exit

  fi

  if [ "$plot_opt" == "charges" ]
  then

    files_calc="${filenames}.xyz ${filenames}_${spec_type}.dat ${filenames}.exc"
  
  elif [ "$plot_opt" == "esp" ]
  then

    files_calc="${filenames}.xyz sas_${filenames}.xyz ${filenames}_${spec_type}.dat ${filenames}.exc"

  fi

  printf "\n\tChecking xTB/sTDA output files...\n"

  for i in $files_calc; do
    
    if [ -f "$STDAFILES/$i" ]
    then
    
      printf "\n\t\tInput file \"../$i\" found!"  
    
    else

      printf "\n\t\tInput file \"../$i\" not found. Aborting.\n"
  
      exit
    
    fi
  
  done

  files_graphics="${spec_type}_plot.gnplt molecule_colors.tcl molecule_view.tcl"

  printf "\n\n\tChecking files for graphics...\n"

  for i in $files_graphics; do
    
    if [ -f "$SCRIPTHOME/files_graphics/$i" ]
    then
      
      printf "\n\t\tInput file \"$SCRIPTHOME/files_graphics/$i\" found!"  
    
    else

      printf "\n\t\tInput file \"$SCRIPTHOME/files_graphics/$i\" not found. Aborting.\n"
      
      exit
    
    fi
  
  done

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Inquire_programs () {
  
  if [ "$plot_opt" == "charges" ]
  then

    programs="excited_charges"

  elif [ "$plot_opt" == "esp" ]; then

    programs="esp excited_charges"

  fi
 
  printf "\n\n\tChecking programs...\n"

  for i in $programs; do
    
    if [ -f "$SCRIPTHOME/programs/$i" ]
    then
      
      printf "\n\t\tExecutable \"$SCRIPTHOME/programs/%s\" found!" $i
    
    else
      
      printf "\n\t\tExecutable \"$SCRIPTHOME/programs/$i\" not found. Aborting.\n"
  
      exit
    
    fi
  
  done

  printf "\n\n\tOK. Starting calculations.\n"

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Inquire_system_programs () {

  printf "\n\n\tChecking system programs...\n"
  
  system_programs="vmd convert pdflatex gnuplot ffmpeg"

  for i in $system_programs
  do

    if ! command -v  $i &> /dev/null
    then

      printf "\n\t\tProgram $i not found in your system. Aborting.\n"

      exit

    else
    
      printf "\n\t\tProgram $i found!"

    fi

  done

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Calculate_avg_charges () {

  printf "\n\t|---------------------------------------------------------------------------------------------|\n"
  printf "\n\t\tCalculating average charge variations for excitations between ${w_ini} and ${w_end} nm... \n" 
  
  $SCRIPTHOME/programs/excited_charges ${w_ini} ${w_end} $STDAFILES/${filenames}.exc > ${filenames}_transitions.log
  
  printf "\t\tDONE\n"

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Calculate_esp () {

  printf "\n\t\tCalculating esp from average charge variations... \n" 
  
  $SCRIPTHOME/programs/esp $STDAFILES/${filenames}.xyz \
    average_${w_ini}-${w_end}.dat $STDAFILES/sas_${filenames}.xyz > ${filenames}_esp.log
  
  printf "\t\tDONE\n"

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Plot_spectrum () {

  cp $SCRIPTHOME/files_graphics/${spec_type}_plot.gnplt .

  ini=$( echo "${w_ini}" | bc )
  end=$( echo "${w_end}" | bc )

  sed -i "s/_WINI_/${ini}/g"            ${spec_type}_plot.gnplt
  sed -i "s/_WEND_/${end}/g"            ${spec_type}_plot.gnplt
  sed -i "s|_STDAFILES_|${STDAFILES}|g" ${spec_type}_plot.gnplt
  sed -i "s/_FILENAME_/${filenames}/g"  ${spec_type}_plot.gnplt
  sed -i "s/_SPECTYPE_/${spec_type}/g"  ${spec_type}_plot.gnplt
  
  ./${spec_type}_plot.gnplt
  
  convert -density 800 -flatten ${spec_type}_plot.pdf -quality 95 -resize 1600x700\! ${spec_type}_plot.png
  
  rm ${spec_type}_plot.gnplt ${spec_type}_plot.pdf 

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Generate_molecule () {

  printf "\n\t\tGenerating figure for molecule... \n"

  sed "s/_FILENAME_/${filenames}/g" $SCRIPTHOME/files_graphics/molecule_view.tcl > molecule_view.tcl

  $vmd -xyz $STDAFILES/${filenames}.xyz -e molecule_view.tcl -r 0 &> /dev/null

  convert ${filenames}_mol.tga -resize 760x570\! -bordercolor Black -border 10x10 -bordercolor White -border 20x10 ${filenames}_mol.png
  
  rm ${filenames}_mol.tga

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Generate_figures () {

  if [ "$plot_opt" == "charges" ]; then

    printf "\n\t\tGenerating frame... \n"

    sed "s/_FILENAME_/${filenames}/g" $SCRIPTHOME/files_graphics/molecule_colors.tcl > molecule_colors.tcl

    $vmd -xyz $STDAFILES/${filenames}.xyz -e molecule_colors.tcl -args -f average_${w_ini}-${w_end}.dat -r 0 &> /dev/null

    convert ${filenames}_full.tga -resize 760x570\! -bordercolor Black -border 10x10 -bordercolor White -border 20x10 ${filenames}_full_tmp.png
    
      
    convert ${filenames}_full_tmp.png -background White -pointsize 36 -gravity None \
      -fill Blue -font Symbol -annotate +50+70  "D" -font Helvetica -annotate +80+70  "q > 0" \
      -fill Red  -font Symbol -annotate +50+120 "D" -font Helvetica -annotate +80+120 "q < 0" ${filenames}_full.png

    convert +append ../${filenames}_mol.png ${filenames}_full.png ${filenames}.png
    
    convert -append ${spec_type}_plot.png ${filenames}.png final_${frame_number}.png
  
    rm ${filenames}_full.tga ${filenames}_full_tmp.png ${filenames}_full.png ${spec_type}_plot.png 

  elif [ "$plot_opt" == "esp" ]; then

    Calculate_esp

    printf "\n\t\tGenerating frame... \n"

    for i in esp_Total esp_M esp_Ligands
    do

      $vmd -e ${i}.tcl -r 0 &> /dev/null 
      
      convert ${i}.tga -resize 730x570\! -bordercolor Black -border 10x10 -bordercolor White -border 9x9 ${i}_tmp.png
    
      rm ${i}.tga 

    done

    $vmd -xyz $SCRIPTHOME/files_graphics/bar.xyz -e bar.tcl &> /dev/null

    convert bar.tga -resize 760x570\! -crop +320+0 -crop -320-0 bar_tmp.png

    max_pot=$( tail -n 1 ${filenames}_esp.log | awk '{printf $1}' )
    min_pot=$( tail -n 1 ${filenames}_esp.log | awk '{printf $2}' )

    convert bar_tmp.png -background White -fill black -pointsize 32 -font Helvetica -gravity None \
      -annotate +340+80 "$max_pot" -annotate +345+510 "$min_pot" -annotate +345+550 '(mV)' bar.png

    convert esp_Total_tmp.png   -background White -fill black -pointsize 32 -font Helvetica -gravity None -annotate +60+100 'Total'   esp_Total.png
    convert esp_M_tmp.png       -background White -fill black -pointsize 32 -font Helvetica -gravity None -annotate +60+100 'Metal'   esp_M.png
    convert esp_Ligands_tmp.png -background White -fill black -pointsize 32 -font Helvetica -gravity None -annotate +60+100 'Ligands' esp_Ligands.png

    convert +append ${spec_type}_plot.png ../${filenames}_mol.png         row1.png
    convert +append bar.png esp_Total.png esp_M.png esp_Ligands.png       row2.png
    convert -append row1.png row2.png                                     final_${frame_number}.png

    rm bar.tga bar_tmp.png esp_Total_tmp.png esp_M_tmp.png esp_Ligands_tmp.png row1.png row2.png

  fi
  
  rm -rf figuras/
  
  printf "\t\tDONE\n"
  printf "\n\t|---------------------------------------------------------------------------------------------|\n"

}

#--------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------#

Create_video () {

  #ffmpeg -r 24 -f image2 -pattern_type glob -i  "final_????.jpg" -vcodec mjpeg -qscale 1 final_movie.avi

  printf "\n\t\tConcatenating frames to video file... \n"
  
  if [ -f "final_movie.mpg" ]; then

    rm final_movie.mpg

  fi 

  ffmpeg -an -r 4 -i final_%04d.png -pix_fmt yuv420p -vcodec mpeg2video -r 29.97 -q:v 1 -s 800x600 final_movie.mpg &> /dev/null 
  
  printf "\t\tDONE\n\n"

} 

#--------------------------------------------------------------------------------------------------#
#----------------------------------| JOB SEQUENCE |------------------------------------------------#

Print_header
Call_cmd_line $@
Check_paths
Check_options $#
Inquire_files
Inquire_system_programs
Inquire_programs
Generate_molecule

for i in $( seq $init_nm $step_nm $final_nm ); do

  w_ini=$( printf "%04i" $i )
  w_end=$( echo "$i + $step_nm" | bc -l | awk '{printf "%04i", $1}' )

  frame_number=$( printf "%04i" $nframes )

  mkdir -p range_${w_ini}-${w_end}_nm
  cd       range_${w_ini}-${w_end}_nm

  Calculate_avg_charges ${w_ini} ${w_end}
  Plot_spectrum
  Generate_figures

  mv final_${frame_number}.png ..

  ((nframes--))

  cd ..

done

rm molecule_view.tcl ${filenames}_mol.png

Create_video

#--------------------------------------------------------------------------------------------------#
#---------------------------------------| JOB DONE |-----------------------------------------------#
