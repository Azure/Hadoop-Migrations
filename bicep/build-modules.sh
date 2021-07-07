#!/bin/sh

if [ ! -d "./build" ] 
then
  mkdir build
fi

find modules -name '*.bicep' -print -exec bicep build {} \; 