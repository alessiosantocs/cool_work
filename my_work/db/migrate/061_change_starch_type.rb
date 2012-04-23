class ChangeStarchType < ActiveRecord::Migration
  def self.up
    change_column :customer_preferences, :ls_starch, :boolean, :default => true
    change_column :customer_preferences, :ls_press, :boolean, :default => true
    change_column :customer_preferences, :dc_starch, :boolean, :default => true
    change_column :customer_preferences, :dc_press, :boolean, :default => true
  end
  
  def self.down
    change_column :customer_preferences, :ls_starch, :string
    change_column :customer_preferences, :ls_press, :string
    change_column :customer_preferences, :dc_starch, :string
    change_column :customer_preferences, :dc_press, :string
  end
end
