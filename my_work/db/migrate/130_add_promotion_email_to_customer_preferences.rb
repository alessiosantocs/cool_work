class AddPromotionEmailToCustomerPreferences < ActiveRecord::Migration
  def self.up
    add_column :customer_preferences, :promotion_email, :boolean, :default => true
  end

  def self.down
    remove_column :customer_preferences, :promotion_email
  end
end
