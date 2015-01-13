define :torquebox_web_app do
  deploy = params[:deploy]
  application = params[:application]
  execute "restart Torquebox app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end
end
