#
# Cookbook Name:: liferay
# Recipe:: enterprise
#
# Copyright 2013, Thirdwave, LLC
# Authors:
# 		Adam Krone <adam.krone@thirdwavellc.com>
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

include_recipe "liferay"

ruby_block "install-patches" do
	block do
		patch_list = data_bag_item("liferay-ee-patches", node['liferay']['ee']['	patches']['version'])
	
		patch_list['patches'].each do |patch|
			Chef::Log.info("Installing patch: #{patch}")
		end
	end
	action :nothing
end

directory "#{node['liferay']['install_directory']}/liferay/deploy" do
	action :create
end

remote_file "#{node['liferay']['install_directory']}/liferay/deploy/#{node['liferay']['ee']['license_filename']}" do
	source node['liferay']['ee']['license_url']
	mode 00755
	action :create_if_missing
	notifies :create, resources(:ruby_block => "install-patches"), :immediately
end