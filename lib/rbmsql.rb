#!/usr/bin/env ruby

require 'optparse'

require_relative 'sqlite_conn'
require_relative 'bookmark_file'
require_relative 'category'
require_relative 'link'

# scan options

options = {}

option_parser = OptionParser.new do |opts|
  opts.on("-i","--interactive") do
    options[:i] = true
  end
end

option_parser.parse!

# process

db_file = options[:i] ? File.join(Dir.tmpdir, Dir::Tmpname.make_tmpname(['rbmsql','.sqlite3'], nil)) : ARGV.pop

SqliteConn.establish db_file

while not ARGV.empty?

  file_path = ARGV.shift

  bmf = BookmarkFile.new
  bmf.name = File.basename(file_path, '.html')

  File.open(file_path) do |f|

    while line = f.gets
      line.sub!(/^\s+/, '')
      if Link.match? line
        l = bmf.current_category.links.build
        l.parse line
      elsif Category.match? line
        cur_c = bmf.current_category
        c = (cur_c && cur_c.categories.build || bmf.build_category )
        c.parse line
        bmf.getin c
      elsif Category.match_ending? line
        bmf.getout
      end
    end

  end

  bmf.save

end

if options[:i]
  require 'pry'
  pry
  File.delete db_file
end

