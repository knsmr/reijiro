# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :word do
    entry "apple"
    definition "■apple : りんご"

    factory :word_with_hightlight do
      definition <<-STR
      ■apple : りんご
      @■apple : 大都市
      ■apple : 野球ボール
      STR
    end
  end
end
