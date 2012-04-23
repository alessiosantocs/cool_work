class AddNewOrleans < ActiveRecord::Migration
  def self.up
    nwo = Region.create(:full_name => "New Orleans", :short_name => 'nwo', :active => true )
    #"Regions created."
    City.create(:short_name => "nwo", :full_name => "New Orleans", :region_id => nwo.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << nwo
    Venue.update_all_city_ids
  end

  def self.down
    nwo = City.find(:first, :conditions => "short_name='nwo'")
    nwo_r = Region.find(:first, :conditions => "short_name='nwo'")
    Venue.update_all("city_id=0", "city_id in (#{nwo.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(nwo_r)
    City.destroy_all "short_name in ('nwo')"
    Region.destroy_all "short_name in ('nwo')"
  end
end