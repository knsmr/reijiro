# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clip, "10 clips are created now" do
  let!(:clips) { create_list(:clip, 10) }

  it "all clips are overdue" do
    Clip.overdue_count.should == 10
  end

  it "can pick up the next clip" do
    Clip.next_clip.should be_a_kind_of(Clip)
  end

  context "when the statuses of clips change" do
    before do
      clips[0].update_attribute(:status, 1)
      clips[1].update_attribute(:status, 2)
      clips[2].update_attribute(:status, 3)
    end

    it " has got 7 words in next list" do
      Clip.next_list.should have(7).words
    end

    it "reduces the number of overdue clips" do
      Clip.overdue_count.should == 7
    end

    context "after a day" do
      it "state 2, 3 clip will remain not overdue" do
        expect { Timecop.travel(Time.now + 1.day) }.to change {
          Clip.overdue_count }.to(8)
      end
    end

    context "after 3 days" do
      it "only state 3 clip will remain not overdue" do
        expect { Timecop.travel(Time.now + 3.days) }.to change {
          Clip.overdue_count }.to(9)
      end
    end

    context "after 2 weeks" do
      it "all clips will be overdue again" do
        expect { Timecop.travel(Time.now + 2.weeks) }.to change {
          Clip.overdue_count }.to(10)
      end
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
