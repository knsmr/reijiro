class AddThesaurusToWord < ActiveRecord::Migration
  def change
    add_column :words, :thesaurus, :string, :default => "none"
  end
end
