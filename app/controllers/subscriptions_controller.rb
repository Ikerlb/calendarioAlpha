class SubscriptionsController < ApplicationController

	def index
		@subscriptions=current_user.subscriptions
	end

	def create
		client=init_client
		service = client.discovered_api('calendar', 'v3')
		@subscription=Subscription.where(user_id: current_user.id, subject_id: params[:subject_id])
		unless @subscription.present?
			sub=Subscription.create(user_id: current_user.id,subject_id: params[:subject_id])
			entry={'id' => sub.subject.google_calendar_id}
			result = client.execute(:api_method => service.calendar_list.insert,
                        :body => JSON.dump(entry),
                        :headers => {'Content-Type' => 'application/json'})
		end
		redirect_to subscriptions_path+"/"
	end

	def destroy
		client=init_client
		service = client.discovered_api('calendar', 'v3')
		@subscription=Subscription.find(params[:id])
		if @subscription.present?
			calendar_id=@subscription.subject.google_calendar_id
    		@subscription.destroy
			result = client.execute!(:api_method => service.calendar_list.delete,
		            :parameters => {'calendarId' => calendar_id})
	    end
    	redirect_to subscriptions_path+"/"
	end

end