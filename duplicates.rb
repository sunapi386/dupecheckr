## Jason Sun <jason@sunapi386.ca>
## Jan 30, 2017
##
## Lists the duplicate files in the two given directories.
## Simple, only compares names. Case sensitive.
## Options:
## - filter by file extension
## - list the non-duplicate files
## - show the list (vs just stats)

require 'optparse'

# Parse
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby #{$PROGRAM_NAME} <src dir> <cmp dir> [options]"
  opts.on("-f", "--filter EXTENSION", "Filter by extension")    { |e| options[:filter] = e }
  opts.on("-u", "--unique", "List only non-duplicate files")    { |n| options[:unique] = n }
  opts.on("-s", "--stats", "Statistics only, no file names")    { |s| options[:stats] = s }
end.parse!


# Sanitation
if ARGV.size != 2
  abort "Expected 2 directories to compare!"
end
dir1 = ARGV[0]
abort "Not a directory! #{dir1}" unless Dir.exists? dir1
dir2 = ARGV[1]
abort "Not a directory! #{dir2}" unless Dir.exists? dir2


# Compare
files1 = Dir["#{dir1}/**/*"].select {|f| !File.directory? f}
puts "#{files1.size} files in #{dir1}"
files2 = Dir["#{dir2}/**/*"].select {|f| !File.directory? f}
puts "#{files2.size} files in #{dir2}"

extension = options[:filter]
if extension
  files1.select!{ |f| File.extname(f) == extension }
  puts "#{files1.size} with #{extension} extension in #{dir1}"
  files2.select!{ |f| File.extname(f) == extension }
  puts "#{files2.size} with #{extension} extension in #{dir2}"
end

bases2 = files2.map { |path2| File.basename(path2) }
if options[:unique]
  unique = files1.select { |path1| !bases2.include?(File.basename(path1)) }
  puts "#{unique.size} unique files"
  puts unique unless options[:stats]
else
  duplicates = files1.select { |path1| bases2.include?(File.basename(path1)) }
  puts "#{duplicates.size} duplicates"
  puts duplicates unless options[:stats]
end

