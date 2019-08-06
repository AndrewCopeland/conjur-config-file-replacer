#!/bin/bash

template_file_path=$1
conf_file_path=$2
tmp_file="$conf_file_path.tmp"

function validate_correct_args() {
  # Check correct number of arguments
  if [ $1 -ne 2 ]; then
    echo "Error invalid parameters"
    echo "usage: create_config_file.sh path/to/template.xml path/to/config.xml"
    exit 1
  fi
}

function validate_template_path() {
  # Validate template conf file
  if [ ! -f "$template_file_path" ]; then
    echo "Template configuration file '$1' not found"
    exit 2
  fi
}

function validate_conf_path() {
  # Validate conf file
  if touch "$conf_file_path"; then
    rm $conf_file_path
  else
    echo "Invalid configuration file path '$2'"
    exit 3
  fi
}

function create_tmp_file() {
  # cp template to final location
  cp $template_file_path $tmp_file
  echo "Copying $template_file_path => $tmp_file"
}

function create_conf_file_and_remove_tmp_file() {
  echo "Copying $tmp_file => $conf_file_path"
  cp $tmp_file $conf_file_path
  echo "Removing $tmp_file"
  rm $tmp_file
}

function main() {
  # Validate arguments
  validate_correct_args $1
  validate_template_path
  validate_conf_path

  create_tmp_file

  # replace variables within the tmp file
  summon -p ./summon-aws.rb bash ./replace_from_env_vars.sh "$tmp_file"

  create_conf_file_and_remove_tmp_file
}

main $#




