class AdminController < ApplicationController
  before_filter :super_admin_required
  layout "admin", :except => ["create", "update", "new", "search", "list", "structure"]
  
  def initialize
    @page_title = String.new
    @breadcrumb = Breadcrumb.new
    @page_title = ""
  end
  
  def index
    if params[:section]
      @page_title << " #{params[:section].capitalize}"
      render :template => "admin/#{params[:section]}/#{params[:action]}"
    end
  end
  
  def structure
    @headers["content-type"] = "text/javascript"
    render :layout => false
  end
  
  def search
    #process query
    if !params[:q].nil?
      q = params[:q]
      section = params[:section].capitalize
    elsif !params["#{params["relation"]}"].nil?
      q = params["#{params["relation"]}"]
      section = params["relation"].capitalize
    elsif params[:q].nil? || params[:q].length < 3
      render :nothing => true
      return
    end
    
    q = q.downcase.strip.gsub('the ','')
    show = params[:show] || ""
    query_hash = Hash.new
    case section
      <% tables.each do |t| -%>
        <% if config[t]["searchable"] %>
      when '<%= t.capitalize %>'
        query_hash = { :include => <%= t.to_s.camelize.constantize.reflect_on_all_associations(:belongs_to).collect{|r| r.name.to_sym }.to_json %>, :conditions => <%= config[t]["search"]["conditions"].to_json %>, :show => <%= config[t]["search"]["show"].to_json %>, :order => "<%= config[t]["search"]["order"] %>" }
        <% end -%>
      <% end -%>
      else
        render :inline => "No section selected or Model name changed or new model added."
        return
    end
    if q.length > 1
      q_split = q.split('|').compact
      if q_split.length == 1
        query_condition = query_hash[:conditions].collect{|field| "LOWER(#{field}) LIKE \"#{q}%\" " }.join(" OR ")
        find_options = {
          :conditions => query_condition,
          :order => query_hash[:order],
          :limit => 25 }
        case show.strip
          when 'autocomplete'
            @items = section.to_s.camelize.constantize.find(:all, find_options)
            unless params['relation'].nil?
              query_hash[:show] << "id" #added id to be passed through callback function
              ajax_response "<%%= auto_complete_result_with_callback @items, " + query_hash[:show].to_json + ", '#{params['relation']}' %>", true
            else
              ajax_response "<%%= auto_complete_result @items, '" + query_hash[:show].first + "' %>", true
            end
          else
            find_options[:include] = query_hash[:include]
            @items = section.to_s.camelize.constantize.find(:all, find_options)
            if @items.empty?
              ajax_response "No #{section} found matching '#{q}'"
            else
              ajax_response @items.to_json, true
            end
        end 
      elsif q_split.length > 1
        query_condition = q_split.collect{|term| "LOWER(#{query_hash[:conditions].first}) LIKE \"%#{term.strip}%\" " }.join(" OR ")
        find_options = {
          :conditions => query_condition,
          :order => query_hash[:order],
          :limit => 25 }
        @items = section.to_s.camelize.constantize.find(:all, find_options)
        if @items.empty?
          ajax_response "No #{section} found matching '#{params[:q]}'"
        else
          ajax_response @items.to_json, true
        end
      end
    else
      render :nothing => true
    end
  end
  
  def list
  end

  def show
  end
  
  def create
    if params[:section]
      #Try to create a blank template for all models
      render :template => "admin/new_#{params[:section]}", :layout => false
    end
  end
  
  def new
    if params[:section]
      section = params[:section].downcase
      @item = section.to_s.camelize.constantize.new(params[section])
      if @item.save
        ajax_response "", true
      else
        ajax_response @item.errors.full_messages.join(". ")
      end
    end
  end
  
  def update
    if params[:section]
      id = params[:id].to_i
      field = params[:field].strip
      section = params[:section].strip
      value = params[:value].strip
      @item = section.to_s.camelize.constantize.find(params[:id].to_i) #, :select => "id, #{field}"
      if @item.update_attributes({ field => value })
#      @item = section.to_s.camelize.constantize.update(id, { field => value })
#      if @item.errors.count == 0
        ajax_response value, true
      else
        ajax_response @item.errors.full_.join(". ")
      end
    end
  end
end