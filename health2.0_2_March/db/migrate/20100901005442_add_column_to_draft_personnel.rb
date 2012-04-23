class AddColumnToDraftPersonnel < ActiveRecord::Migration
  def self.up
    add_column :draft_personnels, :current_title, :string
  end

  def self.down
    remove_column :draft_personnels, :current_title
  end
end
