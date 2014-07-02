#
# Cookbook Name:: ros-web-dev
# Recipe:: default
#
# Copyright (C) 2014
#
#
#

## BEGIN HACK
#
# Until chef '11.14.0.rc.1' is out, we need this:
# https://github.com/opscode/chef/commit/e9cfad2fd5c2c659e51fa7ef07906e1a80af7236#diff-956770fc4d43ca694d0f01b5414811ce
#

class Chef
  class Provider
    class Package
      class Apt
        def shell_out!( cmd, opts={} )
          super(cmd, opts.merge(:timeout => 3600))
        end
      end
    end
  end
end

## END HACK


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
  launch "rosbridge_server rosbridge_websocket.launch"
end

ros_sv 'fibanacci_server' do
  user user
  setup_bash "/opt/ros/#{ros_distro}/setup.bash"
  command "rosrun actionlib_tutorials fibonacci_server"
end
