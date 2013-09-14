module SessionsHelper

	def sign_in(user)
		# permanent cookie Lesson 54 @ 9:00
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		current_user = user
	end

	def current_user=(user)
		@current_user = user    #sets an instance variable...?
	end

	def current_user
		# x+=3 is to x=x+3
		# @current_user = @current_user || user_from_remember_token
		# 		is to @current_user ||= user_from_remember_token
		@current_user ||= user_from_remember_token   #gets ...?
													 #something about make remember even if click new page
	end	

	def signed_in?
		!current_user.nil?
	end	

	def sign_out
		#delete cookie
		cookies.delete(:remember_token)
		current_user = nil
	end										 

	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)  #see below. Fx (found in User.rb) expects  
														  #2 args so need to unravel
		end

		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end


end

# cookies[:remember_token] = { :value   => user.id
# 							   :expires => 20.years.from_now.utc } #'forever'

# User.find_by_id(cookies[:remember_token])

# *
	# def ace(a,b)
	# 	a + b
	# end
	# ace(1,2)	  # => 3
	# ace([1,2])  # => ArgumentError. Expects two but reads one
	# ace(*[1,2]) # => 3. Asterick unravels

# ||=

