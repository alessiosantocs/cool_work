class MakeClassicViewDefault < ActiveRecord::Migration
  def self.up
    User.update_all "classic_view=1"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
