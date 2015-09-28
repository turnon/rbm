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

  class << self

    def branch=(b)
      alias_method :o_categories, :categories unless instance_methods.any? { |m| m == :o_categories }
      @@p = b.sub(/^\//,'').split(/\//)
      define_method :categories do
        @start_point = self.o_categories[0]
        @@p.each do |b_name|
          @start_point = @start_point.categories.select{ |c| c.name == b_name }[0]
          break if @start_point.nil?
        end
        @start_point
      end
    end

    def branch
      @@p
    end

  end

end
