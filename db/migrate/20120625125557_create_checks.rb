class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :word
      t.integer :oldstat
      t.integer :newstat

      t.timestamps
    end
    add_index :checks, :word_id
  end
end
