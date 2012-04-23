class Company < ActiveRecord::Base
    
    	validates_uniqueness_of :name
	has_many :personnels, :dependent=>:destroy 
	has_many :products, :dependent=>:destroy 
	has_many :partnerships, :dependent=>:destroy 
	has_many :company_categories, :dependent=>:destroy 
	has_many :investments, :dependent=>:destroy 
	has_many :references, :dependent=>:destroy
	has_many :keyword_stores, :dependent=>:destroy  
        has_many :videos, :dependent=>:destroy  
end
