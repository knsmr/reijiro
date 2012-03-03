class Word < ActiveRecord::Base
  has_one :clip, dependent: :destroy

  scope :unclipped, where('id not in (select word_id from words inner join clips on words.id = clips.word_id)')

  class << self
    def lookup(word)
      word.downcase!
      items = Item.where(entry: word).all
      items += Invert.where(token: word).map(&:item)
      items.uniq.map(&:body).join("\n")
    end

    def find_or_lookup(word)
      word.downcase!
      if w = Word.find_by_entry(word)
        w
      else
        definition = lookup(word)
        l = Eijiro::LEVEL.find {|k, v| v.include?(word)}
        level = l ? l.first : 0
        unless definition.empty?
          Word.create(entry: word, level: level, definition: definition)
        else
          nil
        end
      end
    end
  end
end
