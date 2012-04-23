class Audit < ActiveRecord::Base
  belongs_to :obj, :polymorphic => true
  
  def self.logs_since(since, show=[], limit = 10)
    return [] if show.size == 0
    limit = 10 if limit > 50 or limit < 10
    since = (since.to_f / 1000) - Time.now.utc
    find( :all, :conditions => ["created_on > FROM_UNIXTIME(?) and what in ('#{show.join('\',\'')}')", since.to_i ], :limit => limit.to_i)
  end
  
  def self.recent(show=[], limit = 10)
    str = (show.size > 0 ? "what in ('#{show.join('\',\'')}')" : '1')
    find( :all, :conditions =>str, :order => "id desc", :limit => limit.to_i)
  end
  
  def self.log(rec, who, what, message)
    create({
      :obj_type => rec.class.to_s,
      :obj_id   => rec.id,
      :message  => message,
      :what     => what,
      :who      => who
    })
  end
end