class AddSecurityCodeToCreditCard < ActiveRecord::Migration
  def self.up
    add_column :credit_cards, :security_code, :string
  end

  def self.down
    remove_column :credit_cards, :security_code
  end
end
