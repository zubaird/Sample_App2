module SessionsHelper

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.session_user = user 
	end

	def signed_in?
		!session_user.nil?
	end

	def session_user=(user)
		@session_user = user
	end

	def session_user
		@session_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def sign_out
		self.session_user = nil
		cookies.delete(:remember_token)
	end

end
