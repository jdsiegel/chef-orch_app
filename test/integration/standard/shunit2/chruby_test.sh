#!/bin/bash

user="vagrant"
version="1.9.3"
patchlevel="p392"

test_chruby_installed_and_sourced_for_user()
{
  local help_msg=$(su $user -lc 'chruby -h')
  assertEquals "usage: chruby [RUBY|VERSION|system] [RUBY_OPTS]" "$help_msg"
}

test_chruby_reports_the_correct_list_of_rubies()
{
  local ruby_list=$(su $user -lc 'chruby')
  assertEquals " * $version-$patchlevel" "$ruby_list"
}

test_chruby_sets_up_ruby_for_user()
{
  local ruby_version=$(su $user -lc 'ruby -v')
  local expected="ruby $version$patchlevel"
  if ! [[ "$ruby_version" =~ "$expected" ]]; then
    failNotEquals "substring not found" "$expected" "$ruby_version"
  fi
}
