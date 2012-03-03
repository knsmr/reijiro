class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :word
      t.integer :level
    end
    add_index :levels, :word
  end
end
