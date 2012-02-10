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

  class << self
    def lookup(word)
      e = Eijiro.new
      result = e.lookup(word)
      e.close_db
      result
    end
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

