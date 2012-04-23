class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.integer
    end
  end

  def self.down
    drop_table :employees
  end
end
