class DropGreensboro < ActiveRecord::Migration
  def self.up
    gso = City.find(:first, :conditions => "short_name='gso'")
    gso_r = Region.find(:first, :conditions => "short_name='gso'")
    Venue.update_all("city_id=0", "city_id in (#{gso.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(gso_r)
    City.destroy_all "short_name in ('gso')"
    Region.destroy_all "short_name in ('gso')"
  end

  def self.down
    raise "Can't down shift, baby!"
  end
end
