# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'Check clips' do
  background do
    create_list(:clip, 100)
    Word.stub(:lookup_thesaurus) { "none" }
    Word.stub(:search) do |query|
      c = create :clip
      c.word.update_attribute(:entry, query)
      c.word
    end
  end

  scenario 'show top page with 100 due clips' do
    visit root_path
    page.should have_content 'Reijiro'
    page.should have_content 'Next (100)'
  end

  scenario 'delete a word' do
    visit root_path
    page.should have_content 'Next (100)'

    find('#show').click
    click_link 'Delete'

    page.should have_content 'Reijiro'
    page.should have_content 'Next (99)'
  end

  scenario 'after checking a clip, next should be 99', js: true do
    visit root_path
    page.should have_content 'Next (100)'

    find('#show').click
    find('#next').click

    page.should have_content 'Next (99)'
  end

  scenario 'after changing the status of a clip, next should be 99', js: true do
    visit root_path
    page.should have_content 'Next (100)'

    find('#show').click
    find('#status3').click

    page.should have_content 'Next (99)'
  end

  scenario 'after cliking show button, word entry should be visible', js: true do
    visit root_path

    find('#definition').should_not be_visible
    find('#show').click
    find('#definition').should be_visible
  end
end
