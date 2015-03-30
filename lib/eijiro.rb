# -*- coding: utf-8 -*-
require 'kconv'
require 'sqlite3'
require 'yaml'
require 'progressbar'
require 'eijiro/sqlprocessor'

class EijiroDictionary
  def initialize(path)
    @eijiro_files = find_dictionaries(path)
    @dbfile = File.join(Rails.root, %w(db development.sqlite3))
    @level_table = {}
    @sql = SqlProcessor.new
    @id = 0
  end

  def convert_to_sql
    @eijiro_files.each do |dic|
      File.open(dic) do |f|
        number_of_lines = %x{ wc -l #{dic}}.split.first.to_i
        puts "Convert Eijiro file to sql: #{dic}\n (#{number_of_lines} entries)"
        pbar = ProgressBar.new("Converting", number_of_lines)

        f.each_line do |l|
          line = Kconv.kconv(l, Kconv::UTF8, Kconv::SJIS)
          line.gsub!(/◆.+$/, '')
          if line =~ /■(.*?)(?:  ?\{.*?\})? : (【レベル】([0-9]+))?/
            @id += 1
            entry = $1.downcase
            level = $3 ? $3 : 0
            if level != 0
              @level_table[level.to_i] ||= []
              @level_table[level.to_i] << entry
            end
            body = line.chomp
            @sql.generate(@id, entry, body)
            pbar.inc
          end
        end
        pbar.finish
      end
    end
  end

  def write_to_database
    puts "\nWriting to the database tables."
    puts "This process may take several minutes."
    @sql.finish
    puts "Done."
  end

  def write_level
    puts "Writing to level table..."
    db = SQLite3::Database.new(@dbfile)
    (1..12).each do |level|
      @level_table[level].each do |word|
        definition = db.execute("SELECT items.body FROM items WHERE entry = #{sqlstr(word)}").first.first
        db.execute("INSERT INTO levels (word, level, definition) VALUES (#{sqlstr(word)}, #{level}, #{sqlstr(definition)});")
      end
    end
    db.close
  end

  def import_acl_12000
    puts "Import ALC12000 words..."
    db = SQLite3::Database.new(@dbfile)
    (1..12).each do |level|
      pbar = ProgressBar.new("Level #{level}", Level.where(level: level).count)
      Level.where(level: level).map(&:word).each do |word|
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

private

  def find_dictionaries(path)
    eijiro_files = []
    Dir.foreach(path) do |file|
      case file
        when /^EIJI-.*\.TXT/i
        eijiro_files << File.join(path, file)
      when /^REIJI.*\.TXT/i
        eijiro_files << File.join(path, file)
      end
    end
    raise "No dictionary files found" if eijiro_files.empty?
    eijiro_files
  end

  def sqlstr(str)
    "'#{str.gsub(/'/,"''")}'"
  end
end
