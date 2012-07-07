# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clip do
  let!(:clips) { create_list(:clip, 10) }

  it "all clips are overdue" do
    Clip.overdue_count.should == 10
  end

  it "can pick up the next clip" do
    Clip.next_clip.should be_a_kind_of(Clip)
  end

  context "when the status of a clip changes" do
    before do
      clip = clips.last
      clip.update_attribute(:status, 1)
    end

    it "reduces the number of overdue clips" do
      Clip.overdue_count.should == 9
    end
  end

  context "when all clips are done" do
    before do
      clips.map {|c| c.update_attribute(:status, 8)}
    end

    it "yields no clips" do
      Clip.next_clip.should be_nil
    end

    it "yields no overdue clips" do
      Clip.overdue_count.should == 0
    end
  end
end
