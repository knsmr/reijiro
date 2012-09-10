class AddKnownToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :known, :boolean, default: false
  end
end
