class CreateInverts < ActiveRecord::Migration
  def change
    create_table :inverts do |t|
      t.string :token
      t.references :item
    end
  end
end
