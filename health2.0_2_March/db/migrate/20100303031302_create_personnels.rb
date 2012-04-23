class CreatePersonnels < ActiveRecord::Migration
  def self.up
    create_table :personnels do |t|
      t.string :first_name
      t.string :last_name
      t.string :current_title
      t.string :previous_title
      t.boolean :founder
      t.string :grad_edu
      t.string :undergrad_edu
      t.string :other_edu
      t.text :private_notes
      t.belongs_to :company

      t.timestamps
    end
  end

  def self.down
    drop_table :personnels
  end
end
