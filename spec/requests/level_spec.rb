# -*- coding: utf-8 -*-
require 'spec_helper'

#feature 'Clip words in a given level' do
#  include_context 'just created 100 clips'
#
#  scenario 'level 1 should have 6 words', js: true do
#    # see spec/fixtures/levels.yml
#    visit root_path
#
#    click_link 'Levels'
#    within('.level-box') do
#      click_link 'このレベルの単語'
#    end
#
#    sleep 1   # wait for the background task to complete
#    page.should have_selector '.word', count: 6
#  end
#
#  scenario 'clip one word at a time', js: true do
#    # see: spec/fixtures/levels.yml
#    visit root_path
#    click_link 'Levels'
#    within('.level-box') do
#      click_link 'このレベルの単語'
#    end
#
#    find('.word .entry').should have_content "apple"
#    find('.clip').click
#    sleep 3
#    find('.word .entry').should_not have_content "apple"
#
#    Clip.next_list.should have(101).words # should have increased
#  end
#
#  scenario 'mark a word as known', js: true do
#    visit root_path
#    click_link 'Levels'
#    within('.level-box') do
#      click_link 'このレベルの単語'
#    end
#
#    find('.word .entry').should have_content "apple"
#    find('.known').click
#    sleep 3
#    find('.word .entry').should_not have_content "apple"
#
#    Clip.next_list.should have(100).words # does not change
#  end
#end
