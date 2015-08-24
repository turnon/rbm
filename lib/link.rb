class Link < ActiveRecord::Base
  belongs_to :category

  def self.match?(str)
    /\<A HREF\=/.match str
  end

  def parse(str)
    md = /HREF\=\"(.*)\"\s+ADD_DATE\=\"(\d+)\".*\>(.*)\<\/A\>/.match str
    self.href, self.add, self.name = md[1] , Time.at(md[2].to_i), md[3] if md
  end
end
