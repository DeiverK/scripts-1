#!/bin/bash

if [[ $(grep -i "name" complex_commands.list) ]] && [[ $(cat complex_commands.list | awk '{print $7}') -eq "-name" ]]
then 
    echo "Ok"
else
    echo "Not ok"
fi
