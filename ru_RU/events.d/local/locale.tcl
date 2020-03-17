###############################################################################
#
# Locale specific functions for playing back time, numbers and spelling words.
# Often, the functions in this file are the only ones that have to be
# reimplemented for a new language pack.
#
###############################################################################
# Руский синтаксис для воспроизведения времени
# by R2ADU
###############################################################################


#
# Returns the digit modifier according to case 
#
proc getCase {value} {
  if {[string length $value] > 2 } {   
    set value [string range $value [string length $value]-2 [string length $value]]
  }
  if {[string length $value] == 2 } {
    if {([string index $value 0] == 1)} {return "s" } else {set value [string index $value 1]}
  }
  if {($value == 0) || ($value >= 5) } {return "s"}
  if {($value >= 2) && ($value <= 4) } {return "1"} else {return ""}  
}


#
# Say the time specified by function arguments "hour" and "minute".
#
proc playTime {hour minute} {
  variable Logic::CFG_TIME_FORMAT
  # Strip white space and leading zeros. Check ranges.
  if {[scan $hour "%d" hour] != 1 || $hour < 0 || $hour > 23} {
    error "playTime: Non digit hour or value out of range: $hour"
  }
  if {[scan $minute "%d" minute] != 1 || $minute < 0 || $minute > 59} {
    error "playTime: Non digit minute or value out of range: $minute"
  }
  if {[info exists CFG_TIME_FORMAT] && ($CFG_TIME_FORMAT == 12)} {
    if {$hour < 12} {
      set ampm "AM";
      if {$hour == 0} {
        set hour 12;
      }
    } else {
      set ampm "PM";
      if {$hour > 12} {
        set hour [expr $hour - 12];
      }
    }
  }
  if {$hour > 20} {
    playMsg "Default" "[string index $hour 0]X"
    playMsg "Default" [string index $hour 1]
  } else {
    if {$hour != 0} {
      playMsg "Default" $hour
    }
  }
  playMsg "Default" "hour[getCase $hour]"
  if {$minute != 0} {
    if {$minute > 20} {
      playMsg "Default" "[string index $minute 0]X"
      set minute [string index $minute 1]
    }
    if {$minute > 2} {
      playMsg "Default" $minute
    } else {
      if {$minute !=0} {
        playMsg "Default" "[string index $minute 0]f"
      }
    }
    playMsg "Default" "minute[getCase $minute]"
  }
  if {[info exists CFG_TIME_FORMAT] && ($CFG_TIME_FORMAT == 12)} {
    playMsg "Core" $ampm;
    playSilence 100;
  }
}

#
# Say the specified digit number (0 - 999999)
# Произносит число от 0 до 999 999
#
proc playNumber {number} {
  if {[regexp {(\d+)\.(\d+)?} $number -> integer fraction]} {
    playNumber $integer;
    playMsg "Default" "decimal"
    playNumber  $fraction;
    return;
  }
  if {$number > 999999} {
    error "playNumber: Value out of range: $number"
  }
  if {$number > 999} {
    set hungreds [string range $number 0 end-3]
    playNumber $hungreds
    playMsg "Default" "hungred[getCase $hungreds]"
    set number [string range $number [string length $hungreds] end]
  }
  while {[string length $number]> 0} {
    if {$number !=0 && [string index $number 0]==0} {set number [string range $number 1 end]}
    set len [string length $number];
    if {$len == 3} {
      playMsg "Default" "[string index $number 0]00"
      set number [string range $number 1 end]
    }
    if {$len == 2} {
      if {[string index $number 0]==0} {
      set number [string range $number 1 end]
      } else {
        if {$number > 20} {
          playMsg "Default" "[string index $number 0]X"
          if {[string index $number 1]!=0} {
            set number [string index $number 1]
          } else {
            set number "" 
          }
        } else {
          if {$number != 0} {
            playMsg "Default" "$number"
            set number ""
          }
        }
      }
    } 
    if {$len == 1} {
      playMsg "Default" "$number"
      set number ""
    }
  }
}






# End russian localisation