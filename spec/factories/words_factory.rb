# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :word do
    sequence(:entry) {|n| "word#{n}"}
    level 0
    definition "■apple : りんご"

    trait :underscore do
      definition <<-STR
■apple  {名-1} : リンゴ
■apple  {名-2} : 〈俗〉《野球》ボール
@■apple : 大都市
■apple core : リンゴの芯
■Apple  {人名} : アプル
      STR
    end

    trait :no_underscore do
      definition <<-STR
■apple  {名-1} : リンゴ
■apple  {名-2} : 〈俗〉《野球》ボール
■apple : 大都市
■apple core : リンゴの芯
■Apple  {人名} : アプル
      STR
    end
  end
end
