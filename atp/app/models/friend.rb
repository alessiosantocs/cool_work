class Friend < ActiveRecord::Base
  belongs_to :user, :foreign_key => :fp
  has_one :friend, :foreign_key => :id
  
  def self.get_friends(user_id)
    find(:all, :select => "friends.id, users.id, users.username", :conditions => "friends.fp=#{user_id} AND friends.a=1", :joins => "LEFT JOIN users on friends.fc = users.id")
  end
end
