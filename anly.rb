require_relative 'string_extend'
require_relative 'dir_stack'

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


