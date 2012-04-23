class Msg < ActiveRecord::Base
  acts_as_tree
  belongs_to :user, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :user, :class_name => "User", :foreign_key => "receiver_id"
  has_many :flags, :as => :obj, :dependent => :destroy
	validates_length_of :subject, :in=> 2..200
	validates_length_of :message, :in => 2..2100
	attr_accessor :username
	#after_save :check_receiver_notification

  def self.blank(options={})
    new({
      :deleted_by_sender => false,
      :deleted_by_receiver => false,
      :parent_id => nil,
      :read_timestamp => nil
    }.merge(options))
  end
  
	def self.get_msg(user_id, folder='inbox', offset=0, limit=5)
		if folder=='inbox'
			query = "deleted_by_receiver=0 AND receiver_id='#{user_id}'"
		elsif folder=='sent'
			query = "deleted_by_sender=0 AND sender_id='#{user_id}'"
		else
			return false
		end
		all_msgs = find :all, :conditions => query, :order => "id DESC", :limit => limit, :offset => offset
	  all_msgs.collect{ |m| { 
	     :id => m.id, 
	     :subject => m.subject, 
	     :message => m.message, 
	     :sender => User.find(m.sender_id).username, 
	     :receiver => User.find(m.receiver_id).username,
	     :read => m.read_timestamp.nil? ? false : true,
	     :time => (m.created_on.to_i.to_s+'000').to_i } }
	end
  
	def self.delete_msgs(user_id, folder, ids)
		if folder=='inbox'
			query = "deleted_by_receiver=1 WHERE receiver_id='#{user_id}'"
		elsif folder=='sent'
			query = "deleted_by_sender=1 WHERE sender_id='#{user_id}'"
		else
			return false
		end
		connection.update("update msgs SET #{query} AND id in (#{ids.join(',')})")
	end
	
	def self.send_msg(sender,receiver,sub,txt)
		return true if Msg.create(:sender=>sender,:receiver=>receiver, :subject=>sub.to_s, :message=>txt.to_s)
		return false
	end

	def self.viewed_by(user_id, id)
		connection.update("update msgs SET read_timestamp=now() WHERE receiver_id='#{user_id}' AND id = #{id}")
	end

	def self.flag_as_spam(user_id, folder, id)
		Msg.delete_msgs(user_id, folder, [id])
		msg_flagged = Flag.blank( {
		  :user_id  => user_id,
		  :obj_id   => id,
		  :obj_type => 'Msg',
		  :spam     => true
		} )
		return true if msg_flagged.save
		return false
	end
	
	def self.total_unread_msgs(user_id)
		result = find_by_sql("SELECT count(id) as unread FROM msgs WHERE deleted_by_receiver=0 AND receiver_id='#{user_id}' AND read_timestamp is NULL")
		result[0].unread
	end
	
	def self.total_msgs(user_id, folder)
		if folder=='inbox'
			query = "deleted_by_receiver=0 AND receiver_id='#{user_id}'"
		elsif folder=='sent'
			query = "deleted_by_sender=0 AND sender_id='#{user_id}'"
		else
			return false
		end
		result = find_by_sql("SELECT count(id) as all_msgs FROM msgs WHERE #{query}")
		result[0].all_msgs
	end
	
	protected
	def check_receiver_notification
		unless LiveXp.online_now?(receiver)
			if rec=User.find(:first,:conditions=>"notification_frequency='Instantly' AND receive_personal_notification=1 AND username='#{receiver}'", :select=>"email,security_token")
				MsgMailer::deliver_instantly(self,sender,rec) #(self)
			end
		end
	end
end
