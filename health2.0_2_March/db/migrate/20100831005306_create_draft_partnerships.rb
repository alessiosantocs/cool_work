class CreateDraftPartnerships < ActiveRecord::Migration
  def self.up
    create_table :draft_partnerships do |t|
      t.string :name
      t.text :description
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :draft_partnerships
  end
end
