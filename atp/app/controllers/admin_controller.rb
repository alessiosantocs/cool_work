class AdminController < ApplicationController
  before_filter :super_admin_required, :except => [:index, :party, :parties_autocomplete, :find_parties, :parties]
  before_filter :regional_rep_required, :only => [:party, :parties_autocomplete, :find_parties, :parties]
  layout "admin"
  
  def initialize
    @page_title = String.new
    @breadcrumb = Breadcrumb.new
    @page_title = ""
  end
  
  def index;end
  def parties;end
  
  def mailing_list
    return false unless ["joemocha", "newjeruz"].include?(self.current_user[:username]) #
    if request.post?
      time = Time.now.utc
      list = User.get_mailing_list_since(Time.utc(params["date"]["year"], params["date"]["month"], params["date"]["day"]))
      if list.size > 0
        send_data(list.join("\n"), :type => '*.txt', :filename => params["date"].values.join('-')+"_to_#{time.month}-#{time.day}-#{time.year}.txt")
      else
        flash[:bad] = "No users found"
      end
    end
  end
  
  def reset_password
    return false unless ["joemocha", "newjeruz"].include?(self.current_user[:username]) #
    @user = []
    if request.post?
		  user = User.find params[:u][:id]
			if user.update_attributes(params[:u])
			  flash[:good] =  "#{user.username} Updated"
			else
				flash[:bad] = "User Not Updated. #{user.errors.full_messages.join('. ')}"
			end
  	else
      unless params[:query].nil?
        q=params[:query].to_s.strip
        @user = User.find_like_by_email_or_username(q)
      end
		end
  end
  
  def party
    if request.post?
		  party = Party.find params[:party][:id]
			if party.update_attributes(params[:party])
			  ajax_response "Party Updated", true
			else
				ajax_response "Party Not Updated. #{party.errors.full_messages.join('. ')}"
			end
		end
  end
  
  def parties_autocomplete
    error_exists = false
    error_text = ""
    if params[:query].nil?
      ajax_response "<ul><li>no results</li></ul>", true
      return
    end
    q=params[:query]    
    case q
      when /id:/ #id
        id = q.sub(/id:/,'').strip.to_i
        if id > 0
          @party = Party.find(id) rescue nil
        end
        unless @party.nil?
          ajax_response "<ul><li>id: #{@party.id}</li></ul>", true
        else
          ajax_response "<ul><li>id:</li></ul>", true
        end
      when /vn:/ #venue
        term = q.sub(/vn:/,'').strip
        @venue = Venue.find_all_by_name(term) if term.length > 3
        render :inline => "<%= auto_complete_result(@venue, 'name') %>"
      when /user:/ #user
        term = q.sub(/user:/,'').strip
        @user = User.find_all_by_username(term) if term.length > 3
        render :inline => "<%= auto_complete_result(@user, 'username') %>"
      else #party title
        term = q.strip
        @party = Party.find_all_by_title(term) if term.length > 3
        render :inline => "<%= auto_complete_result(@party, 'title') %>"
    end
  end
  
  def find_parties
    error_exists = false
    error_text = ""
    if params[:query].nil?
      ajax_response "[]", true
      return
    end
    q = process_query(params[:query])  
    conditions = create_query(q)
    @party = ( conditions.strip.length > 1 ? Party.find(:all, :conditions => conditions, :include =>[:venue, :user], :limit => 15, :order => "parties.active desc, parties.id desc") : [])
		respond_to do |wants|
			wants.js do
			  render :inline => @party.to_json(:include =>[:venue, :user])
			end
		end
  end
  
  private
  def process_query(str)
    last_qualifier = nil
    strings_qualifiers = [:vn, :user, :title]
    qualifiers={:vn =>[], :id=> nil, :user=> [], :zip => nil, :title => []}
    str.split(/ /).each do |w|
      case w
        when /id:/ #id
          id = w.sub(/id:/,'').strip.to_i
          qualifiers[:id] = id if id > 0
          last_qualifier = :id
        when /vn:/ #venue
          qualifiers[:vn] << w.sub(/vn:/,'').strip unless w.sub(/vn:/,'').strip.empty?
          last_qualifier = :vn
        when /user:/ #user
          qualifiers[:user] << w.sub(/user:/,'').strip unless w.sub(/user:/,'').strip.empty?
          last_qualifier = :user
        when /zip:/ #zip
          qualifiers[:zip] = w.sub(/zip:/,'').strip
          last_qualifier = :zip
        when /title:/ #title
          qualifiers[:title] << w.sub(/title:/,'').strip unless w.sub(/title:/,'').strip.empty?
          last_qualifier = :title
        else #party title
          if strings_qualifiers.include?(last_qualifier)
            qualifiers[last_qualifier] << w.strip
          else
            qualifiers[last_qualifier] = w.strip
          end
      end
    end
    strings_qualifiers.each do |q|
      qualifiers[q] = (qualifiers[q].size > 0 ? qualifiers[q].join(" ") : nil )
    end
    return qualifiers.reject!{|k,v| v.nil? }
  end

  def create_query(qualifiers)
    query = []
    qualifiers.each do |k,v|
      case k
        when :id #id
          query << "parties.id=#{v.to_i}"
        when :vn #venue
          query << "LOWER(venues.name) LIKE '%#{v}%'"
        when :user #user
          query << "LOWER(users.username) LIKE '%#{v}%'"
        when :zip #zip
          query << "venues.postal_code='#{v}'"
        when :title #title
          query << "LOWER(parties.title) LIKE '%#{v}%'"
      end
    end
    query.join(" AND ") 
  end
end