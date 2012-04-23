require 'minus_mor'

# Assign a new template type
ActionView::Base::register_template_handler :ejs, MinusMOR::View

# Make respond_to :js default to .ejs then .rjs
ActionController::MimeResponds::Responder::DEFAULT_BLOCKS[:js] = %{
  Proc.new do
    begin
      render :action => "\#{action_name}.ejs", :content_type => Mime::JS
    rescue ActionController::MissingTemplate
      render :action => "\#{action_name}.rjs", :content_type => Mime::JS
    end
  end
}

# Try to exempt .ejs from layout but works only partially
# ActionController::Base.exempt_from_layout(/\.ejs$/)

# Nasty hack because exempt_from_layout doesn't quite work properly.
class ActionController::Base
  def template_exempt_from_layout?(template_name = default_template_name)
      @@exempt_from_layout.any? { |ext| template_name =~ ext } or
      [:ejs, :rjs].include?(@template.pick_template_extension(template_name))
  rescue
    false
  end
end

# More nasty hackery so that .ejs templates don't get read ahead of .rhtml
class ActionView::Base
  def find_template_extension_for(template_path)
    if (match = delegate_template_exists?(template_path)) && ( match.first.to_sym != :ejs)
      match.first.to_sym
    elsif erb_template_exists?(template_path):        :rhtml
    elsif builder_template_exists?(template_path):    :rxml
    elsif embedded_javascript_template_exists?(template_path): :ejs
    elsif javascript_template_exists?(template_path): :rjs
    else
      raise ActionViewError, "No rhtml, rxml, ejs, rjs or delegate template found for #{template_path} in #{@base_path}"
    end
  end
  
  def embedded_javascript_template_exists?(template_path)
    template_exists?(template_path, :ejs)
  end
end
  