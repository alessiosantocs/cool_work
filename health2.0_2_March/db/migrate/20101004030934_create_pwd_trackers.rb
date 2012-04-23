class CreatePwdTrackers < ActiveRecord::Migration
  def self.up
    create_table :pwd_trackers do |t|
      t.string :email
      t.string :urlKey

      t.timestamps
    end
  end

  def self.down
    drop_table :pwd_trackers
  end
end
