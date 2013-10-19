#!/bin/bash
#from:http://stackoverflow.com/questions/11353289/rrdtool-gprint-formatting-with-printf
#Returns unix time in seconds:
now=$(date +%s)
#
now_formatted=$(date +%s | awk '{printf "%s\n", strftime("%c",$1)}' | sed -e 's/:/\\:/g')

RRDPATH="/home/zrr/solar_monitor/src/temperature"
#blue:
RAWCOLOUR="#0000FF"
#cyan:
RAWCOLOUR2="#00FFFF"
#lime green:
TRENDCOLOUR="#13f804"
#yellow:
TRENDCOLOUR2="#fbff00"
#black:
BGCOLOR="#000000"
CANVASCOLOR=$BGCOLOR
#white:
FONTCOLOR="#FFFFFF"
#top and left border 
TLCOLOR="#FFFFFF"
#bottom and right border 
BRCOLOR="#FFFFFF"
GRIDCOLOR="#808080"
MGRIDCOLOR="#808080"
AXISCOLOR="#FFFFFF"
FRAMECOLOR="#C0C0C0"
ARROWCOLOR="#FFFFFF"

#hour
rrdtool graph $RRDPATH/hour.png --start -6h \
--width 543 --height 267 --slope-mode \
--alt-autoscale \
--alt-y-grid --units-length 2 \
--title "Hourly DS182[0,2] Temperature" \
--vertical-label "Degrees Fahrenheit" \
--color BACK$BGCOLOR \
--color CANVAS$CANVASCOLOR \
--color FONT$FONTCOLOR \
--color SHADEA$TLCOLOR \
--color SHADEB$BRCOLOR \
--color GRID$GRIDCOLOR \
--color MGRID$MGRIDCOLOR \
--color AXIS$AXISCOLOR \
--color FRAME$FRAMECOLOR \
--color ARROW$ARROWCOLOR \
DEF:moduletemp=$RRDPATH/multi_temperature.rrd:module_temp:AVERAGE \
DEF:ambienttemp=$RRDPATH/multi_temperature.rrd:ambient_temp:AVERAGE \
VDEF:last_moduletemp=moduletemp,LAST \
VDEF:last_ambienttemp=ambienttemp,LAST \
VDEF:min_moduletemp=moduletemp,MINIMUM \
VDEF:min_ambienttemp=ambienttemp,MINIMUM \
VDEF:max_moduletemp=moduletemp,MAXIMUM \
VDEF:max_ambienttemp=ambienttemp,MAXIMUM \
VDEF:avg_moduletemp=moduletemp,AVERAGE \
VDEF:avg_ambienttemp=ambienttemp,AVERAGE \
CDEF:moduletrend=moduletemp,1800,TREND \
CDEF:ambienttrend=ambienttemp,1800,TREND \
LINE1:moduletemp$RAWCOLOUR:"Module Temperature" \
LINE1:ambienttemp$RAWCOLOUR2:"Ambient Temperature\\n\\t" \
HRULE:min_moduletemp#58FAF4:"Min\: " \
GPRINT:min_moduletemp:"%6.2lf%sF\\t\\t" \
HRULE:min_ambienttemp#ff007d:"Min\: " \
GPRINT:min_ambienttemp:"%6.2lf%sF" \
HRULE:max_moduletemp#FFFFFF:"Max\: " \
GPRINT:max_moduletemp:"%6.2lf%sF" \
HRULE:max_ambienttemp#726255:"Max\: " \
GPRINT:max_ambienttemp:"%6.2lf%sF" \
HRULE:last_moduletemp#CC0063:"Last\: " \
GPRINT:last_moduletemp:"%6.2lf%sF" \
HRULE:last_ambienttemp#b95555:"Last\: " \
GPRINT:last_ambienttemp:"%6.2lf%sf" \
HRULE:avg_moduletemp#e8702a:"Avg\: " \
GPRINT:avg_moduletemp:"%6.2lf%sF" \
HRULE:avg_ambienttemp#b95555:"Avg\: " \
GPRINT:avg_ambienttemp:"%6.2lf%sF" \
LINE2:moduletrend$TRENDCOLOUR:"30 min Module Average" \
LINE2:ambienttrend$TRENDCOLOUR2:"30 min Ambient Average" \
#GPRINT:max_temp:MAX:"Max\: %2.11f F" \
#GPRINT:min_temp:MIN:"Min\: %2.11f F\j" \
#GPRINT:last_temp:LAST:"Last\: %2.11f F" \
#GPRINT:avg_temp:AVERAGE:"Average\: %2.11f F\j"

