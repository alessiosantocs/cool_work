class CommentObserver < ActiveRecord::Observer
  def after_create(record)
    txt = ''
    case record.commentable_type
      when 'ImageSet'
        txt = "Image"
    end
    Audit.log(record, record.user.username, 'comment', " Comment on #{txt}: #{record.comment[0..24]}...")
  end
end