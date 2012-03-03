class Level < ActiveRecord::Base
  class << self
    def check(query)
      l = Level.where(word: query)
      l.empty? ? 0 : l.first.level
    end
  end
end
