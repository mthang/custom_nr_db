#!/bin/bash

cat nr | perl -e 'BEGIN{ $/ = ">"; <>; } while(<>){s/>$//;  $i = index $_, "]\n"; $h = substr($_, 0, $i)."]"; $s = substr $_, $i+2; while($h =~ /(.+?) \[(.+?)\]/g){ print ">$1 [$2]\n$s";} } ' | sed 's/\x01//g' >> nr.fa
