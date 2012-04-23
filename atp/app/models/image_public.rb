class ImagePublic
  def initialize(i)
    @id = i.id
    @name = i.name
    @url = i.url
    @extension = SETTING['image_server']['extension']
    @caption = i.caption || ""
  end
end