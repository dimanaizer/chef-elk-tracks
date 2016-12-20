#
# Cookbook Name:: elk
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file '/etc/apt/sources.list.d/java8.list' do
  source 'java8.list'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/apt/sources.list.d/elasticsearch.list' do
  source 'elasticsearch.list'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/apt/sources.list.d/kibana.list' do
  source 'kibana.list'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/apt/sources.list.d/logstash.list' do
  source 'logstash.list'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'update apt metadata and accept oracle license' do
  command 'apt-get update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections'
end

package ['oracle-java8-installer', 'elasticsearch', 'kibana', 'logstash'] do
  options '--allow-unauthenticated'
  action :install
end

cookbook_file '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service 'elasticsearch' do
  action [:enable, :start]
end

cookbook_file '/opt/kibana/config/kibana.yml' do
  source 'kibana.yml'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service 'kibana' do
  action [:enable, :start]
end

#template '/etc/ssl/openssl.cnf' do
#  source 'openssl_cnf.erb'
#  mode '0440'
#  owner 'root'
#  group 'root'
#end

directory '/etc/pki/tls/certs' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/etc/pki/tls/private' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/pki/tls/private/logstash-forwarder.key' do
  source 'logstash-forwarder.key'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/pki/tls/certs/logstash-forwarder.crt' do
  source 'logstash-forwarder.crt'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/logstash/conf.d/tracks.conf' do
  source 'tracks.conf'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/etc/logstash/patterns' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/logstash/patterns/tracks_patterns' do
  source 'tracks_patterns'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service 'logstash' do
  action [:enable, :start]
end
