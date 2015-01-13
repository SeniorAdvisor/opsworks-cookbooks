# stop Torquebox service per app
node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping torquebox::rails application #{application} as it is not an Rails app")
    next
  end

  execute "stop torquebox" do
    command "#{deploy[:deploy_to]}/shared/scripts/torquebox stop"
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/scripts/torquebox")
    end
  end
end
