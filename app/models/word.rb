require 'eijiro'

class Word < ActiveRecord::Base
  has_one :clip, dependent: :destroy
  default_scope order('updated_at DESC')

  scope :unclipped, where('id not in (select word_id from words inner join clips on words.id = clips.word_id)')

  class << self
    def find_or_lookup(word)
      word.downcase!
      if w = Word.find_by_entry(word)
        w
      else
        definition = Eijiro.lookup(word)
        level = Eijiro.level(word)
        unless definition.empty?
          Word.create(entry: word,
                      level: level,
                      definition: definition.join("\n"))

        else
          nil
        end
      end
    end
  end
end
