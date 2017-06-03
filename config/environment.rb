require 'bundler'
Bundler.require

require 'pry'
require 'byebug'
require 'colorize'
require 'date'
require 'artii'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

require_all 'lib'
require_all 'app'
