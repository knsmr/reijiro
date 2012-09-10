class Clip < ActiveRecord::Base
  belongs_to :word
  validates_uniqueness_of :word_id
  INTERVAL = {
    0 => 0.second,
    1 => 1.day,
    2 => 2.days,
    3 => 4.days,
    4 => 1.week,
    5 => 2.weeks,
    6 => 1.month,
    7 => 2.months,
    8 => 4.months
  }

  default_scope order('updated_at DESC')
  scope :done, where('status == 8')  # I'm done with the word!
  scope :undone, where('status != 8')  # Still working on it!
  scope :level, lambda{|level| joins(:word).where('words.level == ?', level)}

  scope :overdue, lambda{|status| where('status = ? AND updated_at < ?', status, Time.now - INTERVAL[status])}

  class << self
    def overdue_count
      (0..7).inject(0){|acc, s| acc += Clip.overdue(s).count}
    end

    def next_clip
      # TODO: create status table?
      clip = nil
      (0..7).each do |status|
        clip = Clip.overdue(status).first
        break unless clip.blank?
      end
      clip ? clip : nil
    end

    def next_list
      next_ids = []
      (0..7).each do |status|
        next_ids << Clip.overdue(status).map(&:word_id)
      end
      Word.joins(:clip).where('words.id IN (?)', next_ids.flatten).order('clips.status ASC').order('clips.updated_at DESC')
    end

    def stats
      stats = {}
      (1..12).each do |l|
        undone = Clip.level(l).undone.count
        done   = Clip.level(l).done.count + Level.where(level: l).known.count
        total  = Level.where(level: l).count
        remain = total - (undone + done)
        stats[l] = {undone: undone, done: done, total: total, remain: remain}
      end

      stats['0'] = {
        undone: Clip.level(0).count,
        done: Clip.level(0).done.count,
        total: Clip.level(0).count,
        remain: 0
      }

      stats['total'] = {
        undone: Clip.undone.count,
        done: Clip.done.count,
        ramin: Level.count - Clip.count,
        total: Level.count }

      stats
    end
  end
end
