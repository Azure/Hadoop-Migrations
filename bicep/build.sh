#!/bin/sh

if [ ! -d "./build" ] 
then
  mkdir build
fi

#fi=`find . -name '*.bicep' -print`
fi=`ls main/*.bicep`
for ef in $fi
do
  echo "Building >> "$ef
  bicep build $ef --outdir build
done

cp main/*.parameters.json build
cp main/metadata.json build