class CreateNotificationTemplates < ActiveRecord::Migration
  def self.up
    create_table :notification_templates do |t|
      t.string :name
      t.text :mail_body
      t.text :sms_body

      t.timestamps
    end
  end

  def self.down
    drop_table :notification_templates
  end
end
