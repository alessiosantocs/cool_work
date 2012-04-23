class CreateCustomerPreferences < ActiveRecord::Migration
  def self.up
    create_table "customer_preferences" do |t|
      t.column :customer_id, :integer
      
      #wash and fold default options
      t.column :wf_temperature, :string
      t.column :wf_fabric_softener, :boolean
      t.column :wf_bleach, :boolean
      
      #laundered shirts
      t.column :ls_starch, :string
      t.column :ls_press, :string
      t.column :ls_packaging, :string
      
      #dry cleaning
      t.column :dc_starch, :string
      t.column :dc_press, :string
      
      #tagging
      t.column :permanent_tags, :boolean
      
      #notifications
      t.column :day_before_email, :boolean
      t.column :day_before_sms, :boolean
      t.column :day_of_email, :boolean
      t.column :day_of_sms, :boolean
      
      #contact options
      t.column :preferred_contact, :string
      
      #doorman options
      t.column :doorman_permission, :boolean
    end
  end

  def self.down
    drop_table "customer_preferences"
  end
end