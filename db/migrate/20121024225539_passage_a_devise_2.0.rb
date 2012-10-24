class PassageADevise2 < ActiveRecord::Migration
  def up
    add_column      :users, :reset_password_sent_at , :datetime
    add_column      :users, :unconfirmed_email      , :string
    remove_columns  :users, :remember_token
  end

  def down
  end
end

