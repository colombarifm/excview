# Generates a CPK molecular representation with the atoms colored
# based on an external file contaning average Loewdin atomic partial
# charges from xTB/sTDA.

display resize        800 600
display height        3.800000
display distance      -1.000000
display depthcue      on
display cuedensity    0.30
display nearclip set  0.01
display projection    Orthographic
axes location         off
light 0               on
light 1               on
light 2               off
light 3               off

color Display Background white

set data_name [ lindex $argv 1 ]
set data_file [ open $data_name r ]
set num_atoms [ molinfo top get numatoms ]
set min -0.01
set max  0.01

mol addrep top
mol modrep 1 0
mol modmaterial 1 0 EdgyShiny
mol modstyle 1 0 CPK 1.00 0.50 50 50
mol modselect 1 0 {all}
mol modcolor 1 top User
mol scaleminmax top 1 $min $max

for { set j 0 } { $j < ( $num_atoms ) } { incr j } {
  set field_color [ gets $data_file ]
  set atom_select [ atomselect top "index $j" ]
  $atom_select set user $field_color
  $atom_select delete
}

scale by _SCALE_
rotate z by _ROTZ_
rotate y by _ROTY_
rotate x by _ROTX_
translate by _TRANSX_ _TRANSY_ _TRANSZ_

render TachyonInternal _FILENAME__full.tga

exit
