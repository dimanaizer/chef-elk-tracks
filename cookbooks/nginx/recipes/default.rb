#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

execute 'update apt metadata' do
  command 'apt-get update'
end

package 'install nginx' do
  package_name 'nginx'
  action :install
end

directory '/etc/nginx' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/nginx/mime.types' do
  source 'mime.types'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service "nginx" do
  action [ :enable, :restart ]
end
