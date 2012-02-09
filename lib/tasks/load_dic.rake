# -*- coding: utf-8 -*-
require 'eijiro'

namespace :import do
  task dic: :environment do
    dic = eval(File.open(File.join(Rails.root, %w(lib tasks vocab.txt))).read)
    e = Eijiro.new
    (1..12).each do |level|
      print "-" * 10 + "level: #{level}\n"
      dic[level.to_s].shuffle.take(10).each do |word|
        w = Word.find_or_create_by_entry(word.downcase)
        w.update_attributes(entry: word,
                            level: level,
                            def: e.lookup(word).join("\n"))
        puts word
      end
    end
    e.close_db
  end
end

