class Ad < ActiveRecord::Base
  belongs_to :user
  belongs_to :image
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :zones
  
  validates_length_of         :title, :within => 3..24, :allow_nil => false
  validates_length_of         :url, :within => 3..250, :allow_nil => false
  validates_length_of         :size, :within => 6..7, :allow_nil => false
  validates_presence_of       :image_id, :start, :stop
  
  attr_accessor :city_id
  
  def self.active(size,opt={})
    options = {
      :limit => 25,
      :offset => 0,
      :conditions => ["size=? AND active=?", size, true]
    }.merge(opt)
    
    find(:all, options)
  end
end