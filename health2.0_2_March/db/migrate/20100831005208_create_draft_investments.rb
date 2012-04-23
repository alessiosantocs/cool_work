class CreateDraftInvestments < ActiveRecord::Migration
  def self.up
    create_table :draft_investments do |t|
      t.string :agency
      t.integer :funding_amount
      t.string :funding_type
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :draft_investments
  end
end
