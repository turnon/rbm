# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150820053102) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "add"
    t.datetime "last_modified"
    t.integer  "category_id"
    t.integer  "file_id"
  end

  add_index "categories", ["category_id"], name: "index_categories_on_category_id"
  add_index "categories", ["file_id"], name: "index_categories_on_file_id"

  create_table "files", force: :cascade do |t|
    t.string "name"
  end

  create_table "links", force: :cascade do |t|
    t.string   "name"
    t.datetime "add"
    t.string   "href"
    t.integer  "category_id"
  end

  add_index "links", ["category_id"], name: "index_links_on_category_id"

end