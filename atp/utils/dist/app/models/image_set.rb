class ImageSet < ActiveRecord::Base
  belongs_to :image
  acts_as_list
  belongs_to :obj, :polymorphic => true
  #acts_as_rateable
  #acts_as_commentable
  validates_presence_of :image_id
    
  def self.blank(options={})
    new({}.merge(options))
  end
  
  def drop
		case self.obj_type
		  when 'Event'
	      #delete from image set and all associated images
	      if image.destroy #this is a parent image being destroyed
	        self.destroy
	        self.obj.decrement!(:image_sets_count)
	        return true
	      else
	        return false
	      end
	    else
	      return false
		end
  end
  
  def js
    img = self.image
    { :id => img.id, :src => img.url, :caption => img.caption }
  end
end