class CreateProfits < ActiveRecord::Migration
  def self.up
    create_table :profits do |t|
      t.integer :year
      t.date :date_launched
      #t.Company :belongs_to
      t.decimal :amount
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :profits
  end
end
