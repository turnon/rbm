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
