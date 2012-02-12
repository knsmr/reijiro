class AddIndexToWord < ActiveRecord::Migration
  def change
    add_index :words, :updated_at
  end
end
