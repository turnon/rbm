class Category < ActiveRecord::Base
  belongs_to :bookmark_file
  has_many :categories, dependent: :destroy
  belongs_to :category
  has_many :links, dependent: :destroy

  def self.match?(str)
    /\<H\d.*\>(.*)\<\/H\d\>/.match str
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

  alias_method :cs, :categories

  def categories(*opt)
    opt[0] == :r ? categories_recurse : cs
  end

  def categories_recurse
    cs = []
    r = -> c { cs << c ; subcs = c.categories ; subcs.each &r unless subcs.empty? }
    categories.each &r
    cs
  end

end
