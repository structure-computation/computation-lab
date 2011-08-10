class AddColumnUsernameToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :username, :string
  end

  def self.down
    remove_column :posts, :username
  end
end
