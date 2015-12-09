class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable,
       :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many  :subjects


	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
		print(access_token)
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

	include PermissionsConcern	

end
