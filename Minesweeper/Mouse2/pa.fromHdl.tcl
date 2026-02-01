
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Mouse2 -dir "/home/george/Electronics/FPGA/Mouse2/planAhead_run_1" -part xc3s500efg320-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property top Mouse_Test $srcset
set_param project.paUcfFile  "Mouse_Test.ucf"
set hdlfile [add_files [list {ps2_mouse_interface.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Mouse_Test.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
add_files "Mouse_Test.ucf" -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s500efg320-4
