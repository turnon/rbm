require_relative 'sqlite_conn'
require_relative 'bookmark_file'
require_relative 'category'
require_relative 'link'

SqliteConn.establish ARGV.pop

while not ARGV.empty?

  file_path = ARGV.shift

  bmf = BookmarkFile.new
  bmf.name = File.basename(file_path, '.html')

  File.open(file_path) do |f|

    while line = f.gets
      line.sub!(/^\s+/, '')
      if Link.match? line
        l = Link.new
        l.parse line
        puts "#{bmf.current_category ? bmf.current_category.name : 'root'} #{l.name} #{l.href} #{l.add}"
      elsif Category.match? line
        c = Category.new
        c.parse line
        puts "#{bmf.current_category ? bmf.current_category.name : 'root'} #{c.name} #{c.add} #{c.last_modified}"
        bmf.getin c
      elsif Category.match_ending? line
        bmf.getout
      end
    end

  end

  bmf.save

end

