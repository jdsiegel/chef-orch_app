#!/bin/bash

user="vagrant"
template_path="/home/$user/.foreman/templates"
bin_path="/home/$user/bin"

test_template_directory_exists()
{
  assertTrue "$template_path not found" "[ -d '$template_path' ]"
}

test_run_template_exists()
{
  assertTrue "$template_path/run.erb not found" "[ -f '$template_path/run.erb' ]"
}

test_log_run_template_exists()
{
  assertTrue "$template_path/log/run.erb not found" "[ -f '$template_path/log/run.erb' ]"
}

test_app_services_script_exists()
{
  assertTrue "$bin_path/app-services" "[ -x '$bin_path/app-services' ]"
}

test_app_services_generates_runit_services_from_procfile()
{
  su vagrant -lc "app-services" > /dev/null
  sleep 5
  pgrep -u $user -f "ruby server.rb" > /dev/null

  local output=$(curl -s http://localhost:8000)

  assertTrue "curl not successful" $?
  assertEquals "dummy app is running" "$output"
}
