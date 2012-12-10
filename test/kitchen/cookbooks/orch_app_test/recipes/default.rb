extend OrchAppTest

node['orch_app']['apps'] = [
  {
    'name'         => 'app1',
    'user'         => 'vagrant',
    'ruby_version' => '1.9.3-p327',
    'processes'    => [['all', '1']],
  },
  #{
    #'name'         => 'app2',
    #'user'         => 'vagrant',
    #'ruby_version' => '1.8.7-p370'
  #},
]

require_recipe "orch_app"
