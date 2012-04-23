module MinusR

  def self.included(base)
    base.class_eval do
      alias_method_chain :create_template_source, :minus_r
      cattr_accessor :template_args
    end
  end
  
  def create_template_source_with_minus_r(extension, template, render_symbol, locals)
    extension ||= 'js'
    if extension.to_sym == :rjs
      body = "controller.response.content_type ||= 'text/javascript'\n" +
             "def js(data);data.to_json;end\n" +
             ERB.new(template, nil, ActionView::Base.erb_trim_mode).src
             
     ActionView::Base.template_args[render_symbol] ||= {}
     locals_keys = ActionView::Base.template_args[render_symbol].keys | locals
     ActionView::Base.template_args[render_symbol] = locals_keys.inject({}) { |h, k| h[k] = true; h }

     locals_code = ""
     locals_keys.each do |key|
       locals_code << "#{key} = local_assigns[:#{key}]\n"
     end

     "def #{render_symbol}(local_assigns)\n#{locals_code}#{body}\nend"
    else
      create_template_source_without_minus_r(extension, template, render_symbol, locals)
    end
  end
  
end

ActionView::Base.send :include, MinusR