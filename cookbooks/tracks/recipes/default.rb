#
# Cookbook Name:: tracks
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

user 'tracks' do
  manage_home true
  uid '3000'
  home '/home/tracks'
  shell '/bin/bash'
end

package ['git', 'ruby', 'ruby-dev', 'libmysqlclient-dev', 'g++', 'gcc', 'make', 'libsqlite3-dev', 'curl'] do
  action :install
end

directory '/opt/tracks' do
  owner 'tracks'
  group 'tracks'
  mode '0755'
  action :create
end

git '/opt/tracks' do
  repository 'https://github.com/TracksApp/tracks.git'
  reference 'master'
  action :sync
  user 'tracks'
  group 'tracks'
end

cookbook_file '/home/tracks/tracks.sql' do
  source 'tracks.sql'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'create tracksdb in mysql' do
  command 'mysql -u root < /home/tracks/tracks.sql'
end

cookbook_file '/opt/tracks/config/database.yml' do
  source 'database.yml'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/opt/tracks/config/site.yml' do
  source 'site.yml'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

gem_package 'bundler' do
  action :install
end

execute 'install tracks' do
  command 'bundle install --path vendor/bundle --without development test'
  user 'tracks'
  group 'tracks'
  cwd '/opt/tracks'
end

execute 'populate db with the tracks schema' do
  command 'bundle exec rake db:migrate RAILS_ENV=production'
  user 'tracks'
  group 'tracks'
  cwd '/opt/tracks'
end

execute 'precompile assets' do
  command 'bundle exec rake assets:precompile RAILS_ENV=production'
  user 'tracks'
  group 'tracks'
  cwd '/opt/tracks'
end

cookbook_file '/etc/systemd/system/tracks.service' do
  source 'tracks.service'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service "tracks" do
  action [ :enable, :start ]
end

cookbook_file '/tmp/elk.tar.gz' do
  source 'elk.tar.gz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'restore kibana dashboard' do
  command 'cd /tmp
    tar xzpf elk.tar.gz
    cd elk
    ./load.sh
    rm -rf /tmp/elk*'
end

execute 'set kibana default index' do
  command 'curl -XPOST http://localhost:9200/.kibana/config/4.4.2/_update -d \'{"doc":{"defaultIndex":"tracks"}}\''
end
