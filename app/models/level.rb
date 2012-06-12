class Level < ActiveRecord::Base
  class << self
    def yet_to_import(level, max = 10)
      words =
        Level.where(level: level)
        .where("word NOT IN (?)", Word.pluck(:entry))
        .limit(max).pluck(:word)
      unless words.empty?
        words
      else
        nil
      end
    end
  end
end
