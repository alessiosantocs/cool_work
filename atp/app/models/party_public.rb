class PartyPublic
  def initialize(p)
    @id = p.id
    @username = p.user.username
    @venue_id = p.venue_id
    @venue_name = p.venue.name
    @title = p.title
    @hosted_by = p.hosted_by
    @length_in_hours = p.length_in_hours
    @dress_code = p.dress_code
    @age_male = p.age_male
    @age_female = p.age_female
    @door_charge = p.door_charge
    @guestlist_charge = p.guestlist_charge
    @dj = p.dj
    @music = p.music
    @description = p.description
    @females_free_until = p.females_free_until
    @males_free_until = p.males_free_until
    @females_reduced_until = p.females_reduced_until
    @males_reduced_until = p.males_reduced_until
    @comments_allowed = p.comments_allowed
    @premium = p.premium
    @pics_left = p.pics_left
  end
end