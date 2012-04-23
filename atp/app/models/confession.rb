class Confession < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of       :user_id, :name, :title, :location, :story
  validates_length_of         :name, :within => 3..30
  validates_length_of         :title, :within => 3..45
  validates_length_of         :location, :within => 3..45
  validates_length_of         :story, :within => 10..2000
end