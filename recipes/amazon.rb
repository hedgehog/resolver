#
# Cookbook Name:: resolver
# Recipe:: aws
#
# Copyright 2011, Hedgehog.
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
#
# = Requires
# * node[:resolver][:nameservers]

package "resolvconf" do
  action :install
end

["base", "head", "tail"].each do |cfg|
  template "/etc/resolvconf/resolv.conf.d/#{cfg}" do
    source "#{cfg}.erb"
    owner "root"
    group "root"
    mode 0644
  end
end

template "/etc/resolvconf/interface-order" do
  source "interface-order.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[resolvconf]"
end

service "resolvconf" do
  action [ :enable, :start ]
end
