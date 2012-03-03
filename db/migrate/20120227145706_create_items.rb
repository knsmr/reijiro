class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :entry
      t.text :body
    end
  end
end
