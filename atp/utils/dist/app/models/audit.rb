class Audit < ActiveRecord::Base
  belongs_to :obj, :polymorphic => true
  
  def self.logs_since(since, show=[], limit = 10)
    return [] if show.size == 0
    limit = 10 if limit > 50 or limit < 10
    since = (since.to_f / 1000) - Time.now.gmt_offset
    find( :all, :conditions => ["created_on > FROM_UNIXTIME(?) and what in ('#{show.join('\',\'')}')", since.to_i ], :limit => limit.to_i)
  end
  
  def self.recent(show=[], limit = 10)
    find( :all, :limit => limit.to_i) #, :order => "id desc"
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
  
  def to_json(*a)
    {
      'section'   => obj_type,
      'who'         => who,
      'message'   => message,
      'what'         => what,
      'section_id'   => obj_id,
      'created'         => created_on.to_i
    }.to_json(*a)
  end
  
end