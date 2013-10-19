#!/bin/bash
rrdtool create multi_temperature.rrd --step 300 \
DS:module_temp:GAUGE:600:-67:257 \
DS:ambient_temp:GAUGE:600:-67:257 \
RRA:AVERAGE:0.5:1:12 \
RRA:AVERAGE:0.5:1:288 \
RRA:AVERAGE:0.5:12:168 \
RRA:AVERAGE:0.5:12:720 \
RRA:AVERAGE:0.5:288:365
