class CreateFile < ActiveRecord::Migration
  def change
    create_table :bookmark_files do |t|
      t.string :name
    end
  end
end
