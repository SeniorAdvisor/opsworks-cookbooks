# setup Torquebox service per app
node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping torquebox::rails application #{application} as it is not an Rails app")
    next
  end

  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  template "#{deploy[:deploy_to]}/shared/scripts/torquebox" do
    mode '0755'
    owner deploy[:user]
    group deploy[:group]
    source "torquebox.service.erb"
    variables(:deploy => deploy, :application => application)
  end

  service "torquebox_#{application}" do
    start_command "#{deploy[:deploy_to]}/shared/scripts/torquebox start &"
    stop_command "#{deploy[:deploy_to]}/shared/scripts/torquebox stop"
    restart_command "#{deploy[:deploy_to]}/shared/scripts/torquebox restart &"
    status_command "#{deploy[:deploy_to]}/shared/scripts/torquebox status"
    action :nothing
  end
end
