#!/bin/bash

file1="weather.json"
file2="city.json"
city=Sochi

./weather.sh $city > test

if ! grep -i -q $city test
then
    rm $file1 $file2
    exit 1
else 
    rm $file1 $file2
    exit 0
fi