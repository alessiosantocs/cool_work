class MsgController < ApplicationController
  skip_before_filter :site_data
  before_filter :login_required
  
  def create
    if request.post?
      @msg = Msg.blank(params[:msg])
      @msg.sender_id = session[:user][:id]
      if receiver = User.find_by_username(params[:msg][:username].to_s)
        @msg.receiver_id = receiver.id
      else
        ajax_response "#{params[:msg][:username]} doesn't exist"
        return false
      end
      if @msg.save
        ajax_response 'Message Sent.', true
      else
        ajax_response @msg.errors.full_messages.join('. ')
      end
    end
  end
  
  def read
    Msg.viewed_by(session[:user][:id], params[:id].to_i) unless params[:id].nil?
    ajax_response 'Message Read.', true
  end
  
  def list
    folder = params[:folder].nil? ? 'inbox' : params[:folder].to_s
    offset = params[:offset].nil? ? 0 : params[:offset].to_i
    #post
    if request.post? and params['msg'].size == 1
      ids = params['msg']['id'].collect{|v,k| v.to_i }
      if ids.size > 0
        case params[:submit].to_s
          when 'Delete'
            Msg.delete_msgs(session[:user][:id], folder, ids) if ids.size > 0
          when 'Report Spam'
            Msg.report_spam(session[:user][:id], folder, ids) if ids.size > 0
        end
      end
    end
    
    #do this
		case folder
			when 'inbox', 'sent'
			  case params[:do].to_s
			    when 'drop'
			      Msg.delete_msgs(session[:user][:id], folder, [params[:id].to_i]) unless params[:id].nil?
			    when 'flag_as_spam'
			      Msg.flag_as_spam(session[:user][:id], folder, [params[:id].to_i]) unless params[:id].nil?
			  end
		end
		get_folder_data(folder,offset)
  end
  
  private
  def get_folder_data(folder,offset)
		case folder
			when 'inbox', 'sent'
				@msgs = Msg.get_msg(session[:user][:id], folder, offset)
				@total = Msg.total_msgs(session[:user][:id], folder)
				txt = "Msg.all_msgs = #{@msgs.to_json}; serverTime=parseFloat("+ (("%10.5f" % Time.now.utc.to_f).to_f * 1000).to_s + "); Msg.msgs_in_#{folder}=#{@total}; "
				txt << "Msg.unread_msgs = " + Msg.total_unread_msgs(session[:user][:id]) + "; " if folder == 'inbox'
				ajax_response txt, true
			else
				ajax_response("The #{@folder} folder does not exist.")
				return false
		end
  end
end