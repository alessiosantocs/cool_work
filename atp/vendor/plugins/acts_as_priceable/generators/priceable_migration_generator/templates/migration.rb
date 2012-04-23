class <%= class_name %> < ActiveRecord::Migration
  # modify the table name for now, until I can figure out how to set it w/ the generator
  def self.up
    create_table :prices do |table|
      table.column  :amount, :int, :null => false
      table.column  :currency_id, :int, :null => false
    end
    
    create_table :currencies do |table|
      table.column  :code, :string, :limit => 3
      table.column  :symbol, :string, :limit => 10
      table.column  :name, :string
    end
    
    Currency.create :code => 'GBP', :name => 'British Pound', :symbol => '£'
    Currency.create :code => 'USD', :name => 'US Dollar', :symbol => '$'
 
     # Uncomment the line below to set the symbol column to utf8 in mysql,
     # this is useful for £ character if web page is in UTF8
#    execute 'ALTER TABLE currencies MODIFY symbol VARCHAR(10) CHARACTER SET utf8;'

    create_table :pricings do |table|
      table.column  :priceable_id, :int, :null => false
      table.column  :price_id, :int, :null => false
      table.column  :priceable_type, :string
    end
  end

  def self.down
    drop_table  :prices
    drop_table  :currencies
    drop_table  :pricings
  end
end
