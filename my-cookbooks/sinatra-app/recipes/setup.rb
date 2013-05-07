# class Chef::Recipe
#     # mix in recipe helpers
#     include Chef::RubyBuild::RecipeHelpers
# end

node.default['rbenv']['rubies'] = [ node['sinatra-app']['ruby_version'] ]

include_recipe "apt"
package "build-essential"
include_recipe "ruby_build"

include_recipe "rbenv::system"
include_recipe "rbenv::vagrant"

rbenv_global node['sinatra-app']['ruby_version']
rbenv_gem "bundler"
rbenv_gem "rails"
