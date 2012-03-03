# -*- coding: utf-8 -*-
require 'kconv'
require 'yaml'
require 'progressbar'

module EijiroDictionary
  def find_dictionaries(path)
    eijiro_path = {}
    Dir.foreach(path) do |file|
      case file
        when /^EIJI-.*\.TXT/i
        eijiro_path[:eiji] = File.join(path, file)
      when /^REIJI.*\.TXT/i
        eijiro_path[:reiji] = File.join(path, file)
      end
    end
    raise "No dictionary files found" if eijiro_path.empty?
    eijiro_path
  end

  def normalize(str)
    str.gsub(/[\'\"\-]/, '')
  end

  class SqlGenerator
    COMMON_TOKENS = %w(i ll  mr ok a about after all also an and any are as at back be because been before but by can can t come could day did didn do don down even first for from get give go going good got great had has have he he her here hey him his how if in into is it its just know like little look made make man may me mean men more most much must my new no not now of oh okay on one only or other our out over person really right said say see she should so some something such take tell than that that the their them then there these they think this time to two up upon us use very want was way we well were what when which who why will with work would yeah year yes you you re your)

    def initialize
      @flush_limit = 10_000
      @file = File.join(Rails.root, %w(db eijiro.sql))
      @sql = []
      File.open(@file, "w") {|f| f.write "BEGIN TRANSACTION;\n"}
    end

    def generate(id, entry, body)
      @sql << "INSERT INTO items (entry, body) VALUES (#{sqlstr(entry)}, #{sqlstr(body)});"
      tokenize(entry).each do |token|
        @sql << "INSERT INTO inverts (token, item_id) VALUES (#{sqlstr(token)}, #{id});"
      end
      flush if id % @flush_limit == 0
    end

    def flush
      File.open(@file, "a") do |f|
        f.write @sql.join("\n")
      end
      @sql = []
    end

    def finish
      flush
      File.open(@file, "a") {|f| f.write "\nEND TRANSACTION;\n"}
    end

    def tokenize(str)
      str.split(/[ \-\.\'\%\"\/\,]/)
        .map(&:downcase)
        .reject {|s| s.size <= 1 || COMMON_TOKENS.include?(s)}
    end

    def sqlstr(str)
      "'#{str.gsub(/'/,"''")}'"
    end
  end

  class << self
    include EijiroDictionary

    def load(path)
      eijiro_path = find_dictionaries(path)
      level_table = {}
      sql = SqlGenerator.new
      id = 0

      File.open(eijiro_path[:eiji]) do |f|
        number_of_lines = %x{ wc -l #{eijiro_path[:eiji]}}.split.first.to_i
        puts "Importing Eijiro dictionary files(#{number_of_lines} entries)..."
        pbar = ProgressBar.new("Loading", number_of_lines)

        f.each_line do |l|
          line = Kconv.kconv(l, Kconv::UTF8, Kconv::SJIS)
          if line =~ /■(.*?)(?:  ?\{.*?\})? : (【レベル】([0-9]+))?/
            id += 1
            entry = $1.downcase
            level = $3 ? $3 : 0
            if level != 0
              level_table[level.to_i] ||= []
              level_table[level.to_i] << entry
            end
            body = line.chomp
            sql.generate(id, entry, body)
            pbar.inc
          end
        end

        sql.finish
        pbar.finish

        # execute sqls
        puts "Writing to the database tables."
        puts "This process may take a couple of minutes."
        database = File.join(Rails.root, %w(db development.sqlite3))
        sqlfile  = File.join(Rails.root, %w(db eijiro.sql))
        system("sqlite3 #{database} \".read #{sqlfile}\"")
        system("rm #{sqlfile}")
      end

      # Write word level info to db/level.yml
      File.open(File.join(Rails.root, %w(db level.yml)), "w") do |f|
        f.write level_table.to_yaml
      end
    end
  end

end

EijiroDictionary.load(Reijiro::Application.config.dictionary_path)
