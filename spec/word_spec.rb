# -*- coding: utf-8 -*-
require 'spec_helper'

describe Word do
  let(:apple) { build(:word, entry: 'apple') }
  let(:banana) { build(:word, entry: 'banana') }
  let(:no_entry) { build(:word, entry: '') }

  it "can be saved successfully" do
    apple.save.should be_true
  end

  it "can't be saved without entry" do
    no_entry.save.should be_false
  end

  describe "set the level value" do
    it "sets an integer value as a level" do
      apple.level.should be_a_kind_of(Fixnum)
    end

    it "sets 1 as a level for the word apple" do
      apple.save
      apple.level.should == 1
    end

    it "sets 2 as a level for the word banana" do
      banana.save
      banana.level.should == 2
    end
  end

  describe "#lookup" do
    let(:definition) { Word.lookup('apple') }

    it "returns definition including some expressions using apple" do
      definition.should include("アレルギー")
      definition.should include("主要関心事")
    end
  end
end
