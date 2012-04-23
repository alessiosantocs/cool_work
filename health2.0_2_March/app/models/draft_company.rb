class DraftCompany < ActiveRecord::Base
  belongs_to :draft_review
end
