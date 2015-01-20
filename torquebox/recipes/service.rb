service "torquebox" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end
