class AddPartyLastTimeCron < ActiveRecord::Migration
  def self.up
    add_column "parties", "last_time_cron", :datetime
  end

  def self.down
    remove_column "parties", "last_time_cron"
  end
end
