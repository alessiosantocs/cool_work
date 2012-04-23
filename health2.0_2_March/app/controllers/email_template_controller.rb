class EmailTemplateController < ApplicationController
    uses_tiny_mce

  def template_data_take
     @all_template=EmailTemplate.new()
     if params[:all_template]
     @all_template[:template_name]=params[:all_template][:template_name]
     @all_template[:template_data]=params[:all_template][:template_data]
     @all_template.save
     redirect_to :action=>"show",:controller=>"companies",:id=>params[:all_template][:company_id]
     else
     @all_template[:template_name]=params[:template_name]
     @all_template[:template_data]=params[:template_data]
     @all_template.save
     redirect_to new_email_tracker_path 
     end  
  end

  def template_update

     @all_template=EmailTemplate.find(params[:id])
     @all_template[:template_name]=params[:template_name]
     @all_template[:template_data]=params[:template_data]
     @all_template.save
     redirect_to give_all_template_email_template_path
  end
  
  def destroy_template
    @all_template = EmailTemplate.find(params[:id])
    @all_template.destroy
    respond_to do |format|
        format.xml  { render :xml => @all_template }
        end
  end

  def give_all_template
    @all_template=EmailTemplate.all 
  end

  def new
 end

  def edit_template
    @edit_template=EmailTemplate.find(params[:id])
  end
    def add_template

    @all_template=EmailTemplate.new
     render :layout=>false
    end

end
