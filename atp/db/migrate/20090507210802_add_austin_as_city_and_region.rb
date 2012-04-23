class AddAustinAsCityAndRegion < ActiveRecord::Migration
  def self.up
    aus = Region.create(:full_name => "Austin", :short_name => 'aus', :active => true )
    #"Regions created."
    City.create(:short_name => "aus", :full_name => "Austin", :region_id => aus.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << aus
    Venue.update_all_city_ids
  end

  def self.down
    aus = City.find(:first, :conditions => "short_name='aus'")
    aus_r = Region.find(:first, :conditions => "short_name='aus'")
    Venue.update_all("city_id=0", "city_id in (#{aus.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(aus_r)
    City.destroy_all "short_name in ('aus')"
    Region.destroy_all "short_name in ('aus')"
  end
end
