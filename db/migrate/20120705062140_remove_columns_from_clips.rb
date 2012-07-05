class RemoveColumnsFromClips < ActiveRecord::Migration
  def up
    remove_column :clips, :shown
    remove_column :clips, :nextup
  end

  def down
    add_column :clips, :shown, :integer, default: 0
    add_column :clips, :nextup, :boolean, default: false
  end
end
