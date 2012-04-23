class AddColumnToDraftPartnerships < ActiveRecord::Migration
  def self.up
    add_column :draft_partnerships, :company_id, :integer
  end

  def self.down
    remove_column :draft_partnerships, :company_id
  end
end
