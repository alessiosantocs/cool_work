module Cache
  module ClassMethods
    def get_cache(*args)
      id = args.first
      options = args.last.is_a?(Hash) ? args.pop : {}
      Rails.cache.fetch("#{self.name.downcase.pluralize}/#{id}", options) do 
        if block_given?
          yield
        else
          find(id)
        end
      end
    end
    
    def expire_cache(delete_key)
      Rails.cache.delete(self.name.downcase.pluralize + "/#{delete_key}")
    end
  end
  
  module InstanceMethods
    def get_cache(*args)
      key = args.first
      options = args.last.is_a?(Hash) ? args.pop : {}
      Rails.cache.fetch("#{self.cache_key}/#{key}", options){ yield }
    end
    
    def expire_cache(delete_key=nil)
      key = self.cache_key
      key << "/#{delete_key}" unless delete_key.nil?
      Rails.cache.delete key
    end

    def clear_cache
      if self.respond_to? :cache_needs_to_be_cleared
        cache_needs_to_be_cleared
      end
    end
    
    # def caches(meth, *args)
    #   key = args.first
    #   options = args.last.is_a?(Hash) ? args.pop : {}
    #   Rails.cache.fetch("#{self.cache_key}/#{meth.to_s}", options) do
    #     self.class.send meth, 
    #   end
    # end
  end
end