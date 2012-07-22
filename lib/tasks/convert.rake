namespace :db do
  desc "Convert Eijiro dictionary data into SQlite3 format"
  task :convert, [:path] => [:migrate] do |t, args|
    args.with_defaults(path: File.expand_path('~/Documents/Eijiro6T'))
    require 'eijiro'
    puts "Converting #{args[:path]}..."
    e = EijiroDictionary.new(args[:path])
    e.convert_to_sql
    e.write_to_database
    e.write_level
  end
end
