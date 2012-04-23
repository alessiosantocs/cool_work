class Stat < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  belongs_to :region
  belongs_to :obj, :polymorphic => true
  attr_accessor :views
  
  def self.most_views_by_type(element, time_frame= 1.hour.ago, limit=10)
    result = get_stats(element, time_frame, limit)
    return [] if result.empty?
    ImageSet.find(:all, :conditions => ["image_sets.id in (?)", result.collect{|v| v.obj_id }], :include => [:image])
  end
  
  def self.most_views_by_count(element, time_frame= 1.hour.ago, limit=10)
    result = get_stats(element, time_frame, limit)
    return [] if result.empty?
    result
  end

  def self.remove_old
    delete_all "created_on < '#{SETTING['stats_expire_in_days'].days.ago.db}'"
  end
  
  private
  def self.get_stats(element, time_frame= 1.hour.ago, limit=10)
    time_frame = time_frame.utc
    case element.class.to_s
      when 'Event'
        ids = element.image_sets.collect{|i| i.id }
        options = { :conditions => ["stats.obj_id in (?) and act='view' and stats.created_on >= ?", ids, time_frame ] }
      when 'Site'
        options = { :conditions => ["stats.act='view' and stats.created_on >= ?", time_frame] }
      when 'Region'
        options = { :conditions => ["stats.act='view' and stats.region_id=? and stats.created_on >= ?", element.id, time_frame] }
      else
        return []
    end
    options = {
      :select => "stats.obj_id, count(stats.id) as views",
      :group => [:obj_id],
#      :joins => "LEFT JOIN image_sets ON stats.obj_id=image_sets.id",
      :order => "views desc", 
      :limit => limit      
    }.merge(options)
    Stat.find(:all, options)
  end
end