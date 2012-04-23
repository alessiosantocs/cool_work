class Fave < ActiveRecord::Base
  belongs_to :user
  belongs_to :obj, :polymorphic => true
  validates_presence_of       :obj_id, :obj_type, :user_id
  validates_length_of         :obj_type,   :within => 1..12
  
  def self.find_by_user_and_type(user_id, type, offset=0, limit=10)
    return [] unless SETTING["faveable"].include?(type) 
    recs = find(:all, :conditions=>["user_id=? and obj_type=?", user_id.to_i, type.to_s], :offset => offset, :limit => limit, :order => "id desc")
    case type
      when 'Profile'
        new_recs = []
      when 'ImageSet'
        new_recs = recs.collect{ |r|
          { :id => r.id, :section => r.obj_type, :obj_id => r.obj_id, :image => ImagePublic.new(r.obj.image) } unless r.obj.nil?
        }
      when 'Venue'
        new_recs = recs.collect{ |r|
          { :id => r.id, :section => r.obj_type, :obj_id => r.obj_id, :title => "#{r.obj.name}, #{r.obj.city}, #{r.obj.state}" }
        }
      when 'Party'
        new_recs = recs.collect{ |r|
          { :id => r.id, :section => r.obj_type, :obj_id => r.obj_id, :title => "#{r.obj.title} at #{r.obj.venue.name}" }
        }
    end
    new_recs
  end
  
  protected
  def after_create
    txt = ''
    case self.obj_type
      when 'Venue'
        txt = self.obj.name
      when 'Party'
        txt = self.obj.title
      when 'ImageSet'
        txt = 'Image'
    end
    Audit.log(self, self.user.username, 'fave', "New #{self.obj_type}: #{txt}")
  end
end