require 'active_record'

db_configuration = YAML.load(File.read("../db/config.yml"))
ActiveRecord::Base.establish_connection(db_configuration["development"])
require_all 'lib'
