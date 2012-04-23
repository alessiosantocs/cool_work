class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.column :amount, :decimal, :precision => 8, :scale => 2
      t.string :transaction_id, :status
      t.datetime :expiry
      t.integer :order_id
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
