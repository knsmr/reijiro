class Level < ActiveRecord::Base
  class << self
    def yet_to_import(level, max = 10)
      words =
        Level.where(level: level)
        .where("word NOT IN (?)", Word.imported_list)
        .limit(max).pluck(:word)
      unless words.empty?
        words
      else
        nil
      end
    end
  end
end
