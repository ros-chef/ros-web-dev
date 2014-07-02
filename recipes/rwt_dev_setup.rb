
package "git"

include_recipe "nodejs"

packages = %w(grunt-cli karma bower)

packages.each do |package_name|
  nodejs_npm package_name
end

include_recipe "phantomjs::default"

user = node["ros_web_dev"]["user"]

execute "build roslibjs" do
  cwd "/home/#{user}/"
  command "chown -R #{user} ."
end

directory "/home/#{user}/rwt" do
  user user
  group user
end

org = "robotwebtools"
repos = %w(roslibjs ros3djs ros2djs)

repos.each do |repo|
  git "/home/#{user}/rwt/#{repo}" do
    repository "https://github.com/#{org}/#{repo}"
    user user
  end
end

execute "build roslibjs" do
  cwd "/home/#{user}/rwt/roslibjs/utils"
  user user
  command "npm install && grunt build && touch .initial.build.done"
  not_if { File.exists?( "/home/#{user}/rwt/roslibjs/utils/.initial.build.done" ) }
end
