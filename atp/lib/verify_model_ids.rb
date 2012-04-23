module VerifyModelIds
	def verify_party_by_id
		@party_id = params[:id].to_i
		begin
			@party = Party.find @party_id
			if params[:event_id]
				@event = @party.events.find params[:event_id].to_i
			end
		rescue ActiveRecord::RecordNotFound
			flash['bad'] = "Party not found."
			redirect_back_or_default :action=>"index"
			return
		end
	end
end