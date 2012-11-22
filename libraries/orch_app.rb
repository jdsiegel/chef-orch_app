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

  def install_chruby
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
end
