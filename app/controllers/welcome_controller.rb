class WelcomeController < ApplicationController
	before_action :validate_user

  def index
  end



  private
  
  def validate_user
  	unless user_signed_in?
  		redirect_to new_user_session_path
  	end
  end

end
