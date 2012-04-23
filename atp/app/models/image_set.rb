class ImageSet < ActiveRecord::Base
  belongs_to :image
  acts_as_list :scope => :obj
  belongs_to :obj, :polymorphic => true
  has_many :stats, :as => :obj, :dependent => :delete_all
  acts_as_rateable
  acts_as_commentable
  validates_presence_of :image_id
  attr_accessor :views
    
  def self.blank(options={})
    new({}.merge(options))
  end
  
  def self.get_first(type,id)
    find(:first, :conditions => ["obj_type=? and obj_id=?", type, id], :order => "position asc")
  end
  
  def drop
		case self.obj_type
		  when 'Event'
	      #delete from image set and all associated images
	      if self.image.destroy #this is a parent image being destroyed
	        self.obj.decrement!(:image_sets_count)
  	      self.destroy
	        return true
	      end
		end
		return false
  end
  
  def js
    { :id => image.id, :src => image.url, :caption => image.caption }
  end
  
  def comments_allowed
    self.image.comments_allowed
  end

  def show_comments?
    SITE.comments_allowed && self.obj.comments_allowed && self.comments_allowed
  end
  
  protected
  def after_create
    case self.obj_type
    when "Event"
      username = self.image.user.username
    else
      return false
    end
    Audit.log(self, username, 'image_set', 'new image added to set')
  end
end