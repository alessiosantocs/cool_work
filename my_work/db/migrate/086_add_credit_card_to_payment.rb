class AddCreditCardToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :credit_card_id, :integer
  end

  def self.down
    remove_column :payments, :credit_card_id
  end
end
