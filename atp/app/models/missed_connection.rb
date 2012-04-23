class MissedConnection < ActiveRecord::Base
  belongs_to :user
  belongs_to :party
  belongs_to :venue
  
  validates_presence_of       :user_id, :title, :story, :connection_type, :connection_date
  validates_length_of         :title, :within => 3..45
  validates_length_of         :story, :within => 10..2000
  validates_length_of         :location, :within => 3..45, :allow_nil => true
  validates_length_of         :connection_type, :is => 2
end