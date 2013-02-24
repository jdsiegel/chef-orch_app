#!/usr/bin/env bats

user="vagrant"

test_env_is_sourced_for_user()
{
  local output=$(su $user -lc 'echo $RAILS_ENV')
  assertEquals "env was not set" "production" "$output"
}
