class Phrase < ActiveRecord::Base
  has_many :interests
  has_many :turn_offs
  has_many :turn_ons
  has_many :relationship_types
end
