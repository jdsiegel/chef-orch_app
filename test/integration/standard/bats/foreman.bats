#!/usr/bin/env bats

user="vagrant"
template_path="/home/$user/.foreman/templates"
bin_path="/home/$user/bin"

@test "$template_path directory exists" {
  [ -d "$template_path" ]
}

@test "run template exists" {
  [ -f "$template_path/run.erb" ]
}

@test "log/run template exists" {
  [ -f "$template_path/log/run.erb" ]
}

@test "app-services script exists" {
  [ -x "$bin_path/app-services" ]
}

@test "app-services generates runit services from Procfile" {
  run su vagrant -lc "app-services"
  sleep 5
  pgrep -u $user -f "ruby server.rb"
  run curl -s http://localhost:8000
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "dummy app is running" ]
}
