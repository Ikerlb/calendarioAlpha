class SubscriptionsController < ApplicationController

	def index
		@subscriptions=Subscription.where(user_id:current_user.id)
	end

	def create
		@subscription=Subscription.where(user_id: current_user.id, subject_id: params[:subject_id])
		unless @subscription.present?
			Subscription.create(user_id: current_user.id,subject_id: params[:subject_id])
		end
		redirect_to subscriptions_path+"/"
	end

	def destroy
		@subscription=Subscription.find(params[:id])
		if @subscription.present?
    	@subscription.destroy
    end
    redirect_to subscriptions_path+"/"
	end

end