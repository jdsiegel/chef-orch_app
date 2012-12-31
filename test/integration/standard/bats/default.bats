#!/usr/bin/env bats

user="vagrant"
version="1.9.3"
patchlevel="p327"

@test "chruby is installed and sourced for user $user" {
  [ "$(su $user -lc 'chruby -h')" = "usage: chruby [RUBY|VERSION|system] [RUBY_OPTS]" ]
}

@test "chruby reports the correct list of rubies" {
  [ "$(su $user -lc 'chruby')" = " * $version-$patchlevel" ]
}

@test "chruby sets up ruby $version for user $user" {
  [[ "$(su $user -lc 'ruby -v')" =~ "ruby $version$patchlevel" ]]
}
