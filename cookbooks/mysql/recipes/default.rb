#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'install mysql' do
  package_name 'mysql-server'
  action :install
end

service "start and enable mysql" do
  action :start
end
