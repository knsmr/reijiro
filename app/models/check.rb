class Check < ActiveRecord::Base
  belongs_to :word
  attr_accessible :newstat, :oldstat, :word_id

  scope :today, lambda{ where('created_at > ?', Time.now.beginning_of_day + 3.hours) }

  class << self
    def check_months
      checks = Check.find(:all, :order => 'created_at')
      checks.group_by {|t| t.created_at.to_date}
    end
  end
end
