class Clip < ActiveRecord::Base
  belongs_to :word
  validates_uniqueness_of :word_id
end
