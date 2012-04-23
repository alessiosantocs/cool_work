class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :items
  validates_presence_of       :user_id
  
  def self.history_by_user(user_id, offset=0, limit=SETTING["limit"])
    find(:all, :conditions => ['orders.user_id=?', user_id], :offset => offset, :limit => limit, :order => 'orders.created_on desc')
  end
end

class FreeOrder < Order
  def self.party(party, user_id)
    if SETTING["days_free"] > party.days_free
      RAILS_DEFAULT_LOGGER.error 'SETTING["days_free"] > party.days_free'
      if order = create(:total => 0, :user_id => user_id)
        day_item = Item.find(1)
        days = SETTING["days_free"] - party.days_free
        order.items.push_with_attributes(day_item, { :price => 0, :quantity => days, :party_id => party.id }) rescue nil # FIXME
        params = {
          :days_free => days,
          :active => true,
          :premium => false
        }
        if party.update_attributes(params)
          RAILS_DEFAULT_LOGGER.error "Party not Updated!. #{party.errors.full_messages.join('. ')}"
        end
      end
    end
  end
end

class PaidOrder < Order
  validates_presence_of       :full_name, :address, :city, :state, :country, :postal_code, :total, :cc_type, :cc_last4, :payment_status, :ip_address
  validates_length_of         :full_name, :within => 3..75
  validates_length_of         :address, :within => 3..75
  validates_length_of         :city, :within => 2..25
  validates_length_of         :state, :within => 2..25
  validates_length_of         :postal_code, :within => 3..10
  validates_length_of         :country, :is => 2
  validates_length_of         :cc_type, :is => 4
  validates_length_of         :cc_last4, :is => 4
  validates_numericality_of   :total
end