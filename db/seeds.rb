# -*- coding: utf-8 -*-
require 'kconv'
require 'sqlite3'
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

  def sqlstr(str)
    "'#{str.gsub(/'/,"''")}'"
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
      # execute the generated sqls
      puts "\nWriting to the database tables."
      puts "This process may take several minutes."
      database = File.join(Rails.root, %w(db development.sqlite3))
      sqlfile  = File.join(Rails.root, %w(db eijiro.sql))
      system("sqlite3 #{database} \".read #{sqlfile}\"")
      system("rm #{sqlfile}")
      puts "Done."
    end

    def tokenize(str)
      str.split(/[ \-\.\'\%\"\/\,]/)
        .map(&:downcase)
        .reject {|s| s.size <= 1 || COMMON_TOKENS.include?(s)}
    end
  end

  class << self
    include EijiroDictionary

    def load(path)
      eijiro_path = find_dictionaries(path)
      level_table = {}
      sql = SqlGenerator.new
      id = 0

      [eijiro_path[:eiji], eijiro_path[:reiji]].each do |dic|
        File.open(dic) do |f|
          number_of_lines = %x{ wc -l #{dic}}.split.first.to_i
          puts "Convert Eijiro file: #{dic}\n (#{number_of_lines} entries)..."
          pbar = ProgressBar.new("Converting", number_of_lines)

          f.each_line do |l|
            line = Kconv.kconv(l, Kconv::UTF8, Kconv::SJIS)
            line.gsub!(/◆.+$/, '')
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
          pbar.finish
        end
      end
      sql.finish

      # Write word level info to db/level.yml
      File.open(File.join(Rails.root, %w(db level.yml)), "w") do |f|
        f.write level_table.to_yaml
      end
    end

    def import_acl_12000
      puts "Import ALC12000 words..."
      db = SQLite3::Database.new(File.join(Rails.root, %w(db development.sqlite3)))
      (1..12).each do |level|
        pbar = ProgressBar.new("Level #{level}", Eijiro::LEVEL[level].count)
        Eijiro::LEVEL[level].each do |word|
          word.downcase!
          pbar.inc
          eijiro = db.execute("SELECT items.body FROM items WHERE entry = #{sqlstr(word)}")
          reijiro = db.execute("SELECT items.body FROM items INNER JOIN inverts ON items.id = inverts.item_id WHERE inverts.token = #{sqlstr(word)} AND items.entry != #{sqlstr(word)}")
          definition = (eijiro + reijiro).join("\n")
          db.execute("INSERT INTO words (entry, level, definition) VALUES (#{sqlstr(word)}, #{level}, #{sqlstr(definition)});")
        end
        pbar.finish
      end
      db.close
    end
  end
end

# EijiroDictionary.load(Reijiro::Application.config.dictionary_path)

module Eijiro
  level_file = File.join(Rails.root, %w(db level.yml))
  if File.exist?(level_file)
    LEVEL = YAML::load(File.open(level_file))
  end
end

EijiroDictionary.import_acl_12000
