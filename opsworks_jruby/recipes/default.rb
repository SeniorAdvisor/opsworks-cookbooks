#
# Cookbook Name:: opsworks_jruby
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


jruby_url = node['opsworks_jruby']['jruby_url'] || "https://s3.amazonaws.com/jruby.org/downloads/#{node['opsworks_jruby']['version']}/jruby-bin-#{node['opsworks_jruby']['version']}.tar.gz"
src_filepath = "/tmp/jruby-#{node['opsworks_jruby']['version']}.tar.gz"
jruby_path = "#{node['opsworks_jruby']['home_base_dir']}/jruby-#{node['opsworks_jruby']['version']}/bin"
node.default['opsworks_jruby']['jruby_path'] = jruby_path

include_recipe "opsworks_java::setup"

directory node['opsworks_jruby']['home_base_dir'] do
  #owner 'root'
  #group 'root'
  mode 0755
  action :create
end

remote_file jruby_url do
  source    jruby_url
  path      src_filepath
  not_if do
    ::File.exists?("#{jruby_path}/jruby") && `#{jruby_path}/jruby -v`.to_s.strip.include?(" #{node['opsworks_jruby']['version']} ")
  end
end


execute "extract #{src_filepath} to #{node['opsworks_jruby']['home_base_dir']}/jruby-#{node['opsworks_jruby']['version']}" do
  only_if do
    ::File.exists?(src_filepath)
  end
  cwd  ::File.dirname(src_filepath)
  command "tar zxf #{::File.basename(src_filepath)} -C #{node['opsworks_jruby']['home_base_dir']}"
end

execute "Clean up" do
  command "rm -rf jruby-*"
  cwd "/tmp"
end
directory "/etc/profile.d" do
    mode 0755
end
file "/etc/profile.d/jruby.sh" do
  body = <<-CONTENT
export PATH=#{jruby_path}:$PATH
  CONTENT
  if node['opsworks_jruby']['RUBY_OPTS'].to_s.strip =~ /\w/
    body << "export RUBY_OPTS=#{node['opsworks_jruby']['RUBY_OPTS']}"
  end
  content body
  mode 0755
end
