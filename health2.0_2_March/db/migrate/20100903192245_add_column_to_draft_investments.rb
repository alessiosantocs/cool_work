class AddColumnToDraftInvestments < ActiveRecord::Migration
  def self.up
    add_column :draft_investments, :funding_date, :date
  end

  def self.down
    remove_column :draft_investments, :funding_date
  end
end