#day
rrdtool graph $RRDPATH/day.png --start -1d \
--width 543 --height 267 --slope-mode \
--alt-autoscale-max \
--title "Daily DS182[]{0,2} Temperature" \
--vertical-label "Deg. F"  \
--color BACK$BGCOLOR \
--color CANVAS$CANVASCOLOR \
--color FONT$FONTCOLOR \
--color SHADEA$TLCOLOR \
--color SHADEB$BRCOLOR \
--color GRID$GRIDCOLOR \
--color MGRID$MGRIDCOLOR \
--color AXIS$AXISCOLOR \
--color FRAME$FRAMECOLOR \
--color ARROW$ARROWCOLOR \
DEF:moduletemp=$RRDPATH/multi_temperature.rrd:module_temp:AVERAGE \
DEF:ambienttemp=$RRDPATH/multi_temperature.rrd:ambient_temp:AVERAGE \
CDEF:moduletrend=moduletemp,21600,TREND \
CDEF:ambienttrend=ambienttemp,21600,TREND \
LINE2:moduletemp$RAWCOLOUR:"Module Temperature" \
LINE1:moduletrend$TRENDCOLOUR:"6h Module Average" \
LINE2:ambienttemp$RAWCOLOUR2:"Ambient Temperature" \
LINE1:ambienttrend$TRENDCOLOUR2:"6h Ambient Average" \
VDEF:last_moduletemp=moduletemp,LAST \
VDEF:last_ambienttemp=ambienttemp,LAST \
VDEF:min_moduletemp=moduletemp,MINIMUM \
VDEF:min_ambienttemp=ambienttemp,MINIMUM \
VDEF:max_moduletemp=moduletemp,MAXIMUM \
VDEF:max_ambienttemp=ambienttemp,MAXIMUM \
VDEF:avg_moduletemp=moduletemp,AVERAGE \
VDEF:avg_ambienttemp=ambienttemp,AVERAGE 
#GPRINT:max_temp:MAX:"Max\: %2.11f F" \
#GPRINT:min_temp:MIN:"Min\: %2.11f F\j" \
#GPRINT:last_temp:LAST:"Last\: %2.11f F" \
#GPRINT:avg_temp:AVERAGE:"Average\: %2.11f F\j"

#week
rrdtool graph $RRDPATH/week.png --start -1w \
--width 543 --height 267 --slope-mode \
--alt-autoscale-max \
--title "Weekly DS182[]{0,2} Temperature" \
--vertical-label "Deg. F" --lower-limit=0 \
--color BACK$BGCOLOR \
--color CANVAS$CANVASCOLOR \
--color FONT$FONTCOLOR \
--color SHADEA$TLCOLOR \
--color SHADEB$BRCOLOR \
--color GRID$GRIDCOLOR \
--color MGRID$MGRIDCOLOR \
--color AXIS$AXISCOLOR \
--color FRAME$FRAMECOLOR \
--color ARROW$ARROWCOLOR \
DEF:moduletemp=$RRDPATH/multi_temperature.rrd:module_temp:AVERAGE \
DEF:ambienttemp=$RRDPATH/multi_temperature.rrd:ambient_temp:AVERAGE \
CDEF:moduletrend=moduletemp,43200,TREND \
CDEF:ambienttrend=ambienttemp,43200,TREND \
LINE2:moduletemp$RAWCOLOUR:"Module Temperature" \
LINE1:moduletrend$TRENDCOLOUR:"12h Module Average" \
LINE2:ambienttemp$RAWCOLOUR2:"Ambient Temperature" \
LINE1:ambienttrend$TRENDCOLOUR2:"12h Ambient Average" \
VDEF:last_moduletemp=moduletemp,LAST \
VDEF:last_ambienttemp=ambienttemp,LAST \
VDEF:min_moduletemp=moduletemp,MINIMUM \
VDEF:min_ambienttemp=ambienttemp,MINIMUM \
VDEF:max_moduletemp=moduletemp,MAXIMUM \
VDEF:max_ambienttemp=ambienttemp,MAXIMUM \
VDEF:avg_moduletemp=moduletemp,AVERAGE \
VDEF:avg_ambienttemp=ambienttemp,AVERAGE 
#GPRINT:max_temp:MAX:"Max\: %2.11f F" \
#GPRINT:min_temp:MIN:"Min\: %2.11f F\j" \
#GPRINT:last_temp:LAST:"Last\: %2.11f F" \
#GPRINT:avg_temp:AVERAGE:"Average\: %2.11f F\j"

