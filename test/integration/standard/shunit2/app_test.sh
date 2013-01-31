#!/bin/bash

user="vagrant"
app_path="/home/$user/app"

test_app_directory_exists()
{
  assertTrue "$app_path is missing" "[ -d '$app_path' ]"
}

test_app_shared_directory_exists()
{
  assertTrue "$app_path/shared is missing" "[ -d '$app_path/shared' ]"
}
