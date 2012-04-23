#http://www.pathf.com/blogs/2008/06/more-named-scope-awesomeness/
class ActiveRecord::Base
  named_scope :limit, lambda {|size| {:limit => size} }
  named_scope :offset, lambda {|offset| {:offset => offset} }
  named_scope :order, lambda {|order| {:order => order} }
  
  STRING_SCOPES = {
    :contains => ["LIKE", "%", "%"],
    :does_not_contain => ["NOT LIKE", "%", "%"],
    :starts_with => ["LIKE", "", "%"],
    :does_not_start_with => ["NOT LIKE", "", "%"],
    :is => ["=", "", ""],
    :is_not => ["<>", "", ""]}    
 
  STRING_SCOPES.each do |key, value|
    operator, prefix, suffix = value
    named_scope key, lambda { |column, text|
      {:conditions => ["lower(#{column}) #{operator} ?", "#{prefix}#{text.downcase}#{suffix}"]}     
    }
  end
end