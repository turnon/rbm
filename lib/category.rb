class Category < ActiveRecord::Base
  belongs_to :bookmark_file
  has_many :categories, dependent: :destroy
  belongs_to :category
  has_many :links, dependent: :destroy

  can_recurse :categories

  def self.match?(str)
    /\<H3.*\>(.*)\<\/H3\>/.match str and not /PERSONAL_TOOLBAR_FOLDER/.match str
  end

  def self.match_ending?(str)
    /\<\/DL/.match str
  end

  def parse(str)
    md = /ADD_DATE\=\"(\d+)\"/.match str
    self.add = Time.at( md ? md[1].to_i : 0 )    
    
    md = /LAST_MODIFIED\=\"(\d+)\"/.match str
    self.last_modified = md ? Time.at(md[1].to_i) : nil    
    
    md = /(\"|1)\>(.*)\<\/H/.match str
    self.name = md ? md[2] : nil
  end

  alias_method :bmf, :bookmark_file

  def bookmark_file
    path[-1].bmf
  end

  def path
    p = [].unshift (c = self)
    until c.bmf
      c = c.category
      p.unshift c
    end
    p
  end

  def links_recurse
    arr = links.to_a
    categories_recurse.each { |c| arr.concat c.links.to_a }
    arr
  end

end
