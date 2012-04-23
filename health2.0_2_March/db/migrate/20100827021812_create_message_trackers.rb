class CreateMessageTrackers < ActiveRecord::Migration
  def self.up
    create_table :message_trackers do |t|
      t.belongs_to :email_tracker
      t.belongs_to :company
      t.boolean :answered
      t.string :url_key
      t.boolean :send_success

      t.timestamps
    end
  end

  def self.down
    drop_table :message_trackers
  end
end
