###
# Do not use this file to override the opsworks_bundler cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_bundler/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_bundler/attributes/bundler.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

default[:opsworks_bundler][:version] = '1.5.3'
if node['opsworks_jruby'] && node['opsworks_jruby']['jruby_path']
  default[:opsworks_bundler][:executable] = "#{node['opsworks_jruby']['jruby_path']}/bundle"
else
  default[:opsworks_bundler][:executable] = '/usr/local/bin/bundle'
end

include_attribute "opsworks_bundler::customize"
