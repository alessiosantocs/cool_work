class AddPitAsACity < ActiveRecord::Migration
  def self.up
    pit = Region.create(:full_name => "Pittsburgh", :short_name => 'pit', :active => true )
    #"Regions created."
    City.create(:short_name => "pit", :full_name => "Pittsburgh", :region_id => pit.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << pit
    Venue.update_all_city_ids
  end

  def self.down
    pit = City.find(:first, :conditions => "short_name='pit'")
    pit_r = Region.find(:first, :conditions => "short_name='pit'")
    Venue.update_all("city_id=0", "city_id in (#{pit.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(pit_r)
    City.destroy_all "short_name in ('pit')"
    Region.destroy_all "short_name in ('pit')"
  end
end
