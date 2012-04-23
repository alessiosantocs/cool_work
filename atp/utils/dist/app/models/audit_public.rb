class AuditPublic
  def initialize(a)
    @section = a.obj_type
    @who = a.who
    @message = a.message
    @what = a.what
    @section_id = a.obj_id
    @created = a.created_on.to_i
  end
end