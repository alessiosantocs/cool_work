class CreateInvestments < ActiveRecord::Migration
  def self.up
    create_table :investments do |t|
      t.belongs_to :company
      t.string :agency
      t.decimal :funding_amount
      t.date :funding_date
      t.string :funding_type

      t.timestamps
    end
  end

  def self.down
    drop_table :investments
  end
end
