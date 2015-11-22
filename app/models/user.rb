class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable,
       :omniauthable, :omniauth_providers => [:google_oauth2]

     has_many :events

	/def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
	    data = access_token.info
	    user = User.where(:provider == access_token.provider, :uid == access_token.uid).first
	    if user
	      return user
	    else
	      registered_user = User.where(:email == access_token.info.email).first
	      if registered_user
	        return registered_user
	      else
	          user = User.create(name: data["name"],
	       	  token: access_token.credentials.token,
	          provider:access_token.provider,
	          email: data["email"],
	          uid: access_token.uid ,
	          password: Devise.friendly_token[0,20]
	        )
	      end
	   end
	end
	/

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
	    data = access_token.info
        registered_user = User.where(:email => access_token.info.email).first
        if registered_user
          print(access_token.info.email)
          print(registered_user.email)
          return registered_user
        else
          user = User.create(name: data["name"],
       	  token: access_token.credentials.token,
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20]
        )
      end
	end

end
