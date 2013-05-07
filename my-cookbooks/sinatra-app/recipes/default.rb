# class Chef::Recipe
#     # mix in recipe helpers
#     include Chef::RubyBuild::RecipeHelpers
# end

app_dir = node['sinatra-app']['app_dir']

# include_recipe "sinatra-app::setup"

include_recipe "nginx"
include_recipe "unicorn"

directory "/var/run/unicorn" do
  owner "root"
  group "root"
  mode "777"
  action :create
end

file "/var/run/unicorn/master.pid" do
  owner "root"
  group "root"
  mode "666"
  action :create_if_missing
end

file "/var/log/unicorn.log" do
  owner "root"
  group "root"
  mode "666"
  action :create_if_missing
end

template "/etc/unicorn.cfg" do
  owner "root"
  group "root"
  mode "644"
  source "unicorn.erb"
  variables( :app_dir => app_dir)
end

# rbenv_script "run-rails" do
  # rbenv_version node['sinatra-app']['ruby_version']
  # cwd app_dir
  # rvm gemset use default
  # code <<-EOT
  #   bundle install
  #   ps -p `cat /var/run/unicorn/master.pid` &>/dev/null || bundle exec unicorn -c /etc/unicorn.cfg -D --env #{node['sinatra-app']['environment']}
  # EOT
  # if node['sinatra-app']['reset_db']
  #   code <<-EOT1
  #     bundle install
  #     bundle exec rake db:drop
  #     bundle exec rake db:setup
  #     bundle exec rake db:test:prepare
  #     ps -p `cat /var/run/unicorn/master.pid` &>/dev/null || bundle exec unicorn -c /etc/unicorn.cfg -D --env #{node['sinatra-app']['environment']}
  #   EOT1
  # else
  #   code <<-EOT2
  #     bundle install
  #     bundle exec rake db:migrate
  #     ps -p `cat /var/run/unicorn/master.pid` &>/dev/null || bundle exec unicorn -c /etc/unicorn.cfg -D --env #{node['sinatra-app']['environment']}
  #   EOT2
  # end
# end

template "/etc/nginx/sites-enabled/default" do
  owner "root"
  group "root"
  mode "644"
  source "nginx.erb"
  variables( :static_root => "#{app_dir}/public")
  notifies :restart, "service[nginx]"
end

service "unicorn"
service "nginx"