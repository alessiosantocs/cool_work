class AddDenver < ActiveRecord::Migration
  def self.up
    den = Region.create(:full_name => "Denver", :short_name => 'den', :active => true )
    #"Regions created."
    City.create(:short_name => "den", :full_name => "Denver", :region_id => den.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << den
    Venue.update_all_city_ids
  end

  def self.down
    den = City.find(:first, :conditions => "short_name='den'")
    den_r = Region.find(:first, :conditions => "short_name='den'")
    Venue.update_all("city_id=0", "city_id in (#{den.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(den_r)
    City.destroy_all "short_name in ('den')"
    Region.destroy_all "short_name in ('den')"
  end
end
