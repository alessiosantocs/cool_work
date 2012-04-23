require 'yaml'
class AdminGenerator < Rails::Generator::NamedBase
  def manifest
    @config = YAML::load(File.open("#{ENV['PWD']}/lib/generators/admin/templates/config.yml"))
    record do |m|
      m.class_collisions class_name
      m.template "app/views/index_template.rhtml", "app/views/#{file_name}/index.rhtml"
      m.directory File.join("app/views", file_name)
      m.template "app/views/layouts/admin.rhtml", "app/views/layouts/admin.rhtml"
      @editable_models = []
      editable_tables.each do |tbl|
        table_downcase = tbl.singularize.downcase
        @editable_models << table_downcase
        m.template "app/views/form_template.rhtml", "app/views/#{file_name}/new_#{table_downcase}.rhtml", :assigns => { :table => table_downcase, :exclude_columns => uneditable_columns }
        #m.template "app/controllers/ajax_scaffold_controller_template.rb", "app/controllers/#{tbl}_controller.rb", :assigns => { :table => table_downcase }
        #m.template "app/views/layouts/ajax_scaffold.rhtml", "app/views/layouts/#{tbl}.rhtml", :assigns => { :table => table_downcase }
      end
      m.template "app/controllers/controller_template.rb", "app/controllers/admin_controller.rb", :assigns => { :tables => @editable_models, :config => @config }
      m.template "app/views/structure_template.rhtml", "app/views/#{file_name}/structure.rhtml", :assigns => { :tables => @editable_models, :config => @config }
    end
  end
  
  def editable_tables
    ActiveRecord::Base.connection.tables.sort.reject! do |tbl|
      uneditable_tables.include?(tbl)
    end
  end
  
  protected
  def uneditable_tables
    [
      'schema_info', 'sessions', 'public_exceptions', 'cities_sites', 'regions_sites', 
      'engine_schema_info', 'parties_sites', "items_orders", "postal_codes", 
      "roles_users", "trackers", "services", "settings", "stats", "votes", "audits",
      "faves", "flags", "friends", "msgs", "phrases", "phrases_users", "ratings",
      "taggings", "tags"
    ]
  end
  
  def uneditable_columns
    ['id', 'created_on', 'updated_on', 'member_login_key', 'ip_address', 'password_salt', 'password_hash', 'obj_name', 'type']
  end
end