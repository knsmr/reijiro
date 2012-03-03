class Word < ActiveRecord::Base
  has_one :clip, dependent: :destroy

  scope :unclipped, where('id not in (select word_id from words inner join clips on words.id = clips.word_id)')

  class << self
    def lookup(query)
      query.downcase!
      items = Item.where(entry: query).all
      items += Invert.where(token: query).map(&:item)
      items.uniq.map(&:body).join("\n")
    end

    def find_or_lookup(query)
      query.downcase!
      if word = Word.find_by_entry(query)
        word
      else
        definition = lookup(query)
        l = Level.where(word: query)
        if l.empty?
          level = 0
        else
          l.first.level
        end
        unless definition.empty?
          word = Word.create(entry: query, level: level, definition: definition)
          word.save
          clip = word.create_clip(status: 1)
          clip.save
          word
        else
          nil
        end
      end
    end
  end
end
