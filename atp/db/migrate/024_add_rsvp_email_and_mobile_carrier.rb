class AddRsvpEmailAndMobileCarrier < ActiveRecord::Migration
  def self.up
    add_column :parties, :rsvp_email, :string, :limit => 65, :default => ''
    add_column :users, :mobile_carrier, :string, :limit => 16
    add_column :bookings, :source, :string, :limit => 16
    Party.find(:all, :include => [:user]).each do |p|
      execute "UPDATE parties SET rsvp_email='#{p.user.email}' where id=#{p.id}"
    end
  end

  def self.down
    remove_column :parties, :rsvp_email
    remove_column :users, :mobile_carrier
    remove_column :bookings, :source
  end
end
