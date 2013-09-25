class SessionsController < ApplicationController
  
  def new
  	@title =  "Sign In"
  end

  def create
  	user = User.authenticate(params[:sessions][:email],
  							              params[:sessions][:password])
  	if user.nil?  #fail authentication
  		flash.now[:error] = "Invalid email/password combination"
  		@title = "Sign In"
  		render 'new'
  	else
  		#successful signin
      sign_in user
      flash[:success] = "Great to see you again!"
      #redirect_to user        # Redirect to profile page
      #redirect_back_or user   # Lesson 60 (redirect to pg user was trying to access before sign_in OR to profile)
      redirect_back_or root_path   # redirect to pg user was trying to access before sign_in OR to home


    end
  end

  def destroy
  	#lesson 55 @4:15
    sign_out
    redirect_to root_path
  end


end
