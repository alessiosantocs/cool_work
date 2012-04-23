class AddTelephoneToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :telephone_number, :string
  end

  def self.down
    remove_column :customers, :telephone_number
  end
end
