class CreateDraftCompanies < ActiveRecord::Migration
  def self.up
    create_table :draft_companies do |t|
      t.string :name
      t.string :url
      t.date :founded
      t.integer :employee_number
      t.string :market_segment
      t.text :description
      t.text :private_notes
      t.boolean :enabled
      t.belongs_to :draft_review

      t.timestamps
    end
  end

  def self.down
    drop_table :draft_companies
  end
end
