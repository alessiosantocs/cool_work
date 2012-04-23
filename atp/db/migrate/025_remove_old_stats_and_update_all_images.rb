class RemoveOldStatsAndUpdateAllImages < ActiveRecord::Migration
  def self.up
    Stat.remove_old
    Image.update_all "comments_allowed = 1"
  end

  def self.down
  end
end
