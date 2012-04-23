class CompanyCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :company
  validates_uniqueness_of :id, :scope => [:company_id, :category_id]
end
