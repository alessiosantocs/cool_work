class Hash
  class << self
    def create_result_set(result = [], total_results_available = 0, first_result_position = 1)
      { 
        "ResultSet" => {
          "totalResultsAvailable" => total_results_available,
          "totalResultsReturned" => result.size,
          "firstResultPosition" => first_result_position,
          "Result" => result
          }
      }
    end
  end
  
  # for mysql fields
  def prepare4db
    inject({}) do |options, (key, value)|
      options[key] = (value.nil? ? 'NULL' : "\"#{value}\"")
      options
    end
  end
  
  # Usage { :a => 1, :b => 2, :c => 3}.except(:a) -> { :b => 2, :c => 3}
  def except(*keys)    
    if Array === keys
      reject { |k,v| keys.include? k.to_sym }
    else
      reject { |k,v| keys == k  }
    end 
  end

  # Usage { :a => 1, :b => 2, :c => 3}.only(:a) -> {:a => 1}
  def only(*keys)
    if Array === keys
      reject { |k,v| !keys.include? k.to_sym }
    else
      reject { |k,v| keys != k  }
    end
  end
end