class Comment < ActiveRecord::Base
  acts_as_voteable
  acts_as_tree
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  has_many :flags, :as => :obj, :dependent => :destroy
  
  validates_presence_of       :user_id, :commentable_id, :commentable_type
  validates_length_of         :comment, :within => 2..255
  validates_length_of         :title, :within => 2..75, :allow_nil => true
  
  def self.since(comment_id)
    find(:all,
      :conditions => ["id > ?", comment_id]
    )
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  def self.find_comments_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up all comments for 
  # commentable class name and commentable id.
  def self.find_comments_for_commentable(commentable_str, commentable_id)
    find(:all,
      :conditions => ["commentable_type = ? and commentable_id = ?", commentable_str, commentable_id],
      :order => "created_at"
    )
  end

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
  
  def to_json(*args)
    {
		 :id  => self.id,
		 :comment => self.comment,
		 :commentable_id  => self.commentable_id,
		 :commentable_type  => self.commentable_type,
 		 :parent_id  => self.parent_id,
 		 :title  => self.title,
 		 :commentable => self.commentable,
		 :created_at  => self.created_at
		}.to_json(*args)
	end
	
  protected
  
  def before_save
    self.comment = self.comment.gsub(/<\/?[^>]*>/, "")
  end
  
  def after_create
    txt = ''
    case self.commentable_type
      when 'ImageSet'
        txt = "Image"
    end
    Audit.log(self, self.user.username, 'comment', " Comment on #{txt}: #{self.comment[0..24]}...")
  end
  
  def before_destroy
    connection.delete("DELETE FROM audits where obj_id=#{self.id} AND obj_type='Comment'")
  end
end