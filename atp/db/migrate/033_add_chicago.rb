class AddChicago < ActiveRecord::Migration
  def self.up
    chi = Region.create(:full_name => "Chicago", :short_name => 'chi', :active => true )
    #"Regions created."
    City.create(:short_name => "chi", :full_name => "Chicago", :region_id => chi.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << chi
    Venue.update_all_city_ids
  end

  def self.down
    chi = City.find(:first, :conditions => "short_name='chi'")
    chi_r = Region.find(:first, :conditions => "short_name='chi'")
    Venue.update_all("city_id=0", "city_id in (#{chi.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(chi_r)
    City.destroy_all "short_name in ('chi')"
    Region.destroy_all "short_name in ('chi')"
  end
end