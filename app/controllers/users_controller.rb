class UsersController < ApplicationController
  
  def show
  	#@user = User.find(1)
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def new
  	@user = User.new
  	@title = "Sign Up"
  end

  def create
  	@user = User.new(params[:user])
    if @user.save
      #handle a succesful save
      #flash[:success] = "Welcome USER, a great journey begins!"
      flash[:success] = "Welcome #{@user.name} - A great journey begins!"
      #redirect_to @user
      redirect_to user_path(@user)
      # same as, redirect_to user_path(@user)
      #redirect_to @user, :flash => { :success => "Welcome USER, a great journey begins!" }
    else
      @title = "Sign Up"
  	  render 'new'
      #page will include info about errors
    end
  end

end
