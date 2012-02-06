class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :entry
      t.integer :level, default: 0
      t.text :def

      t.timestamps
    end
  end
end
