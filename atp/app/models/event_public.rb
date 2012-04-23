class EventPublic
  def initialize(e)
    @id = e.id
    @venue_id = e.venue_id
    @venue_name = e.venue.name
    @happens_at = e.local_time('date')
    @comments_allowed = e.comments_allowed
    @photographer = (e.photographer.nil? ? e.party.user.username : e.photographer.username)
    @hosted_by = e.hosted_by
    @synopsis = e.synopsis
    @image_sets_count = e.image_sets_count
    @picture_uploaded = e.picture_uploaded
    @picture_upload_time = e.picture_upload_time.to_i
    @image_set = e.image_sets.collect{| image_set | { :id => image_set.id,  :image => ImagePublic.new(image_set.image) } }
  end
end