class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.integer :word_id
      t.integer :status, default: 0
      t.boolean :nextup, default: false
      t.integer :shown, default: 0

      t.timestamps
    end
  end
end
