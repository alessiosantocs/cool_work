class RenameTracker2fave < ActiveRecord::Migration
  def self.up
    rename_table :trackers, :faves
  end

  def self.down
    rename_table :faves, :trackers
  end
end
