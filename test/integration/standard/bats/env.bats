#!/usr/bin/env bats

user="vagrant"
env_file="/home/$user/.env"

@test "$env_file is sourced for user $user" {
  su $user -lc "echo 'FROM_BATS=1' > $env_file"
  [ -n "$(su $user -lc 'echo \$FROM_BATS')" ]
}
