# -*- coding: utf-8 -*-
require 'spec_helper'

#feature 'Check word' do
#  include_context 'just created 100 clips'
#
#  before do
#    @word = Word.search('apple')
#  end
#
#  scenario 'show the word page' do
#    visit word_path(@word)
#    page.should have_content 'Reijiro'
#    page.should have_content 'Next'
#    page.should have_content 'Done today'
#    page.should have_content 'Checked: '
#    page.should have_content 'Pronunciation'
#  end
#
#  scenario 'after checking the word, checked should be incremented', js: true do
#    visit word_path(@word)
#    find('#next').click
#    visit word_path(@word)
#    page.should have_content 'Checked: 1 times'
#
#    visit word_path(@word)
#    find('#next').click
#    visit word_path(@word)
#    page.should have_content 'Checked: 2 times'
#  end
#end
