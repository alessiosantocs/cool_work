class AddReferralTracking < ActiveRecord::Migration
  def self.up
    add_column :employees, :referral_code, :string
    create_table :employee_pay_outs do |t|
      t.column :employee_id, :integer
      t.column :amount, :decimal, :precision => 9, :scale => 2
      t.column :authorized_by, :integer
      t.timestamps
    end
  end

  def self.down
    remove_column :employees, :referral_code
    drop_table :employee_pay_outs
  end
end
