# Author:: Mark Sonnabaum <mark.sonnabaum@acquia.com>
# Cookbook Name:: ci-drush
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Force jenkins to refresh it's update info. Plugin installs will fail on initial installs without this.
#package "curl"
#execute "force-jenkins-updates-refresh" do
  #url = node[:jenkins][:server][:url]
  #command "curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- #{url}/updateCenter/byId/default/postBack"
#end

%w{hudson.plugins.git.GitSCM hudson.plugins.git.GitTool}.each do |config|
  template "#{node[:jenkins][:node][:home]}/#{config}" do
    source "#{config}.xml"
  end
end

#%w{git xunit}.each do |plugin|
#  jenkins_cli "install-plugin #{plugin}"
#end
#jenkins_cli "safe-restart"

%w{RunTests RunTests_Drush4 BuildDrush5Deb}.each do |job_name|
  job_config = "#{job_name}-config.xml"
  jenkins_job job_name do
    action :nothing
    config job_config
  end

  template job_config do
    source "#{job_name}-config.xml"
    #variables :job_name => job_name, :branch => git_branch, :node => node[:fqdn]
    notifies :update, resources(:jenkins_job => job_name), :immediately
    # notifies :build, resources(:jenkins_job => job_name), :immediately
  end
end
