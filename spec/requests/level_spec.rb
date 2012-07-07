# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'Level import' do
  background do
    create_list(:clip, 100)
    Word.stub(:lookup_thesaurus) { "none" }
    Word.stub(:search) do |query|
      c = create :clip
      c.word.update_attribute(:entry, query)
      c.word
    end
  end

  scenario 'search a new word', js: true do
    visit root_path
    click_link 'Levels'
    click_link 'level1'
    click_link 'Levels'
    click_link 'level1'
    visit levels_path
    page.should have_content 'Reijiro'
  end
end
