# -*- coding: utf-8 -*-
require "spec_helper"

describe WordsHelper do
  describe "#remove_yomigana" do
    it "removes yomigana from the definition string" do
      str = "■akin {形} : 血族｛けつぞく｝の、同族｛どうぞく｝の、同種｛どうしゅ｝の"
      helper.send(:remove_yomigana, str).should eq("■akin {形} : 血族の、同族の、同種の")
    end
  end

  describe "#preprocess" do
    let(:with_underscore) { create(:word, :underscore) }
    let(:without_underscore) { create(:word, :no_underscore) }
    let(:with_underscore_for_definition) { create(:word, :underscore_for_definition) }

    context "word_with_underscore" do
      it "description has 5 lines" do
        helper.preprocess(with_underscore).split("\n").should have(5).items
      end

      it "description has 2 definition entries" do
        helper.preprocess(with_underscore).split("\n").grep(/word-definition/).should have(2).items
      end

      it "insert underscore class" do
        helper.preprocess(with_underscore).should include("underscore")
      end
    end

    context "word_with_underscore_for_definition" do
      it "description has 3 lines" do
        helper.preprocess(with_underscore_for_definition).split("\n").should have(3).items
      end

      it "insert underscore class" do
        helper.preprocess(with_underscore_for_definition).should include("underscore")
      end
    end

    context "word_without_underscore" do
      it "description has 5 lines" do
        helper.preprocess(without_underscore).split("\n").should have(5).items
      end

      it "description has 2 definition entries" do
        helper.preprocess(with_underscore).split("\n").grep(/word-definition/).should have(2).items
      end

      it "does not insert underscore class" do
        helper.preprocess(without_underscore).should_not include("underscore")
      end
    end
  end
end
