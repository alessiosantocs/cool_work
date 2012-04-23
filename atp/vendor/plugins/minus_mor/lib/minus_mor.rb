module MinusMOR
  
  module Helpers
    def js(data)
      if data.respond_to? :to_json
        data.to_json
      else
        data.inspect.to_json
      end
    end
    
    def partial(name, options={})
      js render({ :partial => name }.merge(options))
    end
  end
  
  class View
    
    @@templates = {}
    
    def initialize(action_view)
      @action_view = action_view
    end
    
    def render(template, local_assigns)
      @action_view.controller.headers['Content-Type'] = 'text/javascript; charset=utf-8'
      assigns = @action_view.assigns.dup
      
      @action_view.instance_eval do 
        
        assigns.each { |k, v| instance_variable_set "@#{k}", v}
        
        local_assigns.each do |k, v|
          define_method k { v }
        end
        
      end
      
      @action_view.extend Helpers
      compiled(template).result(@action_view.send :binding)
    end
    
    def compiled(template)
      # TODO: storing and retrieving cached templates
      erb = ERB.new(template, nil, ActionView::Base.erb_trim_mode)
    end
      
  end
  
end