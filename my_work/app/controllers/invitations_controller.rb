class InvitationsController < ApplicationController
  before_filter :login_required
  require_role "accounts", :only => [:show]
  filter_parameter_logging :number
  
  def index
    @invitations = Invitation.find(:all)
  end
  
  def new
    @invitation = Invitation.new
    render :layout => false
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender_id = current_user.id
    if @invitation.save
        ip_addr = 'http://' + ( RAILS_ENV == 'production' ? "www.myonlinecleaner.com" : "staging.myonlinecleaner.com" )
#         ip_addr = "http://192.168.1.3:3000"
        Notifier.deliver_invitation_notification(@invitation, self.current_user, ip_addr+"/signup/#{@invitation.token}")
#        Mailer.deliver_invitation(@invitation, "http://www.myfreshshirt.com/signup/#{@invitation.token}")
        flash[:notice] = "Thank you, invitation sent."
        redirect_to invitations_customer_path(current_user.account)
    else
      error = @invitation.errors[:base]
      flash[:error] = error.blank? ? "There is some error occurs, Invitation cann't be sent . Try again!!" : error
      redirect_to invitations_customer_path(current_user.account)
    end
  end
  
end
