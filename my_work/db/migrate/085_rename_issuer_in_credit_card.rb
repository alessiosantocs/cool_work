class RenameIssuerInCreditCard < ActiveRecord::Migration
  def self.up
    rename_column :credit_cards, :issuer, :payment_method
  end

  def self.down
    rename_column :credit_cards, :payment_method, :issuer
  end
end
