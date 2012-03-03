class Level < ActiveRecord::Base
  class << self
    def check(query)
      l = Level.where(word: query)
      l.empty? ? 0 : l.first.level
    end

    def yet_to_import(level, max = 10)
      db = ActiveRecord::Base.connection
      result = db.execute("SELECT word FROM levels WHERE level == #{level} AND word NOT IN (SELECT entry FROM words) limit #{max};");
      unless result.empty?
        result.map{|w| w['word']}
      else
        nil
      end
    end
  end
end
