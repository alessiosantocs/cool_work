class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :obj, :polymorphic => true
  belongs_to :comment, :foreign_key => :obj_id
  
  def self.blank(options={})
    new({
      :inappropriate => false,
      :spam => false,
      :resolved => false
    }.merge(options))
  end
  
  def status
    txt = []
    txt << 'inappropriate' if self.inappropriate?
    txt << 'spam' if self.spam?
    txt.join(', ')
  end

  def self.find_recent_comments(limit = 10)
    find( :all, 
      :group => "flags.obj_id, flags.obj_type", 
      :conditions => "flags.obj_type='Comment'", 
      :joins => "LEFT JOIN comments ON flags.obj_id=comments.id", 
      :order => "flags.id desc", 
      :include => [:comment], 
      :limit => limit.to_i)
  end
  
  def destroy_comment
    self.obj.destroy
  end
  
  def clear_all
    self.obj.flags.destroy_all
  end
  
  def after_create
    Audit.log(self, self.user.username, 'flag', "#{self.obj_type} marked as #{self.status}")
  end
  
  def before_destroy
    connection.delete("DELETE FROM audits where obj_id=#{self.id} AND obj_type='#{self.obj_type}'")
  end
  
  def to_json(*args)
    {
		 :id  => self.id,
		 :inappropriate  => self.inappropriate,
		 :obj_id  => self.obj_id,
		 :obj_type  => self.obj_type,
 		 :resolved  => self.resolved,
 		 :spam  => self.spam,
 		 :objekt => self.obj,
		 :created_on  => self.created_on
		}.to_json(*args)
  end
end
