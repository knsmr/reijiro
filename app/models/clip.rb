class Clip < ActiveRecord::Base
  belongs_to :word
  validates_uniqueness_of :word_id

  default_scope order(:updated_at)
end
