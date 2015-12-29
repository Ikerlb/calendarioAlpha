class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #def has_subjects
    #@has_subjects=HasSubject.where(user_id: current_user.id)
  #end

  #def create_subscription
    #HasSubject.create(user_id: current_user.id,subject_id: subject)
  #end

  protected

  def authenticate_teacher!
  	redirect_to root_path unless user_signed_in? && current_user.is_teacher?
  end

  def authenticate_admin!
  	redirect_to root_path unless user_signed_in? && current_user.is_admin?
  end

  def init_client
    client = Google::APIClient.new
    client.authorization.refresh_token=current_user.refresh_token
    client.authorization.access_token = current_user.fresh_token
    return client
  end

end
