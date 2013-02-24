module OrchApp
  def configure_chruby
    version       = node['orch_app']['chruby']['version']
    url           = node['orch_app']['chruby'].fetch('url') do
                      "https://github.com/postmodern/chruby/archive/v#{version}.tar.gz"
                    end
    checksum      = node['orch_app']['chruby']['checksum']
    force_install = node['orch_app']['chruby']['force_install']

    cache_path = Chef::Config['file_cache_path'] || '/tmp'
    dir_name   = "chruby-#{version}"
    tar_file   = "v#{version}.tar.gz"
    full_path  = "#{cache_path}/#{tar_file}"

    remote_file full_path do
      source   url
      checksum checksum
      backup   false
    end

    bash "install_chruby" do
      cwd cache_path
      code <<-EOH
        tar xzf #{tar_file}
        cd #{dir_name}
        make install
      EOH

      not_if do
        ::File.exists?("/usr/local/share/chruby/chruby.sh") && !force_install
      end
    end

    cookbook_file "/etc/profile.d/chruby.sh" do
      source "chruby.sh"
      mode   "0644"
      owner  "root"
      group  "root"
    end
  end

  def configure_ruby(app)
    user            = app.fetch('user')
    home            = home_for(app)
    version         = app.fetch('ruby_version')
    bundler_version = app.fetch('bundler_version') { node['orch_app']['bundler']['version'] }
    install_path    = "#{node['orch_app']['rubies_path']}/#{version}"

    include_recipe "ruby_build"
    ruby_build_ruby version do
      prefix_path install_path
    end

    gem_package "bundler" do
      version    bundler_version
      gem_binary "#{install_path}/bin/gem"
    end

    file "#{home}/.ruby-version" do
      owner   user
      group   user
      mode    "0644"
      content version
    end
  end

  def configure_env
    cookbook_file "/etc/profile.d/app_env.sh" do
      source "app_env.sh"
      mode   "0644"
      owner  "root"
      group  "root"
    end
  end

  def configure_runit(app)
    include_recipe "runit"

    user         = app.fetch('user')
    home         = home_for(app)
    runit        = app.fetch('runit')          { {} }

    service_path = runit.fetch('service_path') { "#{home}/services-enabled" }
    sv_path      = runit.fetch('sv_path')      { "#{home}/services-available" }
    log_path     = runit.fetch('log_path')     { "/var/log/runsvdir-#{user}" }

    directory service_path do
      owner     user
      group     user
      mode      "2755"
      recursive true
    end

    directory sv_path do
      owner     user
      group     user
      mode      "2755"
      recursive true
    end

    directory log_path do
      owner     "root"
      group     "root"
      mode      "755"
      recursive true
    end

    runit_service "runsvdir-#{user}" do
      template_name "user"
      options       :user => user, :service_path => service_path, :log_path => log_path
    end
  end

  def configure_foreman(app)
    user = app.fetch('user')
    home = home_for(app)

    gem_package "foreman"

    directories = %W(
      #{home}/.foreman
      #{home}/.foreman/templates
      #{home}/.foreman/templates/log
    )

    directories.each do |dir|
      directory dir do
        owner     user
        group     user
        mode      "2755"
        recursive true
      end
    end

    cookbook_file "#{home}/.foreman/templates/run.erb" do
      source "foreman/run.erb"
      owner  user
      group  user
      mode   "0644"
    end

    cookbook_file "#{home}/.foreman/templates/log/run.erb" do
      source "foreman/log.erb"
      owner  user
      group  user
      mode   "0644"
    end

    directory "#{home}/bin" do
      owner user
      group user
      mode  "755"
    end

    processes = app.fetch('processes') { [] }
    processes = [['all', 0]] if !processes || processes.empty?

    template "#{home}/bin/app-services" do
      source    "app-services.sh.erb"
      owner     user
      group     user
      mode      "0755"
      variables :ruby_path => ::File.dirname(RbConfig::CONFIG['bindir']),
                :user      => user,
                :home      => home,
                :processes => processes.map { |name,count| "#{name}=#{count}" }.join(",")

      notifies :run, "execute[app-services]"
    end

    execute "app-services" do
      command "#{home}/bin/app-services"
      user    user
      action  :nothing
    end
  end

  def configure_app_path(app)
    user = app.fetch('user')
    name = app.fetch('name')
    home = home_for(app)

    directories = %W(
      #{home}/app
      #{home}/app/shared
      #{home}/app/shared/log
    )

    directories.each do |dir|
      directory dir do
        owner     user
        group     user
        mode      "2755"
        recursive true
      end
    end

    link "#{home}/#{name}" do
      to "#{home}/app"
    end
  end

  def configure_app_env(app)
    home = home_for(app)
    env = app.fetch('environment') { [] }

    template "#{home}/.env" do
      source "env.erb"
      owner  user
      group  user
      mode   "0644"
      variables :environment => env

      notifies :run, "execute[app-services]"
    end
  end

  def home_for(app)
    user = app.fetch('user')
    "/home/#{user}"
  end
end
