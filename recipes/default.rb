extend OrchApp

configure_chruby
configure_env

node['orch_app']['apps'].each do |app|
  configure_ruby(app)
  configure_runit(app)
  configure_foreman(app)
end
