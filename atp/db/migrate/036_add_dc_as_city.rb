class AddDcAsCity < ActiveRecord::Migration
  def self.up
    dca = Region.create(:full_name => "Washington, DC", :short_name => 'dca', :active => true )
    #"Regions created."
    City.create(:short_name => "dca", :full_name => "Washington, DC", :region_id => dca.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << dca
    Venue.update_all_city_ids
  end

  def self.down
    dca = City.find(:first, :conditions => "short_name='dca'")
    dca_r = Region.find(:first, :conditions => "short_name='dca'")
    Venue.update_all("city_id=0", "city_id in (#{dca.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(dca_r)
    City.destroy_all "short_name in ('dca')"
    Region.destroy_all "short_name in ('dca')"
  end
end
