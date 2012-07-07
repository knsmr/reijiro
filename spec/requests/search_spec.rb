# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'Word search' do
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

    within('.nav.pull-right') do
      fill_in 'query', with: "orbit\n"
    end
    page.should have_content 'Found and clipped!'
    page.should have_content 'Next (101)'
  end

  scenario 'search a word that is already clipped', js: true do
    Word.search('foobar')
    visit root_path

    within('.nav.pull-right') do
      fill_in 'query', with: "foobar\n"
    end
    page.should have_content 'Already clipped!'
    page.should have_content 'Next (101)'
  end

  scenario 'search a word that is not in Eijiro', js: true do
    Word.stub(:search) { nil }
    visit root_path

    within('.nav.pull-right') do
      fill_in 'query', with: "foobar\n"
    end
    page.should have_content 'Could not find the word'
  end
end
