class Check < ActiveRecord::Base
  belongs_to :word
  attr_accessible :newstat, :oldstat, :word_id

  class << self
    def check_months
      checks = Check.find(:all, :order => 'created_at')
      checks.group_by {|t| t.created_at.to_date}
    end
  end
end
