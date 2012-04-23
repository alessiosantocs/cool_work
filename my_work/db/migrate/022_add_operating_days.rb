class AddOperatingDays < ActiveRecord::Migration
  def self.up
    create_table "operating_days" do |t|
      t.date "date"
      t.integer "rate_mod"
    end
  end

  def self.down
    drop_table "operating_days"
  end
end
