class UpdateUsers < ActiveRecord::Migration
  def self.up
    users = User.find(:all)
    for user in users
      if user.account.nil?
        customer = Customer.new({:sex => "M", :dob => "19910315", :cell => "2015551212", :accepted_terms => true})
        customer.user = user
        customer_preferences = customer.build_customer_preferences()
        address = customer.addresses.build({:unit_designation => "apt", :unit_number => "1E", :building => Building.find_or_initialize({:addr1 => "150 5th Ave.", :city => "New York", :state => "NY", :zip => "10015", :doorman => true})})
        customer.save!
      else
        if user.account.preferences.nil?
          customer = user.account
          customer_preferences = customer.build_customer_preferences()
          customer.save!
        end
      end
    end
  end
  
  def self.down
  end
end
