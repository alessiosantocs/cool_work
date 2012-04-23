class Guestlist < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates_presence_of       :user_id, :event_id
  validates_length_of         :full_name, :within => 3..45
  validates_numericality_of   :number_of_guests, :allow_nil => true
  attr_accessor :full_name_and_number_of_guests
  
  def self.blank(options={})
    new({
      :number_of_guests => 1
    }.merge(options))
  end
  
  def self.get_event_list(user_id, event_id)
    return false unless event = Event.find_by_id(event_id) #find event
    return false unless event.party.user_id == user_id # do you own event
    
	  event.guestlists.collect{ |g| { 
	     :id => g.id, 
	     :name => g.full_name, 
	     :guests => g.number_of_guests,
	     :time => (g.created_on.to_i.to_s+'000').to_i }
	  }
  end
end