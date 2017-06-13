require 'yaml'
require 'chef/cookbook/metadata'

task :kitchen_suites do
  metadata = Chef::Cookbook::Metadata.new
  metadata.from_file('metadata.rb')
  kitchen = YAML.load_file('.kitchen.yml')

  errors = []
  Dir['recipes/[!_]*.rb'].each do |recipe|
    kitchen['suites'].each do |suite|
      run_list_recipe = "recipe[#{metadata.name}::#{recipe}]"
      next if suite['run_list'].include? run_list_recipe
      errors.push "Missing kitchen configuration for #{run_list_recipe}"
    end
  end
  raise errors.join "\n" unless errors.empty?
end
