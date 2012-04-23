class AddColumnToEmailTracker < ActiveRecord::Migration
  def self.up
    add_column :email_trackers, :subject, :string
  end

  def self.down
    remove_column :email_trackers, :subject
  end
end
