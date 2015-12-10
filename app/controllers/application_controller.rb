class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
