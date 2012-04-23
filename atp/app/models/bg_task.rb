class BgTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :obj, :polymorphic => true
  
  def completed?
    self.status == 'completed' ? true : false
  end
  
  def self.completed(type,type_id,user_id)
    if task = find(:first, :conditions => ["obj_type=? AND obj_id =? and user_id=?", type.capitalize, type_id, user_id])
      task.status = 'completed'
      task.completed_at = Time.now.utc
      task.save
    end
  end
end