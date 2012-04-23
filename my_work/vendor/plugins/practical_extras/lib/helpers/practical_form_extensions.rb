module ActionView
  module Helpers
    module FormHelper
      FIELD_ERROR_OPTIONS = {:tag_name => 'dd', :class => 'FormError'}
      
      def field_error(object,field,*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = FIELD_ERROR_OPTIONS.merge(options)
        
        if (errors = object.errors.on(field))
          error_message = case
            when errors.is_a?(String)
              errors
            when errors.is_a?(Array)
              tag(:ul, nil, true) + (errors.collect { |e| content_tag(:li, e) }).to_s + "</ul>"
          end
          
          error_message = %{#{options[:prefix]} #{error_message}} if options[:prefix]
          
          content_tag(options[:tag_name], error_message, :class => options[:class])
        else
          ""
        end
      end
      
    end
    class FormBuilder
      def field_error(method, options={})
        @template.field_error(@object, method, options)
      end
      
      def method_missing_with_extra_magic(method_name,*args)
        if method_name.to_s =~ /_with_error$/
          fieldname = args.shift
          
          error_options =          
            if args.last.is_a?(Hash)
              args.last.delete(:error) || {}
            else
              {}
            end
          
          error_options.reverse_merge!({
            :tag_name => 'div'
          })
          
          field_error(fieldname,error_options).to_s +
          @template.content_tag(error_options[:tag_name], send(method_name.to_s.sub(/_with_error$/,""),fieldname,*args))
        else
          method_missing_without_extra_magic(method_name,*args)
        end
      end
      alias_method_chain :method_missing, :extra_magic
    end
  end
end