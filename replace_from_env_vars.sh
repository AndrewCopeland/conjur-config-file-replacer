#!/bin/bash

# Store environment variables as dictionary
tmp_file=$1
declare -A env_vars
IFS=$'\n'
for env_var in $(env); do
    key=$(echo "$env_var" | cut -d '=' -f 1)
    value=$(echo "$env_var" | cut -d '=' -f 2-)
    env_vars[$key]=$value
done

# replace env value placeholders in tmp file
for line in $(cat ./secrets.yml | grep ": !var"); do
    key=$(echo $line | awk -F ": !var " '{print $1}')
    placeholder="{{ $key }}"
    value=${env_vars[$key]}
    if [ "$value" != "" ]; then
        echo "Replacing $key"
        sed -i "s/$placeholder/$value/g" $tmp_file
    fi
done
unset IFS