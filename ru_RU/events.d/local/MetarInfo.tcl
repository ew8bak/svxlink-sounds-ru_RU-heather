namespace eval MetarInfo {

proc speakNumber {msg unit} {
  variable module_name;
  ::speakNumber $module_name $msg $unit;
}


# MET-report TIME
proc metreport_time item {
   playMsg "metreport_time"
   set hr [string range $item 0 1]
   set mn [string range $item 2 3]
   playTime $hr $mn
   playSilence 200
}


# temperature
proc temperature {temp} {
  playMsg "temperature"
  playSilence 100
  if {$temp == "not"} {
    playMsg "not"
    playMsg "reported"
  } else {
    speakNumber $temp "unit_degree"
  }
  playSilence 200
}

# dewpoint
proc dewpoint {dewpt} {
  playMsg "dewpoint"
  playSilence 100
  if {$dewpt == "not"} {
    playMsg "not"
    playMsg "reported"
  } else {
    speakNumber $dewpt "unit_degree"
    playSilence 100
  }
  playSilence 200
}

# sea level pressure
proc slp {slp} {
  playMsg "slp"
  speakNumber $slp "unit_hPa"
  playSilence 200
}

# flightlevel
proc flightlevel {level} {
  playMsg "flightlevel"
  speakNumber $level ""
  playSilence 200
}

# wind
proc wind {deg {vel 0 } {unit 0} {gusts 0} {gvel 0}} {
  playMsg "wind"
  if {$deg == "calm"} {
    playMsg "calm"
  } elseif {$deg == "variable"} {
    playMsg "variable"
    playSilence 200
    speakNumber $vel $unit
  } else {
    # ветер ... м/сек на ... градусов
    speakNumber $vel $unit
    playSilence 100
    playMsg "at"
    playSilence 100
    speakNumber $deg "unit_degree"
    playSilence 100
    if {$gusts > 0} {
      playMsg "gusts_up"
      speakNumber $gusts $gvel
    }
  }
  playSilence 200
}

# weather actually
proc actualWX args {
  foreach item $args {
    if [regexp {(\d+)} $item] {
      playNumber $item
    } else {
      playMsg $item
    }
  }
  playSilence 200
}

# wind varies $from $to
proc windvaries {from to} {
   playMsg "wind"
   playSilence 50
   playMsg "varies_from"
   playSilence 100
   playNumber $from
   playSilence 100
   playMsg "to"
   playSilence 100
   speakNumber $to "unit_degree"
   playSilence 200
}

# Peak WIND
proc peakwind {deg kts hh mm} {
   playMsg "pk_wnd"
   playMsg "from"
   playSilence 100
   speakNumber $deg "unit_degree"
   playSilence 100
   speakNumber $kts "unit_kt"
   playSilence 100
   playMsg "at"
   if {$hh != "XX"} {
      speakNumber $hh "hour"
   }
   speakNumber $mm "minute"
   playMsg "utc"
   playSilence 200
}

# ceiling varies $from $to
proc ceilingvaries {from to} {
   playMsg "ca"
   playSilence 50
   playMsg "varies_from"
   playSilence 100
   set from [expr {int($from) * 100}]
   playNumber $from
   playSilence 100
   playMsg "to"
   playSilence 100
   set to [expr {int($to)*100}]
   speakNumber $to "unit_feet"
   playSilence 200
}

# time
proc utime {utime} {
   set hr [string range $utime 0 1]
   set mn [string range $utime 2 3]
   playTime $hr $mn
   playSilence 100
   playMsg "utc"
   playSilence 200
}

# vv100 -> "vertical view (ceiling) 1000 feet"
proc ceiling {param} {
   playMsg "ca"
   playSilence 100
   speakNumber $param "unit_feet"
   playSilence 200
}

# QNH
proc qnh {value} {
  playMsg "qnh"
  speakNumber $value "unit_hPa"
  playSilence 200
}

# altimeter
proc altimeter {value} {
  playMsg "altimeter"
  playSilence 100
  speakNumber $value "unit_inch"
  playSilence 200
}

# clouds with arguments
proc clouds {obs height {cbs ""}} {
  playMsg $obs
  playSilence 100
  speakNumber $height "unit_feet"
  if {[string length $cbs] > 0} {
    playMsg $cbs
  }
  playSilence 200
}

# max day temperature
proc max_daytemp {deg time} {
  playMsg "predicted"
  playSilence 50
  playMsg "maximal"
  playSilence 50
  playMsg "daytime_temperature"
  playSilence 150
  speakNumber $deg "unit_degree"
  playSilence 150
  playMsg "at"
  playSilence 50
  set hr [string range $time 0 1]
  set mn [string range $time 2 3]
  playTime $hr $mn
  playSilence 200
}

# min day temperature
proc min_daytemp {deg time} {
  playMsg "predicted"
  playSilence 50
  playMsg "minimal"
  playSilence 50
  playMsg "daytime_temperature"
  playSilence 150
  speakNumber $deg "unit_degree"
  playSilence 150
  playMsg "at"
  playSilence 50
  set hr [string range $time 0 1]
  set mn [string range $time 2 3]
  playTime $hr $mn
  playSilence 200
}

# Maximum temperature in RMK section
proc rmk_maxtemp {val} {
  playMsg "maximal"
  playMsg "temperature"
  playMsg "last"
  speakNumber 6 "hour"
  playSilence 50
  speakNumber $val "unit_degree"
  playSilence 200
}

# Minimum temperature in RMK section
proc rmk_mintemp {val} {
  playMsg "minimal"
  playMsg "temperature"
  playMsg "last"
  speakNumber 6 "hour"
  playSilence 50
  speakNumber $val "unit_degree"
  playSilence 200
}

# RMK section pressure trend next 3 h
proc rmk_pressure {val args} {
  playMsg "pressure"
  playMsg "tendency"
  playMsg "next"
  speakNumber 3 "hour"
  playSilence 50
  speakNumber $val "unit_mb"
  playSilence 200
  foreach item $args {
     if [regexp {(\d+)} $item] {
       playNumber $item
     } else {
       playMsg $item
     }
     playSilence 100
  }
  playSilence 200
}

# precipitation last hours in RMK section
proc rmk_precipitation {hour val} {
  playMsg "precipitation"
  playMsg "last"
  speakNumber $hour "hour"
  playSilence 50
  speakNumber $val "unit_inch"
  playSilence 200
}

# precipitations in RMK section
proc rmk_precip {args} {
  foreach item $args {
     if [regexp {(\d+)} $item] {
       playNumber $item
     } else {
       playMsg $item
     }
     playSilence 100
  }
  playSilence 200
}

# daytime minimal/maximal temperature
proc rmk_minmaxtemp {max min} {
  playMsg "daytime"
  playMsg "temperature"
  playMsg "maximum"
  speakNumber $min "unit_degree"
  playMsg "minimum"
  speakNumber $max "unit_degree"
  playSilence 200
}

# recent temperature and dewpoint in RMK section
proc rmk_tempdew {temp dewpt} {
  playMsg "re"
  playMsg "temperature"
  speakNumber $temp "unit_degree"
  playSilence 200
  playMsg "dewpoint"
  speakNumber $dewpt "unit_degree"
  playSilence 200
}

# QFE value
proc qfe {val} {
  playMsg "qfe"
  speakNumber $val "unit_hPa"
  playSilence 200
}


}