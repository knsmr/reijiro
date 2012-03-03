class RemoveTimestampsFromWord < ActiveRecord::Migration
  def up
    remove_column :words, :created_at
    remove_column :words, :updated_at
  end

  def down
    add_column :words, :updated_at, :datetime
    add_column :words, :created_at, :datetime
  end
end
