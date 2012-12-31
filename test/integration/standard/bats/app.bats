#!/usr/bin/env bats

user="vagrant"
app_path="/home/$user/app"

@test "app directory exists" {
  [ -d "$app_path" ]
}

@test "app shared directory exists" {
  [ -d "$app_path/shared" ]
}
