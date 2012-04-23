class AddLaxAsCity < ActiveRecord::Migration
  def self.up
    lax = Region.create(:full_name => "Los Angeles", :short_name => 'lax', :active => true )
    #"Regions created."
    City.create(:short_name => "lax", :full_name => "Los Angeles", :region_id => lax.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << lax
    Venue.update_all_city_ids
  end

  def self.down
    lax = City.find(:first, :conditions => "short_name='lax'")
    lax_r = Region.find(:first, :conditions => "short_name='lax'")
    Venue.update_all("city_id=0", "city_id in (#{lax.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(lax_r)
    City.destroy_all "short_name in ('lax')"
    Region.destroy_all "short_name in ('lax')"
  end
end
