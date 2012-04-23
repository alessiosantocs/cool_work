class PromotionService < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :promotion
  belongs_to :service
end
