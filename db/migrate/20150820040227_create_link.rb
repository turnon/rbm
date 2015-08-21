class CreateLink < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :name
      t.datetime :add
      t.string :href
      t.belongs_to :category, index: true, foreign_key: true
    end
  end
end
