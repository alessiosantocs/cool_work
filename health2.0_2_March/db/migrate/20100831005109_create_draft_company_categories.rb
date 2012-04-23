class CreateDraftCompanyCategories < ActiveRecord::Migration
  def self.up
    create_table :draft_company_categories do |t|
      t.belongs_to :category
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :draft_company_categories
  end
end
