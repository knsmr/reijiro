class AddIndexToInvert < ActiveRecord::Migration
  def change
    add_index :inverts, :token
  end
end
