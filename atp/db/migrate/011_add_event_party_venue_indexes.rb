class AddEventPartyVenueIndexes < ActiveRecord::Migration
  def self.up
    add_index :events, [:party_id, :venue_id, :search_date, :active, :image_sets_count], :name => "idx_evt", :unique => false
    add_index :venues, [:city_id, :active, :user_id, :postal_code], :name => "idx_ven", :unique => false
    add_index :parties, [:user_id, :venue_id, :current_event_id, :recur, :premium, :active],  :name => "idx_par", :unique => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
