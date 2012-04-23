class CreateCreditCardInfos < ActiveRecord::Migration
  def self.up
    create_table :credit_card_infos do |t|
      t.string :card_number
      t.string :payment_card_method
      t.integer :order_id
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :credit_card_infos
  end
end
