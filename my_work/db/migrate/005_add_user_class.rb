class AddUserClass < ActiveRecord::Migration
  def self.up
    add_column :users, :user_class, :string, :limit => 20
  end

  def self.down
    remove_column :users, :user_class
  end
end
