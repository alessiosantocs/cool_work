class AddPhilly < ActiveRecord::Migration
  def self.up
    phl = Region.create(:full_name => "Phillie", :short_name => 'phl', :active => true )
    #"Regions created."
    City.create(:short_name => "phl", :full_name => "Phillie", :region_id => phl.id, :active => true )
    #"Cities created."
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions << phl
    Venue.update_all_city_ids
    [:san, :pit, :phx].each do |node|
      city = City.find(:first, :conditions => "short_name='#{node}'")
      region = Region.find(:first, :conditions => "short_name='#{node}'")
      Venue.update_all("city_id=0", "city_id in (#{city.id})")
      atp = Site.find(:first, :conditions => "short_name='ATP'")
      atp.regions.delete(region)
      City.destroy_all "short_name in ('#{node}')"
      Region.destroy_all "short_name in ('#{node}')"
    end
  end

  def self.down
    [:san, :pit, :phx].each do |node|
      name = {
        :san => "San Diego",
        :pit => "Pittsburgh",
        :phx => "Phoenix"
      }
      city = Region.create(:full_name => name[node], :short_name => node.to_s, :active => true )
      #"Regions created."
      City.create(:short_name => city.short_name, :full_name => name[node], :region_id => city.id, :active => true )
      #"Cities created."
      atp = Site.find(:first, :conditions => "short_name='ATP'")
      atp.regions << city
    end
    Venue.update_all_city_ids
    
    phl = City.find(:first, :conditions => "short_name='phl'")
    phl_r = Region.find(:first, :conditions => "short_name='phl'")
    Venue.update_all("city_id=0", "city_id in (#{phl.id})")
    atp = Site.find(:first, :conditions => "short_name='ATP'")
    atp.regions.delete(phl_r)
    City.destroy_all "short_name in ('phl')"
    Region.destroy_all "short_name in ('phl')"
  end
end
