class LocalSites < ActiveRecord::Migration
  def self.up
    local = Site.create(:id=> 3, :short_name => "FCG", :full_name => "FCG Media", :comments_allowed => true, :url => "fcgmedia.local", :active => true )
    local.regions << Region.find(:all)
  end

  def self.down
    s = Site.find 3
    s.destroy
  end
end
