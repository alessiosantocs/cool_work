class Flyer < ActiveRecord::Base
  belongs_to :image
  belongs_to :obj, :polymorphic => true
  validates_presence_of :image_id, :obj_type, :obj_id
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def before_destroy
	  self.image.destroy #delete from all associated images
  end
end