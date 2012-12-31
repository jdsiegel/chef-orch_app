#!/usr/bin/env bats

user="vagrant"
available_path="/home/$user/services-available"
enabled_path="/home/$user/services-enabled"

@test "$available_path directory exists" {
  [ -d "$available_path" ]
}

@test "$enabled_path directory exists" {
  [ -d "$enabled_path" ]
}

@test "runsvdir service is running for user $user" {
  pgrep -u $user -f "runsvdir -P $enabled_path"
}
