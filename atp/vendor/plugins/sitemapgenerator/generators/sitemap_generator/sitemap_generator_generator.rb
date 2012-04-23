class SitemapGeneratorGenerator < Rails::Generator::NamedBase
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name,
                :frequency
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  
  def initialize(args, opts = {})
    super
    @controller_name = args.shift
    @frequency       = args.shift
    
    @controller_name ||= ActiveRecord::Base.pluralize_table_names ? @name.pluralize : @name

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_singular_name, @controller_plural_name = inflect_names(base_name)

    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
    
  end
  
  def manifest      
    record do |m|
      m.class_collisions controller_class_path, 
        "#{controller_class_name}Controller", 
        #"#{controller_class_name}ControllerTest", 
        "#{controller_class_name}Helper"

      m.class_collisions class_path, "#{class_name}" #"#{class_name}Test"
      m.class_collisions [], 'Sitemap'
      
      m.template 'controller.rb',     File.join('app/controllers',controller_class_path, "#{controller_file_name}_sitemap_controller.rb")
      m.template 'sitemaps_controller.rb',     File.join('app/controllers',controller_class_path, "sitemaps_controller.rb")
      m.template "sitemap.rxml",      File.join("app/views", controller_class_path , controller_file_name, "sitemap.rxml")
      m.template "index.rxml",        File.join("app/views", controller_class_path , "sitemap.rxml")
      m.template 'helper.rb',         File.join('app/helpers', controller_class_path, "#{controller_file_name}_sitemap_helper.rb")
      #m.template 'sitemaps_helper.rb',         File.join('app/helpers', controller_class_path, "sitemaps_helper.rb")
      m.template 'functional_test.rb',File.join('test/functional',controller_class_path, "#{controller_file_name}_sitemap_controller_test.rb")
    end
  end
end
