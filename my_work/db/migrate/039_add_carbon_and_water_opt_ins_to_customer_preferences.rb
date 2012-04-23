class AddCarbonAndWaterOptInsToCustomerPreferences < ActiveRecord::Migration
  def self.up
    add_column :customer_preferences, :my_fresh_water, :boolean
    add_column :customer_preferences, :my_fresh_air, :boolean
    add_column :customer_preferences, :wants_updates, :boolean
    add_column :customer_preferences, :wants_promotions, :boolean
    add_column :customer_preferences, :email_format, :string
    add_column :customer_preferences, :wants_minor_repairs, :boolean
    
  end

  def self.down
    remove_column :customer_preferences, :my_fresh_water
    remove_column :customer_preferences, :my_fresh_air
    remove_column :customer_preferences, :wants_updates
    remove_column :customer_preferences, :wants_promotions
    remove_column :customer_preferences, :email_format
    remove_column :customer_preferences, :wants_minor_repairs
  end
end
