class PromotionZip < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :serviced_zip
end
