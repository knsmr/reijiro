# -*- coding: utf-8 -*-
require 'spec_helper'

#feature 'Check clips' do
#  include_context 'just created 100 clips'
#
#  scenario 'show top page with 100 due clips' do
#    visit root_path
#    page.should have_content 'Reijiro'
#    page.should have_content 'Next (100)'
#  end
#
#  scenario 'delete a word' do
#    visit root_path
#    page.should have_content 'Next (100)'
#
#    find('#show').click
#    click_link 'Delete'
#
#    page.should have_content 'Reijiro'
#    page.should have_content 'Next (99)'
#  end
#
#  scenario 'after checking a clip, next should be 99', js: true do
#    visit root_path
#    page.should have_content 'Next (100)'
#
#    find('#show').click
#    find('#next').click
#
#    page.should have_content 'Next (99)'
#  end
#
#  scenario 'after checking some clips, Done today shows the number', js: true do
#    visit root_path
#    page.should have_content 'Done today: 0'
#
#    find('#show').click
#    find('#next').click
#    sleep 2
#    find('#show').click
#    find('#next').click
#
#    page.should have_content 'Done today: 2'
#
#    Timecop.travel(Time.now + 1.day)
#    visit root_path
#    page.should have_content 'Done today: 0'
#  end
#
#  scenario 'after changing the status of a clip, next should be 99', js: true do
#    visit root_path
#    page.should have_content 'Next (100)'
#
#    find('#show').click
#    find('#status3').click
#
#    page.should have_content 'Next (99)'
#  end
#
#  scenario 'after cliking show button, word entry should be visible', js: true do
#    visit root_path
#
#    find('#definition').should_not be_visible
#    find('#show').click
#    find('#definition').should be_visible
#  end
#end
