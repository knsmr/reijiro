# -*- coding: utf-8 -*-
require 'sqlite3'

class Eijiro
  DICDB = "/Users/ken/Documents/eijiro/bin/database"
  attr_reader :word

  def initialize
    @db = SQLite3::Database.new(DICDB)
  end

  def lookup(word)
    case word
    when Array
      @word = word.join(' ')
    when String
      @word = word
    end
    result = lookup_entries(@word) + lookup_samples(@word)
    result.flatten.map do |e|
      e.gsub(/^■/, '').gsub(/#{@word} +\{/, '{')
    end
  end

  def close_db
    @db.close
  end

private

  def lookup_entries(word)
    @db.execute("select raw from eijiro where entry=\'#{word}\'")
  end

  def lookup_samples(word)
    @db.execute("select id from invindex where token=\'#{word}\'").map do |r|
      @db.execute("select raw from eijiro where id=\'#{r[0]}\'")
    end
  end
end

namespace :import do
  task dic: :environment do
    dic = eval(File.open(File.join(Rails.root, %w(lib tasks vocab.txt))).read)
    e = Eijiro.new
    (1..12).each do |level|
      print "-" * 30 + "level: #{level}\n"
      dic[level.to_s].shuffle.take(10).each do |word|
        w = Word.find_or_create_by_entry(word)
        w.update_attributes(entry: word,
                            level: level,
                            def: e.lookup(word).join("\n"))
        puts word
      end
    end
    e.close_db
  end
end

