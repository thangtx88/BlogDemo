class AddReferencesAndIndexToEntries< ActiveRecord::Migration
  def change
      add_reference :users, :entry, index: true, foreign_key: true
      add_index :entries, [:user_id, :created_at]
    end
end


