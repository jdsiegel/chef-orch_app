extend OrchAppTest

node['orch_app']['apps'] = [
  {
    'user'         => 'vagrant',
    'ruby_version' => '1.9.3-p327'
  },
  #{
    #'user'         => 'vagrant',
    #'ruby_version' => '1.8.7-p370'
  #},
]

require_recipe "orch_app"
