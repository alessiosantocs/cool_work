class Stat < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  belongs_to :region
  belongs_to :obj, :polymorphic => true
end