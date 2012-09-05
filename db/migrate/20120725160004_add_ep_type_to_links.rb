class AddEpTypeToLinks < ActiveRecord::Migration
  def self.up
    add_column    :links        , :Ep_type    , :integer               #précharge normale
  end

  def self.down
  end
end
