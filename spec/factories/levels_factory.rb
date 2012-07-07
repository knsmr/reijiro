# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :level do
    sequence(:word) {|n| "word#{n}"}
    level { rand(12) }
  end
end
