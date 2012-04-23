class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.integer :customer_id
      t.string :issuer, :last_four_digits, :name, :payment_profile_id
      t.boolean :default
      t.timestamps
    end
    add_column :customers, :authdotnet_profile_id, :string
  end

  def self.down
    drop_table :credit_cards
    remove_column :customers, :authdotnet_profile_id
  end
end
