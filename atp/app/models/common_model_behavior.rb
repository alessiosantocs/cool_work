module ActiveRecord
  module Validations
    module ClassMethods
      # Intended for use with STI tables, helps ignore the type field
      def validates_overall_uniqueness_of(*attr_names)
        configuration = { :message => "must be unique" }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          records = self.find(:all, :conditions=> ["#{attr_name} = ?", value])
          record.errors.add(attr_name, configuration[:message]) if records.size > 0 and records[0].id != record.id
        end
      end
    end
  end
end