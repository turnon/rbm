class BookmarkFile < ActiveRecord::Base
  has_many :categories, dependent: :destroy

  def getin(d)
    @st ||= []
    @st << d
  end

  def current_category
    @st ||= []
    @st[-1] || nil
  end

  def getout
    @st ||= []
    @st.pop
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
