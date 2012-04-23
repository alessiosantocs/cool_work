class CreateEmailTrackers < ActiveRecord::Migration
  def self.up
    create_table :email_trackers do |t|
      t.string :message
      t.string :return_email

      t.timestamps
    end
  end

  def self.down
    drop_table :email_trackers
  end
end
