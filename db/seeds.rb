# -*- coding: utf-8 -*-
require 'kconv'
require 'yaml'
require 'progressbar'

module EijiroDictionary
  COMMON_TOKENS = %w(i ll  mr ok a about after all also an and any are as at back be because been before but by can can t come could day did didn do don down even first for from get give go going good got great had has have he he her here hey him his how if in into is it its just know like little look made make man may me mean men more most much must my new no not now of oh okay on one only or other our out over person really right said say see she should so some something such take tell than that that the their them then there these they think this time to two up upon us use very want was way we well were what when which who why will with work would yeah year yes you you re your)

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

  def tokenize(str)
    str.split(/[ \-\.\'\%\"\/\,]/)
      .map(&:downcase)
      .reject {|s| s.size <= 1 || COMMON_TOKENS.include?(s)}
  end

  class << self
    include EijiroDictionary

    def load(path)
      eijiro_path = find_dictionaries(path)
      level_table = {}

      File.open(eijiro_path[:eiji]) do |f|
        number_of_lines = %x{ wc -l #{eijiro_path[:eiji]}}.split.first.to_i
        puts "Importing Eijiro dictionary files(#{number_of_lines} entries)..."
        pbar = ProgressBar.new("Loading", number_of_lines)

        f.each_line do |l|
          line = Kconv.kconv(l, Kconv::UTF8, Kconv::SJIS)
          if line =~ /■(.*?)(?:  ?\{.*?\})? : (【レベル】([0-9]+))?/
            entry = $1
            level = $3 ? $3 : 0
            if level != 0
              level_table[level.to_i] ||= []
              level_table[level.to_i] << entry
            end
            text = line.chomp

            # Write eijiro entries to items table
            i = Item.create(entry: entry.downcase, body: text)

            # Write inverted index to inverts table
            tokenize(entry).each do |t|
              Invert.create(token: t, item_id: i.id)
            end
            pbar.inc
          end
        end

        pbar.finish
      end

      # Write word level info to db/level.yml
      File.open(File.join(Rails.root, %w(db level.yml)), "w") do |f|
        f.write level_table.to_yaml
      end
    end
  end

end

EijiroDictionary.load(Reijiro::Application.config.dictionary_path)
