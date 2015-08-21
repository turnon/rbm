require 'rubygems'
require 'active_record'

class SqliteConn
  def self.establish(path)
    ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => path)
  end
end

