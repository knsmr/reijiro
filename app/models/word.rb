class Word < ActiveRecord::Base
  has_one :clip, dependent: :destroy
  default_scope order('updated_at DESC')
end
