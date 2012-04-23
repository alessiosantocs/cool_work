class PolymorphicUserUpdate < ActiveRecord::Migration
  def self.up
    add_column :users, :account_id, :integer
    add_column :users, :account_type, :string
  end

  def self.down
    remove_column :users, :account_id
    remove_column :users, :account_type
  end
end
