class AugmentOrderForPaymentGateway < ActiveRecord::Migration
  def self.up
    add_column :orders, :amount, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :orders, :amount
  end
end
