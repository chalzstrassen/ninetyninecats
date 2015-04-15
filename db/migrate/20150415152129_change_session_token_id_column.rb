class ChangeSessionTokenIdColumn < ActiveRecord::Migration
  def change
    remove_column :users, :session_token
    add_column :users, :session_token, :string
    add_index :users, :session_token, unique: true
  end
end
