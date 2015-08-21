require 'rubygems'
require 'active_record'

class SqliteConn
  def self.establish(path)
    check_db path
    ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3', :database => path)
  end

  def self.check_db(path)
    File.exists?(path) || File.new(path, 'w').close
    if File.size(path).zero?
      `sqlite3 #{path} 'CREATE TABLE "bookmark_files" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar);CREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "add" datetime, "last_modified" datetime, "category_id" integer, "bookmark_file_id" integer); CREATE TABLE "links" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "add" datetime, "href" varchar, "category_id" integer); CREATE INDEX "index_categories_on_bookmark_file_id" ON "categories" ("bookmark_file_id"); CREATE INDEX "index_categories_on_category_id" ON "categories" ("category_id"); CREATE INDEX "index_links_on_category_id" ON "links" ("category_id");'`
    end
  end
end

