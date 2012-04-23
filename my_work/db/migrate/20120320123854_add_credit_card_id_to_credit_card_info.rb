class AddCreditCardIdToCreditCardInfo < ActiveRecord::Migration
  def self.up
    add_column :credit_card_infos, :credit_card_id, :integer
  end

  def self.down
    remove_column :credit_card_infos, :credit_card_id
  end
end
