class AddDallas < ActiveRecord::Migration
  def self.up
    dal = Region.create(:full_name => "Dallas", :short_name => 'dal', :active => true )
    #"Regions created."
    City.create(:short_name => "dal", :full_name => "Dallas", :region_id => dal.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << dal
    Venue.update_all_city_ids
  end

  def self.down
    dal = City.find(:first, :conditions => "short_name='dal'")
    dal_r = Region.find(:first, :conditions => "short_name='dal'")
    Venue.update_all("city_id=0", "city_id in (#{dal.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(dal_r)
    City.destroy_all "short_name in ('dal')"
    Region.destroy_all "short_name in ('dal')"
  end
end
