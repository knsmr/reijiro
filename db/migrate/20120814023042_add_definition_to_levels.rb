# -*- coding: utf-8 -*-
class AddDefinitionToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :definition, :string
    say "populating the word definition..."
    Level.all.each do |l|
      text = Item.where(entry: l.word).first.body
      text = text.sub(/^[^:]+: /,  '').gsub(/｛[^｝]+｝/, '')
      l.update_column(:definition, text)
    end
  end
end
