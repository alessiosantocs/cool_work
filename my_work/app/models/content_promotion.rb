class ContentPromotion < ActiveRecord::Base
  belongs_to :promotion
  has_attached_file :image, :styles => { :medium => "200x200!", :thumb => "348x348!" }

  def self.email_text( promotion_content )
    promotion = promotion_content.promotion
    expiry_date = promotion_content.expiry_date.to_date
    '<div style="font-size:28pt;font-weight:bold; text-transform: capitalize;">' + promotion_content.title + '</div><p>' +  promotion_content.body + '</p><p> Enter Promo Code : ' + promotion.code + '</p><p> Offer is valid through ' + expiry_date.strftime('%B') + ' ' + expiry_date.strftime('%d').to_i.ordinalize + ', ' + expiry_date.strftime('%Y') + '</p>'
  end
end
