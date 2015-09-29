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
      b = b.sub(/^\//,'').split(/\//)

      return if class_variable_defined? :@@branch and @@branch == b

      @@branch = b
      @@branch_changed = true

      define_method :categories do

	if @@branch_changed or not instance_variable_defined? :@start_point
          stp = self.o_categories
          @@branch.each do |b_name|
            stp = stp[0].categories.select{ |c| c.name == b_name }
            break if stp.empty?
          end
          @start_point = stp
          @@branch_changed = false
	end

	@start_point

      end
    end

    def branch
      @@branch
    end

  end

end
