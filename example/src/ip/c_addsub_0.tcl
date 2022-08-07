##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source c_addsub_0.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./managed_ip_project/managed_ip_project.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project managed_ip_project managed_ip_project -part xc7a35tcpg236-1
  set_property BOARD_PART digilentinc.com:basys3:part0:1.2 [current_project]
  set_property target_language VHDL [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:c_addsub:12.0 }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP c_addsub_0
##################################################################

set c_addsub_0 [create_ip -name c_addsub -vendor xilinx.com -library ip -version 12.0 -module_name c_addsub_0]

set_property -dict { 
  CONFIG.A_Type {Unsigned}
  CONFIG.B_Type {Unsigned}
  CONFIG.A_Width {4}
  CONFIG.B_Width {4}
  CONFIG.Out_Width {4}
  CONFIG.Latency {1}
  CONFIG.B_Value {0000}
} [get_ips c_addsub_0]

set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {0}
} $c_addsub_0

##################################################################

