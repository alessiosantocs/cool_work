class Vote < ActiveRecord::Base
  belongs_to :voteable, :polymorphic => true
  belongs_to :user

  def self.find_votes_cast_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end
  
  protected
  def after_create
    txt = (self.vote == true ? 'Up' : 'Down')
    Audit.log(self, self.user.username, 'vote', "Thumbs #{txt} on #{self.voteable_type}")
  end

  def before_create
    #remove all votes by this person on the same object
    Vote.delete_all "user_id = #{self.user_id} AND voteable_id = '#{self.voteable_id}' AND voteable_type = '#{self.voteable_type}'"
  end
end