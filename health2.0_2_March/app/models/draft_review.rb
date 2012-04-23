class DraftReview < ActiveRecord::Base
  belongs_to :company
  belongs_to :email_tracker
  has_one :draft_company
end
