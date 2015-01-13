###
# Do not use this file to override the torquebox cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "torquebox/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'torquebox/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'rails::rails'

default[:torquebox][:version] = '3.1.1'
default[:torquebox][:port] = '9292'
default[:torquebox][:bind] = '0.0.0.0'
default[:torquebox][:max_threads] = '15'
include_attribute "torquebox::customize"
