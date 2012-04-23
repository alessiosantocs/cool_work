class AddNewEnglandRegion < ActiveRecord::Migration
  def self.up
    nwe = Region.create(:full_name => "New England", :short_name => 'nwe', :active => true )
    #"Regions created."
    City.create(:short_name => "nwe", :full_name => "New England", :region_id => nwe.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << nwe
    Venue.update_all_city_ids
  end

  def self.down
    nwe = City.find(:first, :conditions => "short_name='nwe'")
    nwe_r = Region.find(:first, :conditions => "short_name='nwe'")
    Venue.update_all("city_id=0", "city_id in (#{nwe.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(nwe_r)
    City.destroy_all "short_name in ('nwe')"
    Region.destroy_all "short_name in ('nwe')"
  end
end

