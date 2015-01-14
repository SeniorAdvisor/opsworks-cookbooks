default['opsworks_jruby']['version'] = "1.7.10"
default['opsworks_jruby']['home_base_dir'] = "/usr/local"
default['opsworks_jruby']['JRUBY_OPTS'] = "--2.0"
default['opsworks_jruby']['jruby_path'] = "#{node['opsworks_jruby']['home_base_dir']}/jruby-#{node['opsworks_jruby']['version']}/bin"
