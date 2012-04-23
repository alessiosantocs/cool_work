class AddPhxAsCity < ActiveRecord::Migration
  def self.up
    phx = Region.create(:full_name => "Phoenix", :short_name => 'phx', :active => true )
    #"Regions created."
    City.create(:short_name => "phx", :full_name => "Phoenix", :region_id => phx.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << phx
    Venue.update_all_city_ids
  end

  def self.down
    phx = City.find(:first, :conditions => "short_name='phx'")
    phx_r = Region.find(:first, :conditions => "short_name='phx'")
    Venue.update_all("city_id=0", "city_id in (#{phx.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(phx_r)
    City.destroy_all "short_name in ('phx')"
    Region.destroy_all "short_name in ('phx')"
  end
end