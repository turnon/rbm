class CreateCategory < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.datetime :add
      t.datetime :last_modified
      t.belongs_to :category, index: true
      t.belongs_to :file, index: true
    end
  end
end
