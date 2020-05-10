require 'bundler'
Bundler.require

db_configuration = YAML.load(File.read("db/config.yml"))
ActiveRecord::Base.establish_connection(db_configuration["development"])
load 'db/schema.rb'
require_all 'lib'
