require 'bundler'
Bundler.require

require 'pry'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
# DB = ActiveRecord::Base.connection
require_all 'lib'
require_all 'app'
