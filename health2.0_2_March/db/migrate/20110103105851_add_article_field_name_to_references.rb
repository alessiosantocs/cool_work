class AddArticleFieldNameToReferences < ActiveRecord::Migration
  def self.up
    add_column :references, :article_field_name, :string
  end

  def self.down
    remove_column :references, :article_field_name
  end
end
