class Party < ActiveRecord::Base
  has_and_belongs_to_many :sites
  belongs_to :city
  belongs_to :user
  belongs_to :venue
  has_one :flyer, :as => :obj, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  has_many :image_sets, :through => :events
  has_many :faves, :as => :obj, :dependent => :destroy
  

  def event
    return Event.new if current_event_id.nil?
    if event = Event.find_by_id(self.current_event_id)
      return event
    else
      return Event.new
    end
  end
  
  def current_flyer
    event.flyer || flyer || nil
  end
end