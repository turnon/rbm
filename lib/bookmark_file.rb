class BookmarkFile < ActiveRecord::Base
  has_one :category, dependent: :destroy

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

end
