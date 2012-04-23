class AuditPublic
  def initialize(a)
    @section = a.obj_type
    @who = a.who
    @message = a.message
    @what = a.what
    @section_id = a.obj_id
    @created = a.created_on.to_i
    #{"created_on": "2006-11-13 05:37:27", "obj_type": "Venue", "obj_id": "3", "id": "3", "who": "joemocha", "what": "new"}
  end
end