#month
rrdtool graph $RRDPATH/month.png --start -1month \
--width 543 --height 267 --slope-mode \
--alt-autoscale-max \
--title "Monthly DS182[]{0,2} Temperature" \
--vertical-label "Deg. F" --lower-limit=0 \
--color BACK$BGCOLOR \
--color CANVAS$CANVASCOLOR \
--color FONT$FONTCOLOR \
--color SHADEA$TLCOLOR \
--color SHADEB$BRCOLOR \
--color GRID$GRIDCOLOR \
--color MGRID$MGRIDCOLOR \
--color AXIS$AXISCOLOR \
--color FRAME$FRAMECOLOR \
--color ARROW$ARROWCOLOR \
DEF:moduletemp=$RRDPATH/multi_temperature.rrd:module_temp:AVERAGE \
DEF:ambienttemp=$RRDPATH/multi_temperature.rrd:ambient_temp:AVERAGE \
CDEF:moduletrend=moduletemp,86400,TREND \
CDEF:ambienttrend=ambienttemp,86400,TREND \
LINE2:moduletemp$RAWCOLOUR:"Module Temperature" \
LINE1:moduletrend$TRENDCOLOUR:"24h Module Average" \
LINE2:ambienttemp$RAWCOLOUR2:"Ambient Temperature" \
LINE1:ambienttrend$TRENDCOLOUR2:"24h Ambient Average" \
VDEF:last_moduletemp=moduletemp,LAST \
VDEF:last_ambienttemp=ambienttemp,LAST \
VDEF:min_moduletemp=moduletemp,MINIMUM \
VDEF:min_ambienttemp=ambienttemp,MINIMUM \
VDEF:max_moduletemp=moduletemp,MAXIMUM \
VDEF:max_ambienttemp=ambienttemp,MAXIMUM \
VDEF:avg_moduletemp=moduletemp,AVERAGE \
VDEF:avg_ambienttemp=ambienttemp,AVERAGE 
#GPRINT:max_temp:MAX:"Max\: %2.11f F" \
#GPRINT:min_temp:MIN:"Min\: %2.11f F\j" \
#GPRINT:last_temp:LAST:"Last\: %2.11f F" \
#GPRINT:avg_temp:AVERAGE:"Average\: %2.11f F\j"

#year
rrdtool graph $RRDPATH/year.png --start -1year \
--width 543 --height 267 --slope-mode \
--alt-autoscale-max \
--title "Yearly DS182[]{0,2} Temperature" \
--vertical-label "Deg. F" --lower-limit=0 \
--color BACK$BGCOLOR \
--color CANVAS$CANVASCOLOR \
--color FONT$FONTCOLOR \
--color SHADEA$TLCOLOR \
--color SHADEB$BRCOLOR \
--color GRID$GRIDCOLOR \
--color MGRID$MGRIDCOLOR \
--color AXIS$AXISCOLOR \
--color FRAME$FRAMECOLOR \
--color ARROW$ARROWCOLOR \
DEF:moduletemp=$RRDPATH/multi_temperature.rrd:module_temp:AVERAGE \
DEF:ambienttemp=$RRDPATH/multi_temperature.rrd:ambient_temp:AVERAGE \
CDEF:moduletrend=moduletemp,2600640,TREND \
CDEF:ambienttrend=ambienttemp,2600640,TREND \
LINE2:moduletemp$RAWCOLOUR:"Module Temperature" \
LINE1:moduletrend$TRENDCOLOUR:"4 Week Module Average" \
LINE2:ambienttemp$RAWCOLOUR2:"Ambient Temperature" \
LINE1:ambienttrend$TRENDCOLOUR2:"4 Week Average Ambient Average" \
VDEF:last_moduletemp=moduletemp,LAST \
VDEF:last_ambienttemp=ambienttemp,LAST \
VDEF:min_moduletemp=moduletemp,MINIMUM \
VDEF:min_ambienttemp=ambienttemp,MINIMUM \
VDEF:max_moduletemp=moduletemp,MAXIMUM \
VDEF:max_ambienttemp=ambienttemp,MAXIMUM \
VDEF:avg_moduletemp=moduletemp,AVERAGE \
VDEF:avg_ambienttemp=ambienttemp,AVERAGE 
#GPRINT:max_temp:MAX:"Max\: %2.11f F" \
#GPRINT:min_temp:MIN:"Min\: %2.11f F\j" \
#GPRINT:last_temp:LAST:"Last\: %2.11f F" \
#GPRINT:avg_temp:AVERAGE:"Average\: %2.11f F\j"
