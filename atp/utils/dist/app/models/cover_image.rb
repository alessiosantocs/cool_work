class CoverImage < ActiveRecord::Base
  belongs_to :image
  belongs_to :site
  belongs_to :city
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def self.site_and_region(site, region, active=true)
    city_list = region.cities.collect{|c| c.id }.join(',')
    find(:all, :conditions => [" site_id=? AND city_id in (?) and active=?", site.id, city_list, active])
  end
  
  validates_presence_of :image_id
end