class Flyer < ActiveRecord::Base
  belongs_to :image
  belongs_to :obj, :polymorphic => true
end