# -*- coding: utf-8 -*-
require 'progressbar'

class EijiroDictionary
  class SqlProcessor
    COMMON_TOKENS = %w(i ll  mr ok a about after all also an and any are as at back be because been before but by can can t come could day did didn do don down even first for from get give go going good got great had has have he he her here hey him his how if in into is it its just know like little look made make man may me mean men more most much must my new no not now of oh okay on one only or other our out over person really right said say see she should so some something such take tell than that that the their them then there these they think this time to two up upon us use very want was way we well were what when which who why will with work would yeah year yes you you re your)

    class SqlFile
      def initialize
        @num = "001"
        @path = File.join(Rails.root, "db")
      end

      def current_file
        File.join(@path, "eijiro#{@num}.sql")
      end

      def open
        File.open(current_file, "w") do |f|
          f.write "BEGIN TRANSACTION;\n"
        end
      end

      def close
        File.open(current_file, "a") do |f|
          f.write "\nEND TRANSACTION;\n"
        end
        @num = @num.succ
      end
    end

    def initialize
      @flush_limit = 10_0000
      @sqlfile = SqlFile.new
      @sqlfile.open
      @sql = []
    end

    def generate(id, entry, body)
      @sql << "INSERT INTO items (entry, body) VALUES (#{sqlstr(entry)}, #{sqlstr(body)});"
      tokenize(entry).each do |token|
        @sql << "INSERT INTO inverts (token, item_id) VALUES (#{sqlstr(token)}, #{id});"
      end
      if id % @flush_limit == 0
        flush
        @sqlfile.open
      end
    end

    def flush
      File.open(@sqlfile.current_file, "a") do |f|
        f.write @sql.join("\n")
      end
      @sql = []
      @sqlfile.close
    end

    def finish
      flush
      # execute the generated sqls
      database = File.join(Rails.root, %w(db development.sqlite3))
      n = %x{ ls -1 #{File.join(Rails.root, "db", "eijiro*")} |wc -l }.chomp.strip.to_i
      pbar = ProgressBar.new("Executing SQL commands...", n)
      Dir.foreach(File.join(Rails.root, "db")) do |file|
        if file =~ /eijiro.+\.sql/
          pbar.inc
          file = File.join(Rails.root, "db", file)
          system("sqlite3 #{database} \".read #{file}\"")
          system("rm #{file}")
        end
      end
      pbar.finish
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
end
