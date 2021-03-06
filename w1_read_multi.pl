#!/usr/bin/perl
#from: http://webshed.org/wiki/RaspberryPI_Multiple_DS1820
use strict;
use warnings;

&check_modules;
&get_device_IDs;

my $in_correction = 0;
my $out_correction = 0;
my $count = 0;
my $reading = -1;
my $device = -1;
my @deviceIDs;
my @temp_readings;

foreach $device (@deviceIDs)
{
    $reading = &read_device($device);
    if ($reading == 9999) {
       $reading = "U";
    }
            
    push(@temp_readings,$reading);
          
}


if ($temp_readings[0] ne 'U') {$temp_readings[0] -= $in_correction;}
if ($temp_readings[1] ne 'U') {$temp_readings[1] -= $out_correction;}

#update the database
`/usr/bin/rrdtool update /home/zrr/solar_monitor/src/temperature/multi_temperature.rrd N:$temp_readings[0]:$temp_readings[1]`;
print "Temp 1 = $temp_readings[0]    Temp 2 = $temp_readings[1]\n";


sub check_modules
{
   my $mods = `cat /proc/modules`;
if ($mods =~ /w1_gpio/ && $mods =~ /w1_therm/)
{
 #print "w1 modules already loaded \n";
}
else 
{
print "loading w1 modules \n";
    `sudo modprobe w1-gpio`;
    `sudo modprobe w1-therm`;
} 
}


sub get_device_IDs
{
# The Hex IDs off all detected 1-wire devices on the bus are stored in the file
# "w1_master_slaves"    

# open file
open(FILE, "/sys/bus/w1/devices/w1_bus_master1/w1_master_slaves") or die("Unable to open file");
 
# read file into an array
 @deviceIDs = <FILE>;
 
 # close file 
 close(FILE);
}

sub read_device
{
    #takes one parameter - a device ID
    #returns the temperature if we have something like valid conditions
    #else we return "9999" for undefined

    my $deviceID = $_[0];
    $deviceID =~ s/\R//g;
 
    my $ret = 9999; # default to return 9999 (fail)
   
    my $sensordata = `cat /sys/bus/w1/devices/${deviceID}/w1_slave 2>&1`;
    print "Read: $sensordata";


   if(index($sensordata, 'YES') != -1) {
      #fix for negative temps from http://habrahabr.ru/post/163575/
      $sensordata =~ /t=(\D*\d+)/i;
      #$sensor_temp =~ /t=(\d+)/i;
      $sensordata = (($1/1000));
      #$ret = $sensordata; #return celsius 
	  $ret = (((9/5)*$sensordata)+32); #convert to fahrenheit
   } else {
      print ("CRC Invalid for device $deviceID.\n");
   }

   return ($ret);
}
