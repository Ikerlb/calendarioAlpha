require 'net/http'
require 'json'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable,
       :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many  :subjects


	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    registered_user = User.where(:email => access_token.info.email).first
    if registered_user
      return registered_user
    else
      user = User.create(name: data["name"],
   	  token: access_token.credentials.token,
      refresh_token: access_token.credentials.refresh_token,
      provider:access_token.provider,
      email: data["email"],
      uid: access_token.uid ,
      password: Devise.friendly_token[0,20]
    )
    end
	end

  def to_params
    {'refresh_token'=>refresh_token,
      'client_id'=>Rails.application.secrets.client_id,
      'client_secret'=>Rails.application.secrets.client_secret,
      'grant_type'=>'refresh_token'
    }
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
    token: data['access_token'],
    expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end

  def expired?
    unless expires_at
      return true   
    end
    expires_at < Time.now 
  end

  def fresh_token
    refresh! if expired?
    token
  end

	include PermissionsConcern	

end
