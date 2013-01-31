#!/usr/bin/env bats

user="vagrant"
available_path="/home/$user/services-available"
enabled_path="/home/$user/services-enabled"

test_available_directory_exists()
{
  assertTrue "$available_path not found" "[ -d '$available_path' ]"
}

test_enabled_directory_exists()
{
  assertTrue "$enabled_path not found" "[ -d '$enabled_path' ]"
}

test_runsvdir_is_running_for_user()
{
  pgrep -u $user -f "runsvdir -P $enabled_path" > /dev/null
  assertTrue "runsvdir process not found" $?
}
