module OrchApp
  def configure_ruby(app)
    user = app.fetch('user')
    version = app.fetch('ruby_version')

    include_recipe "ruby_build"
    ruby_build_ruby version

    file "/home/#{user}/.ruby-version" do
      owner user
      group user
      mode "0644"
      content version
    end
  end

  def configure_chruby
    version = node['orch_app']['chruby']['version']
    url = node['orch_app']['chruby'].fetch('url') do
      "https://github.com/downloads/postmodern/chruby/chruby-#{version}.tar.gz"
    end
    checksum = node['orch_app']['chruby']['checksum']
    force_install = node['orch_app']['chruby']['force_install']

    cache_path = Chef::Config['file_cache_path'] || '/tmp'
    dir_name = "chruby-#{version}"
    tar_file = "#{dir_name}.tar.gz"
    full_path = "#{cache_path}/#{tar_file}"

    remote_file full_path do
      source url
      checksum checksum
      backup false
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
    service_path = app.fetch('service_path') { "/home/#{user}/service" }
    log_path     = app.fetch('log_path') { "/var/log/runsvdir-#{user}" }

    directory service_path do
      owner       user
      group       user
      mode        "2755"
      recursive   true
    end

    directory log_path do
      owner       "root"
      group       "root"
      mode        "755"
      recursive   true
    end

    runit_service "runsvdir-#{user}" do
      template_name  "user"
      options        :user => user, :service_path => service_path, :log_path => log_path
    end
  end
end
