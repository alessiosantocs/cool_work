# == Schema Information
# Schema version: 98
#
# Table name: buildings
#
#  id          :integer(11)   not null, primary key
#  addr1       :string(255)   
#  addr2       :string(255)   
#  city        :string(255)   
#  state       :string(255)   
#  zip         :string(9)     
#  doorman     :boolean(1)    
#  schedule_id :integer(11)   
#  serviced    :boolean(1)    
#

class Building < ActiveRecord::Base
  #The purpose of this class is to amalgamate addresses.  For example, so that all people
  #living in a certain building are associated, and so that we can assign qualities to that
  #particular building (such as the presense of a doorman, etc.)
  
  #we need a way to normalize addressing so that we can associate disparate input.
  #  the easy way -> look-ahead on input + a routine to compare like addresses
  #  the hard way -> CASS/DPV certification
  def self.supported_states
  states= State.all
  state_array = Array.new
  states.each do |state|
    state_array.push(state.name)
  end
    state_array
  end
  
  def self.supported_zips
    begin
      zips = ServicedZip.find(:all, :conditions => {:active => true}).collect(&:zip)
    rescue Exception #Mysql::Error
      zips = []
    end
    if zips.size == 0
      zips = ["10002", "10003", "10007", "10008", "10009", "10010", "10012", "10013", "10016", "10017", "10021", "10022", "10028", "10029", "10065", "10075", "10101", "10108", "10113", "10116", "10128", "10150", "10152", "10154", "10155", "10159", "10162", "10178", "10256", "10268", "10276", "10279", "10280", "10281", "10282", "10286"]
    end
    zips
  end
  
  def concords_with(loc)
    self.location.concords_with(loc)
  end
  
  has_one :location, :as => :target
  has_many :addresses
  has_one :credit_cards, :dependent => :destroy
  def building_customer
    Customer.find(:first,
                  :joins => "INNER JOIN addresses ON addresses.customer_id = customers.id",
    :conditions => "customers.is_building = true AND addresses.building_id = " + self.id.to_s
    )
  end
  
  validates_presence_of :addr1, :city, :state, :zip
  validates_inclusion_of :zip, :in =>  supported_zips, :message => "Your zip code is not currently serviced"
  validates_inclusion_of :state, :in => supported_states
  
  def initialize(*params)
    super(*params)
    self.city = 'New York' unless self.city
  end
  
  def to_s(long = false)
    s = self.addr1
    #s += city + ', ' + state if long = true
  end
  
  def formatted
    '<div>' +addr1+ '</div><div>' + city + '</div><div>' + state + '</div>'
  end
  
  def serviced?
    true if ServicedZip.find(:first, :conditions => {:zip => self.zip, :active => true})
  end
  
  def parent_location
    ServicedZip.find_by_zip(self.zip)
  end
  
  def is_in(superzone)
    self.location.is_in(superzone)
  end
  def contains(subzone)
    self.location.contains(subzone)
  end
  
  def density
    d = 0
    addresses.each do |a|
      d += a.density
    end
    d
  end
  
  # to help with constraining buildings
  def self.find_or_initialize(params)
    find_or_do('initialize', params)
  end
  
  def make_building_customer()
    return false unless self.doorman == true
    building_customer = Customer.create!(
                                         :account => User.new(
                         :first_name => self.addr1,
                         :last_name => self.addr2 || '(building customer)',
    :email => 'building_' + self.id.to_s + '@myfreshshirt.com',
    :email_confirmation => 'building_' + self.id.to_s + '@myfreshshirt.com',
    :password => 'password',
    :password_confirmation => 'password'
    ),
    :cell => '9175551212',
    :home => '2125551212',
    :work => nil,
    :active => true,
    :is_building => true,
    :carbon_credits => 0,
    :water_credits => 0,
    :addresses => [] << Address.new(
                                    :building => self,
                                    :unit_number => "lobby"
    ),
    :accepted_terms => true
    )
  end
  
  private
  
  # Find a record that matches the attributes given in the +params+ hash, or do +action+
  # to retrieve a new object with the given parameters and return that.
  def self.find_or_do(action, params)
    # if an id is given just find the record directly
    self.find(params[:id])
    
  rescue ActiveRecord::RecordNotFound => e
    attrs = {}     # hash of attributes passed in params
    
    # search for valid attributes in params
    self.column_names.map(&:to_sym).each do |attrib|
      # skip unknown columns, and the id field
      next if params[attrib].nil? || attrib == :id
      
      attrs[attrib] = params[attrib]
    end
    
    # no valid params given, return nil
    return nil if attrs.empty?
    
    # call the appropriate ActiveRecord finder method
    self.send("find_or_#{action}_by_#{attrs.keys.join('_and_')}", *attrs.values)
  end
  
end
