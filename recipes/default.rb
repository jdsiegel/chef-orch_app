extend OrchApp

install_chruby

node['orch_app']['apps'].each do |app|
  configure_ruby(app)
end
