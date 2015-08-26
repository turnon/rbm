#!/usr/bin/env ruby

require 'optparse'
require 'erb'

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

  opts.on("-d DB") do |db|
    options[:d] = db
  end
  
  opts.on("-o HTML") do |html|
    options[:o] = html
  end
end

option_parser.parse!

# setup db file

db_file = (
  if options.empty?
    ARGV.pop
  elsif options[:d]
    options[:d]
  else
    File.join(Dir.tmpdir, Dir::Tmpname.make_tmpname(['rbmsql','.sqlite3'], nil))
  end
)

SqliteConn.establish db_file

# if bookmark file given ...

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

# after db linked and file processed

if options[:i]
  require 'pry'
  pry
end

if options[:o]
  bmfl = BookmarkFile.all
  temp_str = File.read(File.join(File.dirname(__FILE__), 'temp.html'))
  puts ERB.new(temp_str).result
end

File.delete db_file if !options.empty? and !options[:d]

