class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string :template_name
      t.text :template_data

      t.timestamps
    end
  end

  def self.down
    drop_table :email_templates
  end
end
