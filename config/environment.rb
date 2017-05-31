require 'bundler'
Bundler.require

require 'pry'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
# DB = ActiveRecord::Base.connection
require_all 'lib'
require_all 'app'
