class MessageTracker < ActiveRecord::Base
  belongs_to :email_tracker
  belongs_to :company
end
