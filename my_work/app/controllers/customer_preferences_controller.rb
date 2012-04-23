class CustomerPreferencesController < ApplicationController
  before_filter :login_required, :only => [:update]
  
  def update
    @customer_preferences = CustomerPreferences.find(params[:id])
    
    respond_to do |format|
      if @customer_preferences.update_attributes(params[:customer_preferences])
        flash[:notice] = 'Preferences updated.'
        format.html {
          if !params[:redirect_to].blank?
            redirect_to params[:redirect_to] 
          else
            redirect_to fresh_order_customer_path(@customer_preferences.customer) 
          end
        }
        format.xml  { head :ok }
      else
        flash[:error] = 'Preferences not updated.'
        format.html { redirect_to :back }
        format.xml  { render :xml => @stop.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def unsubscribe_promotion
    @customer_preferences = CustomerPreferences.find_by_customer_id(params[:customer_id])
    if @customer_preferences
      if @customer_preferences.update_attributes(:promotion_email => false)
        flash[:promotion_notice] = "Your unsubscribe promotion request completed sucessfully."
        redirect_to root_url
      else
        flash[:error] = "problem in unsubscribe promotion request, Please contact customer service."
        redirect_to root_url
      end
    else
      flash[:promotion_error] = "problem in unsubscribe promotion request, Please contact customer service."
      redirect_to root_url
    end
  end

end
