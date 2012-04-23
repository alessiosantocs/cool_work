class SearchController < ApplicationController
require 'json'
require 'net/http'

require 'rubygems'


before_filter :require_user, :only => [:basicSearch, :globalSearch, :basicSearchDo, :globalSearchDo]

def basicSearch
    @subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
	@admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
	@a_str = "false"
	if @admin.to_s != "" 
			@a_str = params[:a_str]
			@subscribed = true 
	end

end 

def globalSearch
    @subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
	@admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
	@a_str = "false"
	if @admin.to_s != "" 
			@a_str = params[:a_str]
			@subscribed = true 
	end

end 


def basicSearchDo
        @subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
	@admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])

        @a_str = "false"
	if @admin.to_s != "" 
			@a_str = params[:a_str]
			@subscribed = true 
	end
	@q = params[:q]
	@companyList = params[:companyList]
	@results = ""
	@company_categories = []
	if @q != ""
		host = "127.0.0.1:9200"
		client = ElasticSearch.new(host, :index => "company", :type => "index-type1")

		@results = client.search("description:"+@q)

		logger.info(@results)
		logger.info(@results.hits)
                
		if @subscribed != "" && @results.size > 0 
                    @results.hits.each do|company|
                        company.segments_id.each do |segment_id|
                            @company_categories << { "category-id" => segment_id  , "company-id" => company._id }
                        end
                    end
	        else
                    @company_categories = ""
		end
	  end
  
    respond_to do |format|
      format.xml  
    end 
   end 


def globalSearchDo
    @subscribed = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"subscribed"])
	@admin = UserAttribute.find(:all, :conditions => ["user_id = ? AND name = ?", current_user,"admin"])
	@a_str = "false"
	if @admin.to_s != "" 
			@a_str = params[:a_str]
			@subscribed = true 
	end
	@q = params[:q]
	@companyList = params[:companyList]
	@results = ""
	@company_categories = []
	if @q != ""
		host = "127.0.0.1:9200"
		client = ElasticSearch.new(host, :index => "company", :type => "index-type1")
		@results = client.search(@q)		   
		if @subscribed != "" && @results.size > 0 
                    @results.hits.each do|company|
                        company.segments_id.each do |segment_id|
                            @company_categories << { "category-id" => segment_id  , "company-id" => company._id }
                        end
                    end
	        else
                    @company_categories = ""
		end
	end
  
    respond_to do |format|
      format.xml  
    end 
 end
end
