class CreateKeywordStores < ActiveRecord::Migration
  def self.up
    create_table :keyword_stores do |t|
      t.text :keywords
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :keyword_stores
  end
end
