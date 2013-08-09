class UsersController < ApplicationController
  
  def show
  	#@user = User.find(1)
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def new
  	@title = "Sign Up"
  end

end
