require_recipe "orch_app"

node['orch_app']['apps'].each do |app|
  user = app.fetch('user')

  directory "/home/#{user}/app/current" do
    owner     user
    group     user
    mode      "2755"
  end

  cookbook_file "/home/#{user}/app/current/server.rb" do
    source "server.rb"
    mode   "0644"
    owner  user
    group  user
  end

  cookbook_file "/home/#{user}/app/current/Procfile" do
    source "Procfile"
    mode   "0644"
    owner  user
    group  user
  end
end
