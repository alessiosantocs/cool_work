class CoverImage < ActiveRecord::Base
  belongs_to :image
  belongs_to :site
  belongs_to :city
  
  class << self
    def blank(options={})
      new({
        :active => true
      }.merge(options))
    end
  
    def by_cities(city_ids, active=true)
      find(:all, :conditions => [" city_id in (?) and active=?", city_ids, active])
    end
    
    def active
      find :all, :conditions => ("active = 1")
    end
  end
  
  validates_presence_of :image_id
end
