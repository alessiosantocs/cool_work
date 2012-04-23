class AddFieldsToBillingProfile < ActiveRecord::Migration
  def self.up
    add_column "billing_profiles", "billingid", :string, :limit => 6
    add_column "orders", "billingid", :string, :limit => 6
    add_column "orders", "transid", :string, :limit => 14
    add_column "orders", "currency", :string, :limit => 3
    add_column "orders", "taxes", :integer, :limit => 5
    remove_column "orders", "void_confirmation_number"
    remove_column "orders", "notes"
    remove_column "orders", "payment_status"
    change_column "orders", "total", :integer, :limit => 7
    remove_column "billing_profiles", "title"
    remove_column "billing_profiles", "primary_profile"
    add_column "billing_profiles", "position", :integer, :limit => 1
  end

  def self.down
    remove_column "billing_profiles", "billingid"
    remove_column "orders", "billingid"
    remove_column "orders", "transid"
    remove_column "orders", "currency"
    remove_column "orders", "taxes"
    add_column "orders", "void_confirmation_number", :string, :limit => 12
    add_column "orders", "notes", :text
    add_column "orders", "payment_status", :string, :limit => 12
    change_column "orders", "total", :float
    add_column "billing_profiles", "title", :string, :limit => 25
    add_column "billing_profiles", "primary_profile", :boolean
    remove_column "billing_profiles", "position"
  end
end
