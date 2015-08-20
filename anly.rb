require_relative 'dir_stack'
require_relative 'sqlite_conn'
require_relative 'bookmark_file'
require_relative 'category'
require_relative 'link'

SqliteConn.establish 'db/development.sqlite3'

st = DirStack.new

while line = gets
  line.sub!(/^\s+/, '')
  #next unless /(\<D|\<\/D)/ =~ line
  if Link.match? line
    l = Link.new
    l.parse line
    puts "#{st.cur ? st.cur.name : 'root'} #{l.name} #{l.href} #{l.add}"
  elsif Category.match? line
    c = Category.new
    c.parse line
    puts "#{st.cur ? st.cur.name : 'root'} #{c.name} #{c.add} #{c.last_modified}"
    st << c
  elsif Category.match_ending? line
    st.getout
  end
end

#st.each do |t| 
#  puts t
#end


