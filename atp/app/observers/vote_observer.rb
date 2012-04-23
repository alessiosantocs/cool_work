class VoteObserver < ActiveRecord::Observer
  def after_create(record)
    txt = (record.vote == true ? 'Up' : 'Down')
    Audit.log(record, record.user.username, 'vote', "Thumbs #{txt} on #{record.voteable_type}")
  end
  
  def before_create(record)
    #remove all votes by this person on the same object
    Vote.delete_all "user_id = #{record.user_id} AND voteable_id = '#{record.voteable_id}' AND voteable_type = '#{record.voteable_type}'"
  end
end