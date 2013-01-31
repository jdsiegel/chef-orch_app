#!/usr/bin/env bats

user="vagrant"
env_file="/home/$user/.env"

test_env_is_sourced_for_user()
{
  su $user -lc "echo 'FROM_TEST=working' > $env_file"

  local output=$(su $user -lc 'echo $FROM_TEST')
  assertEquals "env was not set" "working" "$output"
}
