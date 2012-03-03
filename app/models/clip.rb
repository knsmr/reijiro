class Clip < ActiveRecord::Base
  belongs_to :word
  validates_uniqueness_of :word_id
  INTERVAL = {
    0 => 0.second,
    1 => 1.day,
    2 => 3.days,
    3 => 1.week,
    4 => 2.weeks,
    5 => 1.month,
    6 => 2.months,
    7 => 4.months,
    8 => 8.months
  }

  default_scope order('updated_at DESC')
  scope :done, where('status == 8')  # I'm done with the word!
  scope :undone, where('status != 8')  # I'm done with the word!

  scope :overdue, lambda{|status| where('status = ? AND updated_at < ?', status, Time.now - INTERVAL[status])}

  class << self
    def overdue_count
      (0..7).inject(0){|acc, s| acc += Clip.overdue(s).count}
    end
  end
end
