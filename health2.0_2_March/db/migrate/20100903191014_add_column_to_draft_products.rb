class AddColumnToDraftProducts < ActiveRecord::Migration
  def self.up
    add_column :draft_products, :company_id, :integer
  end

  def self.down
    remove_column :draft_products, :company_id
  end
end
