# class Base
#   @@exempt_from_layout = Set.new([/\.rjs$/])
#   class << self
#     def exempt_from_layout(*extensions)
#       regexps = extensions.collect do |extension|
#         extension.is_a?(Regexp) ? extension : /\.#{Regexp.escape(extension.to_s)}$/
#       end
#       @@exempt_from_layout.merge regexps
#     end
#   end
#   
#   protected
#   def render_action(action_name, status = nil, with_layout = true) #:nodoc:
#     template = default_template_name(action_name.to_s)
#     if with_layout && !template_exempt_from_layout?(template)
#       render_with_layout(:file => template, :status => status, :use_full_path => true, :layout => true)
#     else
#       render_without_layout(:file => template, :status => status, :use_full_path => true)
#     end
#   end
#   
#   private
#   def template_exempt_from_layout?(template_name = default_template_name)
#     @@exempt_from_layout.any? { |ext| template_name =~ ext } or
#       @template.pick_template_extension(template_name) == :rjs
#   rescue
#     false
#   end
# end

require 'minus_r'