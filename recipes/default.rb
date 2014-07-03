#
# Cookbook Name:: ros-web-dev
# Recipe:: default
#
# Copyright (C) 2014
#
#
#

ros_distro = "indigo"

ros 'indigo' do
  release ros_distro
  flavor node[:ros][:flavor]
end

packages = %w(
  rosbridge-library
  rosbridge-suite
)

packages.each do |package_name|
  apt_package "ros-#{ros_distro}-#{package_name}"
end

include_recipe 'ros::runit'

user = node[:ros][:user]

ros_sv 'rosbridge' do
  user user
  setup_bash "/opt/ros/#{ros_distro}/setup.bash"
  launch "--wait rosbridge_server rosbridge_websocket.launch"
end

ros_sv 'fibanacci_server' do
  user user
  setup_bash "/opt/ros/#{ros_distro}/setup.bash"
  command "rosrun actionlib_tutorials fibonacci_server"
end
