# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'show stats' do
  background do
    create_list(:clip, 100)
  end

  scenario 'show top page with 100 due clips' do
    visit root_path
    page.should have_content 'Reijiro'
    page.should have_content 'Next (100)'
  end

  scenario 'show stats page' do
    visit stats_path
    page.should have_content 'Statistics'
  end
end
