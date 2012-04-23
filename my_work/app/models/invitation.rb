class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_one :recipient, :class_name => 'User'
  
  validates_presence_of :recipient_email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :recipient_is_not_registered
  validate :recipient_is_not_invited
#   validate :sender_has_invitations
  validates_uniqueness_of :recipient_email
  validates_format_of :recipient_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_length_of :first_name, :in => 2..30
  validates_length_of :last_name, :in => 2..30
  
  before_create :generate_token
#   before_create :decrement_sender_count
  require 'digest/sha1'

#  liquid_methods :recipient_firstname, :recipient_lastname
  
  def recipient_is_not_registered
    errors.add_to_base "#{recipient_email} is already registered" if User.find_by_email(recipient_email)
  end
  
  def recipient_is_not_invited
    errors.add_to_base "#{recipient_email} is already invited" if Invitation.find_by_recipient_email(recipient_email)
  end
  
#   def sender_has_invitations
#     unless self.sender.invitation_limit.to_i > 0
#       errors.add_to_base 'You have reached your limit of invitations to send.'
#     end
#   end
  
  def generate_token
    self.token = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{rand}--")
  end

  def decrement_sender_count
    sender.decrement! :invitation_limit
  end

  def name
    self.first_name + " " + self.last_name
  end
  
end
