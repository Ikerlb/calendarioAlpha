module PermissionsConcern
	extend ActiveSupport::Concern
		
	def is_normal_user?
		self.permission_level >=1
	end

	def is_teacher?
		self.permission_level>=2
	end

	def is_admin?
		sef.permission_level>=3
	end
end