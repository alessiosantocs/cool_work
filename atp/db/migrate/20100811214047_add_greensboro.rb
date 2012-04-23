class AddGreensboro < ActiveRecord::Migration
  def self.up
    gso = Region.create(:full_name => "Greensboro, NC", :short_name => 'gso', :active => true )
    #"Regions created."
    City.create(:short_name => "gso", :full_name => "Greensboro, NC", :region_id => gso.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << gso
    Venue.update_all_city_ids
  end

  def self.down
    gso = City.find(:first, :conditions => "short_name='gso'")
    gso_r = Region.find(:first, :conditions => "short_name='gso'")
    Venue.update_all("city_id=0", "city_id in (#{gso.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(gso_r)
    City.destroy_all "short_name in ('gso')"
    Region.destroy_all "short_name in ('gso')"
  end
end
