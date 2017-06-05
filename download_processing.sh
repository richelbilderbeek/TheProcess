#!/bin/bash
# Downloads and unpacks Processing

# Pick either 32 or 64 bit
#zipfile="processing-3.0.2-linux64.tgz"
zipfile="processing-3.3.4-linux32.tgz"

if [ ! -e $zipfile ]
then
  wget http://download.processing.org/$zipfile
fi 

tar zxvf $zipfile > /dev/null
