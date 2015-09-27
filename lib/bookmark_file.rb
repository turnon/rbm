class BookmarkFile < ActiveRecord::Base
  has_many :categories, dependent: :destroy

  can_recurse :categories

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
