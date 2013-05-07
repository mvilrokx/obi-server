default['sinatra-app']['app_dir'] = "/vagrant"
default['sinatra-app']['ruby_version'] = "1.9.3-p392"

# when false, we do not have a database
default['sinatra-app']['install_db'] = false
# when true, we reset the db using rake db:drop and rake db:setup
default['sinatra-app']['reset_db'] = false

default['sinatra-app']['environment'] = 'development'