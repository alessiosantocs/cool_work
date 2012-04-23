class AddLasVegasAndMiamiRegions < ActiveRecord::Migration
  def self.up
    City.find(:all).each{|c| c.update_attribute :short_name, c.short_name.downcase }
    mia = Region.create(:full_name => "Miami", :short_name => 'mia', :active => true )
    las = Region.create(:full_name => "Las Vegas", :short_name => 'las', :active => true )
    #"Regions created."
    City.create(:short_name => "mia", :full_name => "Miami", :region_id => mia.id, :active => true )
    City.create(:short_name => "las", :full_name => "Las Vegas", :region_id => las.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << [mia, las]
    Venue.update_all_city_ids
  end

  def self.down
    mia = City.find(:first, :conditions => "short_name='mia'")
    las = City.find(:first, :conditions => "short_name='las'")
    mia_r = Region.find(:first, :conditions => "short_name='mia'")
    las_r = Region.find(:first, :conditions => "short_name='las'")
    Venue.update_all("city_id=0", "city_id in (#{mia.id},#{las.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(las_r)
    atp.regions.delete(mia_r)
    City.destroy_all "short_name in ('mia', 'las')"
    Region.destroy_all "short_name in ('mia', 'las')"
    City.find(:all).each{|c| c.update_attribute :short_name, c.short_name.upcase }
  end
end
