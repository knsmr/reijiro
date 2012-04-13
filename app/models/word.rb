require 'open-uri'
require 'nokogiri'

class Word < ActiveRecord::Base
  has_one :clip, dependent: :destroy

  scope :unclipped, where('id not in (select word_id from words inner join clips on words.id = clips.word_id)')

  class << self
    def lookup(query)
      query = normalize_query(query)
      items = Item.where(entry: query).all
      items += Invert.where(token: query).map(&:item)
      items.uniq.map(&:body).join("\n")
    end

    def find_or_lookup(query)
      query = normalize_query(query)
      if word = Word.find_by_entry(query)
        word
      else
        definition = lookup(query)
        level = Level.check(query)
        thesaurus = lookup_thesaurus(query)
        unless definition.empty?
          word = Word.create(entry: query,
                             level: level,
                             thesaurus: thesaurus,
                             definition: definition)
          word.create_clip(status: 0)
          word
        else
          nil
        end
      end
    end

    # search the query on the thesaurus.com and paste part of the
    # result.
    def lookup_thesaurus(query)
      query = normalize_query(query).gsub(/ /, '+')
      begin
        html = Nokogiri::HTML(open("http://thesaurus.com/browse/#{query}").read)
        html.css('.sep_top')[0].to_s.gsub(/<\/a>/, '').gsub(/<a[^>]+>/, '')
      rescue
        "none"
      end
    end

    private

    def normalize_query(query)
      query.downcase.gsub(/ +$/, '')
    end
  end
end
