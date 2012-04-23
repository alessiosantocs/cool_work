require File.dirname(__FILE__) + '/../test_helper'

class PartyTest < Test::Unit::TestCase
  fixtures :parties
  
  def setup
    @party = Party.find 1
  end
  
  def test_should_create_party
    s = create_party()
    assert_equal 4, Party.count
  end
  
  def test_count_my_fixtures
    assert_equal 3, Party.count
    assert_equal 1, Party.active.length
  end

  def test_destroy
    @party.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Party.find @party.id }
  end
  
  def test_validate
    assert_equal 1, @party.id
    @party.title = 'Alexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at ShowAlexina Vasquez Performs Live at Show'
    assert !@party.save
    assert_equal 1, @party.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Party, @party
    assert_equal 1, @party.id
    assert_equal 1, @party.city_id
    assert_equal 1, @party.user_id
    assert_equal 1, @party.venue_id
    assert_equal 7329, @party.next_event
    assert_equal 7251, @party.last_event
    assert_equal 'Saturday Night Live', @party.title
    assert_equal 'NiteLife,Crown Us,Eclectic,Jinglin Baby,Power Co', @party.hosted_by
    assert_equal '2005-02-19 00:00:00', @party.start_date.strftime('%Y-%m-%d %H:%M:%S')
    assert_equal '2006-07-16 03:00:00', @party.next_date.strftime('%Y-%m-%d %H:%M:%S')
    assert_equal nil, @party.end_date
    assert_equal 6, @party.length_in_hours
    assert_equal 3, @party.dress_code
    assert_equal 3, @party.age_male
    assert_equal 3, @party.age_female
    assert_equal 25.00, @party.door_charge
    assert_equal 0.00, @party.guestlist_charge
    assert_equal 'DJ GoldFinger and Frank Jugga', @party.dj
    assert_equal 'Hip-Hop, Reggae, R&B', @party.music
    assert_equal "Saturday Night Live at Spirit is NYC's Hottest Party.  With numerous celebrity appearances each week such as Usher, Pharrel, Swizz Beats, Fabolous and many more you're guarenteed  great time. email snlrsvp@aol.com", @party.description
    assert_equal 1, @party.wotm
    assert_equal 1, @party.tf
    assert_equal 1, @party.timeframecount
    assert_equal 'multiple', @party.recur
    assert_equal 0, @party.dotw
    assert_equal 72, @party.pics_left
    assert_equal 32, @party.days_remaining
    assert_equal 'geospence2@aol.com', @party.photographer
    assert_equal false, @party.sponsored
    assert_equal nil, @party.sponsored_ad_id
    assert_equal true, @party.flyer
    assert_equal true, @party.premium
    assert_equal true, @party.active
  end
  
  def test_these_properties
    s = create_party(:title => nil)
    assert s.errors.on(:title)
    s = create_party(:description => nil)
    assert s.errors.on(:description)
    s = create_party(:length_in_hours => 96)
    assert s.errors.on(:length_in_hours)
  end
  
  protected
  def create_party(options = {})
    Party.create({ 
      :city_id => 1,
      :user_id => 1,
      :venue_id => 3,
      :next_event => nil,
      :last_event => nil,
      :title => 'Color Purple Afterparty', 
      :start_date => 5.days.from_now.to_s, 
      :next_date => 5.days.from_now.to_s,
      :end_date => nil,
      :length_in_hours => 6,
      :dress_code => 3,
      :age_male => 3,
      :age_female => 3,
      :door_charge => 30.00,
      :guestlist_charge => 0.00,
      :dj => 'DJ Commish, DJ D-Nice, and MC Frank Jugga',
      :music => "Garage, House",
      :description => 'Houston',
      :wotm => 1,
      :tf => 1,
      :recur => 'multiple',
      :dotw => 0,
      :timeframecount => 1,
      :pics_left => 0,
      :days_remaining => 0,
      :photographer => nil,
      :sponsored => false,
      :sponsored_ad_id => nil,
      :flyer => false,
      :premium => true,
      :active => false }.merge(options))
  end
end
