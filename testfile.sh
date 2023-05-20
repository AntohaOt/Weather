#!/bin/bash

file1="weather.json"
file2="city.json"

./weather.sh Sochi

if [[ ! -e $file1 || ! -e $file2 ]]
then
    rm $file1 $file2
    exit 1
else
    rm $file1 $file2
    exit 0
fi