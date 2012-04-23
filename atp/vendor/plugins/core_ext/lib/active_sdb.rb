module ActiveSdb
  module Ext    
    def env
      @env ||= self[:env].nil? ? nil : self[:env].first
    end
    
    def table_name
      self.domain
    end
  end
  
  module ExtClass
    attr_accessor :abstract_class
    
    def get(id)
      get_cache(id) do
        rec = find(id)
        unless rec.nil?
          rec.reload
          rec
        end
      end
    end
      
    def get_attribute(*args)
      args.each do |attr|
        new_attr = attr.to_sym
        define_method(new_attr) do
          instance_eval %Q{@#{attr} ||= self[new_attr].nil? ? nil : self[new_attr].first}
        end
      end
    end
    
    def get_integer_from_attribute(*args)
      args.each do |attr|
        new_attr = attr.to_sym
        define_method(new_attr) do
          instance_eval %Q{ @#{attr} ||= self[new_attr].nil? ? nil : self[new_attr].first.to_i }
        end
      end
    end
    
    def get_date_from_attribute(*args)
      args.each do |attr|
        new_attr = attr.to_sym
        define_method(new_attr) do
          instance_eval %Q{ @#{attr} ||= self[new_attr].nil? ? nil : Time.parse(self[new_attr].first) }
        end
      end
    end
    
    def set_domain_name_by_env
      class_name = self.to_s.tableize
      d = case RAILS_ENV
        when "development"
          "dev_#{class_name}"
        when "test"
          "test_#{class_name}"
        when "production"
          class_name
      end
      set_domain_name d.to_sym
    end

    def base_class
      class_of_active_sbd_descendant(self)
    end
    
    def abstract_class?
      abstract_class == true
    end
    
    def class_of_active_sbd_descendant(klass)
      if klass.superclass == RightAws::ActiveSdb::Base || klass.superclass.abstract_class?
        klass
      elsif klass.superclass.nil?
        raise ActiveSdbError, "#{name} doesn't belong in a hierarchy descending from ActiveSdb"
      else
        class_of_active_sbd_descendant(klass.superclass)
      end
    end
  end
end