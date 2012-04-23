class AddTimesUsableToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :times_usable_per_user, :int, :default => 1
  end

  def self.down
    remove_column :promotions, :times_usable_per_user
  end
end
