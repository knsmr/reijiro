# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'Clip words in a level' do
  background do
    create_list(:clip, 100)
    Word.stub(:lookup_thesaurus) { "none" }
    Word.stub(:search) do |query|
      c = create :clip
      c.word.update_attribute(:entry, query)
      c.word
    end
  end

  scenario 'after cliping 5 words, next should increase by 5', js: true do
    visit root_path
    click_link 'Levels'
    click_link 'level1'

    page.should have_content 'Importing'
    sleep 5   # wait for the background task to complete
    visit root_path
    page.should have_content 'Next (105)'
  end

  scenario 'try to clip more words when the remaining isn not enough', js: true do
    visit root_path

    click_link 'Levels'
    click_link 'level1'
    sleep 5   # wait for the background task to complete

    click_link 'Levels'
    click_link 'level1'
    sleep 5   # wait for the background task to complete

    page.should have_content 'No more level'
    # Since there are only 6 words in this case.
    page.should have_content 'Next (106)'
  end

  scenario 'clip one word at a time', js: true do
    visit root_path
    click_link 'Levels'
    within('.level-box') do
      click_link '全単語'
    end
    # see: spec/fixtures/levels.yml
    check 'vanish'
    check 'turnout'
    sleep 1
    click_button 'import'

    page.should have_content 'Imported 2 words'
    page.should have_content 'vanish'
    page.should have_content 'turnout'
    page.should have_content 'Next (102)'
  end

  scenario 'import words', js: true do
    visit root_path
    click_link 'Levels'
    click_link 'level1'
    click_link 'Levels'
    click_link 'level1'
    sleep 5 # Wait for the background task to complete
    visit levels_path
    page.should have_content 'Reijiro'
    page.should have_css('.level-box')
    page.should have_content 'No more words.'
  end
end
