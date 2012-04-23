class EmailTracker < ActiveRecord::Base
has_one :draft_review
end
