require 'rubygems'
require 'active_record'

class SqliteConn

  class << self

    def establish(path)
      File.exists?(path) || File.new(path, 'w').close
      ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => path)
      
      puts File.size(path)
      File.size(path).zero? && create_db
    end

    def create_db
      ActiveRecord::Schema.define do
        create_table :bookmark_files do |t|
          t.string :name
        end

        create_table :categories do |t|
          t.string :name
          t.datetime :add
          t.datetime :last_modified
          t.belongs_to :category, index: true
          t.belongs_to :bookmark_file, index: true
        end

        create_table :links do |t|
          t.string :name
          t.datetime :add
          t.string :href
          t.belongs_to :category, index: true, foreign_key: true
        end
      end
    end

  end

end

