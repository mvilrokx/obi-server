# ensure the local APT package cache is up to date
# include_recipe 'apt'
# install ruby_build tool which we will use to build ruby
# include_recipe 'ruby_build'
# ruby_build_ruby '1.9.3-p362' do
#   prefix_path '/usr/local/'
#   environment 'CFLAGS' => '-g -O2'
#   action :install
# end

gem_package 'bundler' do
  version '1.3.5'
  # gem_binary '/usr/local/bin/gem'
  # gem_binary '/opt/vagrant_ruby/bin/gem'
  gem_binary '/usr/local/rvm/rubies/ruby-1.9.3-p392/bin/gem'
  options '--no-ri --no-rdoc'
end

# we create new user that will run our application server
# user_account 'deployer' do
#   create_group true
#   ssh_keygen false
# end

# we define our application using application resource provided by application cookbook
application 'obi-server' do
  # owner 'deployer'
  # group 'deployer'
  # path '/home/deployer/app'
  owner 'vagrant'
  group 'vagrant'
  path '/home/vagrant/app'
  revision 'master'
  repository 'https://github.com/mvilrokx/obi-server.git'
  rails do
    bundler true
  end
  unicorn do
    worker_processes 2
  end
end