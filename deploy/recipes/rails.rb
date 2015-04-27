include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails application #{application} as it is not a Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  file "/etc/profile.d/#{application}.sh" do
    content deploy[:environment_variables].collect{|k,v|"export #{k}=#{v}"}.join("\n")
    mode 0755
    only_if { deploy[:export_environment_variables] && deploy[:environment_variables].is_a?(::Hash)}
  end

  opsworks_rails do
    deploy_data deploy
    app application
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  execute "run whenever" do
    user deploy[:user]
    group deploy[:group]
    if deploy[:application_type] == 'rails' && deploy[:whenever]
      if node['opsworks'] && node['opsworks']['jruby_path'] && File.exist?('/etc/profile.d/jruby.sh')
        command(". /etc/profile.d/jruby.sh; cd #{deploy[:current_path]} && #{deploy[:bundle]} exec whenever -i #{application} 2>&1")
      else
        command("cd #{deploy[:current_path]} && #{deploy[:bundle]} exec whenever -i #{application} 2>&1")
      end
    end
  end

  #execute "run foreman" do
    #user deploy[:user]
    #group deploy[:group]
    #if deploy[:application_type] == 'rails' && deploy[:foreman]
      #if node['opsworks'] && node['opsworks']['jruby_path'] && File.exist?('/etc/profile.d/jruby.sh')
        #command(". /etc/profile.d/jruby.sh; cd #{deploy[:current_path]} && #{deploy[:bundle]} exec foreman start")
      #else
        #command("cd #{deploy[:current_path]} && #{deploy[:bundle]} exec foreman start")
      #end
    #end
  #end
end
