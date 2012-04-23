class AddSanDiego < ActiveRecord::Migration
  def self.up
    san = Region.create(:full_name => "San Diego", :short_name => 'san', :active => true )
    #"Regions created."
    City.create(:short_name => "san", :full_name => "San Diego", :region_id => san.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << san
    Venue.update_all_city_ids
  end

  def self.down
    san = City.find(:first, :conditions => "short_name='san'")
    san_r = Region.find(:first, :conditions => "short_name='san'")
    Venue.update_all("city_id=0", "city_id in (#{san.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(san_r)
    City.destroy_all "short_name in ('san')"
    Region.destroy_all "short_name in ('san')"
  end
end
