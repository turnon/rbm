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

  opts.banner = "Usage: rbmsql [options].. FILE...\n\nSave chrome bookmark into sqlite. Or interact with the bookmark using ActiveRecord. Or output a statistic report for it. If no option is given, the last file should be sqlite file\n\n"

  opts.on("-i","--interactive", 'Open pry after all files read') do
    options[:i] = true
  end

  opts.on("-d DB", 'Specify sqlite file path. If no -d but -i, sqlite file will be created somewhere like /tmp') do |db|
    options[:d] = db
  end
  
  opts.on("-o HTML", 'Specify report file path. Statistic report will be outputed there') do |html|
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

# process bookmark files ...

bmfs = []

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
        c = (cur_c && cur_c.categories.build || bmf.categories.build )
        c.parse line
        bmf.getin c
      elsif Category.match_ending? line
        bmf.getout
      end
    end

  end

  bmfs << bmf

end

# persistent only when db file is specified 

bmfs.each { |f| f.save } if options.empty? or options[:d]

# after db linked and file processed

if options[:i]
  require 'pry'
  pry
end

if options[:o]
  temp_str = File.read(File.join(File.dirname(__FILE__), 'temp.html'))
  File.open options[:o], 'w' do |f|
    f.puts ERB.new(temp_str).result
  end
end

File.delete db_file if !options.empty? and !options[:d]

