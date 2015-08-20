class String
  
  def title?
    /\<H\d.*\>(.*)\<\/H\d\>/.match self
  end

  def title
    md = title?
    md ? md[1] : nil
  end

  def list_ending?
    /\<\/DL/.match self
  end

  def item?
    /\<A HREF\=/.match self
  end

  def item
    md = /\<A.*\>(.*)\<\/A\>/.match self
    md[1]
  end
end
