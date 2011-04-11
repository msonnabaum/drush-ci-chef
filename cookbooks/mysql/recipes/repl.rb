#
# Cookbook Name:: mysql
# Recipe:: repl
#
#
case node[:platform]
when "debian","ubuntu"
  template "/etc/mysql/conf.d/repl.cnf" do
    source "repl.cnf.erb"
    owner "root"
    group "root"
    mode "0600"
  end
end
