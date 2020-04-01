# Исправление для модуля EchoLink
# by R2ADU
#
#

###############################################################################
#
# EchoLink module event handlers
#
###############################################################################


#
# This is the namespace in which all functions and variables below will exist.
# The name must match the configuration variable "NAME" in the
# [ModuleEchoLink] section in the configuration file. The name may be changed
# but it must be changed in both places.
#
namespace eval EchoLink {
	

proc status_report {} {
  variable num_connected_stations;
  variable module_name;
  global active_module;
 
  if {$active_module == $module_name} {
    speakNumber "EchoLink" $num_connected_stations "connected_station"
    playSilence 200
  }
}

}