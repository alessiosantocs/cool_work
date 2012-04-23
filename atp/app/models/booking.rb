class Booking < ActiveRecord::Base
  belongs_to :party
  belongs_to :user
  validates_presence_of       :party_id, :contact_email, :contact_name
  validates_length_of         :contact_email, :within => 7..60
  validates_format_of         :contact_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "is invalid."
  
  def self.blank(options={})
    new({
      :resolved => false
    }.merge(options))
  end
  
  def self.get_party_list(user_id, party_id)
    return false unless party = Party.find_by_id(party_id) #find party
    
	  party.bookings.collect{ |b| { 
	     :id => b.id, 
	     :name => b.contact_name, 
	     :email => b.contact_email,
	     :phone => b.contact_phone,
	     :resolved => b.resolved,
	     :time => (b.created_on.to_i.to_s+'000').to_i }
	  }
  end
  
  def self.types
    { '1' => "Birthday Party",
      '2' => "Graduation Party",
      '3' => "Bachelorette Party",
      '4' => "Anniversary Party",
      '5' => "Engagement Party",
      '6' => "Job Promotion Party",
      '7' => "Retirement Party",
      '8' => "Welcome Back Party",
      '9' => "Bachelor Party",
      '10' => "Cocktail Party",
      '11' => "Concert Show",
      '12' => "Happy Hour",
      '13' => "New Job Celebration",
      '14' => "Party",
      '15' => "Night on The Town",
      '16' => "Get Together Party",
      '18' => "Memorial Day",
      '19' => "Independence Day",
      '20' => "New Year's Eve Celebration",
      '21' => "Thanksgiving Eve Party",
      '22' => "Labor Day Party",
      '23' => "Corporate Event" }
  end
end
