# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 4567, host: 4567, auto_correct: true
  config.vm.network :forwarded_port, guest: 9292, host: 9292, auto_correct: true
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.


  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "my-cookbooks"]
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"

    # ensure the local APT package cache is up to date
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "user"
    chef.add_recipe "git"
    # chef.add_recipe "application_ruby::passenger_apache2"
    chef.add_recipe "nginx"

    # install rvm
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "rvm::system"
    # chef.add_recipe "rvm::user"
  #   chef.add_role "web"

    # FINALLY deploy the application!!!
    # chef.add_recipe "obi-server"
    chef.add_recipe "sinatra-app"

    # You may also specify custom JSON attributes:
    chef.json = {
      'sinatra-app' => {
         'app_dir' => '/vagrant',
         'ruby_version' => '1.9.3-p392'
      },
      :rvm => {
        :default_ruby => "ruby-1.9.3-p392",
        # :user_installs => [{
        #   :user => "vagrant",
        #   :default_ruby => "ruby-1.9.3"
        # },{
        #   :user => "deployer",
        #   :default_ruby => "ruby-1.9.3"
        # }],
        :global_gems => [
          { 'name'    => 'bundler' }
        ]
      }
    }
  end

  config.vm.provision :shell, :inline => "cd /vagrant && rvm gemset use default && bundle install && ps -p `cat /var/run/unicorn/master.pid` &>/dev/null || bundle exec unicorn -c /etc/unicorn.cfg -D --env development"

  # THIS WORKS FINE BUT I WANT TO USE NGINX + UNICORN!!!
  # config.vm.provision :shell, :inline => 'cd /vagrant && rvm gemset use default && bundle install && bundle exec rackup -D'

end
