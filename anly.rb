class DirStack

  def initialize
    @st = []
  end

  def <<(d)
    @st << d
  end

  alias_method :getin, :<< 

  def cur
    @st[-1] || 'root'
  end

  def getout
    @st.pop
  end

end

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


st = DirStack.new

while line = gets
  line.sub!(/^\s+/, '')
  #next unless /(\<D|\<\/D)/ =~ line
  if line.item?
    puts "#{st.cur} #{line.item}"
  elsif line.title?
    puts "#{st.cur} #{line.title}"
    st << line.title
  elsif line.list_ending?
    st.getout
  end
end

#st.each do |t| 
#  puts t
#end


