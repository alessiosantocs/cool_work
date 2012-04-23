class AddColumnToPersonnels < ActiveRecord::Migration
  def self.up
    add_column :personnels, :email, :string
  end

  def self.down
    remove_column :personnels, :email
  end
end
