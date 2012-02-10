class WordFixColumnName < ActiveRecord::Migration
  def up
    rename_column :words, :def, :definition
  end

  def down
    rename_column :words, :definition, :def
  end
end
