class Link < ActiveRecord::Base
  belongs_to :category

  def self.match?(str)
    /\<A HREF\=/.match str
  end

  def parse(str)
    md = /ADD_DATE=\"(\d+)\"/.match str
    self.add = Time.at( md ? md[1].to_i : 0)

    md = /HREF\=\"(.*)\"\s+ADD/.match str
    self.href = md ? md[1] : nil

    md = /\"\>(.*)\<\/A/.match str
    self.name = md ? md[1] : nil
  end
end
