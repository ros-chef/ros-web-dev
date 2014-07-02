ros_distro = "indigo"

org = "syrnick"
user = node["ros_web_dev"]["user"]

repo = "angular-ros"

git "/home/#{user}/rwt/#{repo}" do
  repository "https://github.com/#{org}/#{repo}"
  user user
end

execute "build #{repo}" do
  cwd "/home/#{user}/rwt/#{repo}"
  command "npm install && bower install && touch .initial.build.done"
  user user
  not_if { File.exists?( "/home/#{user}/rwt/#{repo}/.initial.build.done" ) }
end

ros_sv 'angular-ros-static' do
  user user
  setup_bash "/opt/ros/#{ros_distro}/setup.bash"
  command "bash -c 'cd ~/rwt/angular-ros && python -m SimpleHTTPServer 8081'"
end
