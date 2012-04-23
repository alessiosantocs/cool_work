class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.string :first_name, :last_name, :login, :email, :remember_token, :maiden
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.timestamps
      t.datetime :remember_token_expires_at
    end
  end

  def self.down
    drop_table "users"
  end
end
