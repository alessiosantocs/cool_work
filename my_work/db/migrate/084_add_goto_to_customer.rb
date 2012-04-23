class AddGotoToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :goto_url, :string
  end

  def self.down
    remove_column :customers, :goto_url
  end
end
