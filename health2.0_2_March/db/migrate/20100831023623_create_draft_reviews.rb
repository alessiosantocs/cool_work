class CreateDraftReviews < ActiveRecord::Migration
  def self.up
    create_table :draft_reviews do |t|
      t.belongs_to :company
      t.boolean :accepted
      t.boolean :processed
      t.belongs_to :email_tracker

      t.timestamps
    end
  end

  def self.down
    drop_table :draft_reviews
  end
end
