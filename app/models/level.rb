class Level < ActiveRecord::Base
  scope :known,   where(known: true)
  scope :unknown, where(known: false)

  class << self
    def yet_to_import(level, max = 10)
      words =
        Level.unknown
        .where(level: level)
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
