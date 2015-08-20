class Category < ActiveRecord::Base
  belongs_to :bookmark_file
  has_many :categories, dependent: :destroy
  has_many :links, dependent: :destroy

end
