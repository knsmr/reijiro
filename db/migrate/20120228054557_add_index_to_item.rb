class AddIndexToItem < ActiveRecord::Migration
  def change
    add_index :items, :entry
  end
end
