class UsersController < ApplicationController
  before_filter :authenticate, :only=> [:edit, :update]   #Lesson 60
  
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
      sign_in @user
      #flash[:success] = "Welcome USER, a great journey begins!"
      flash[:success] = "Welcome #{@user.name} - A great journey begins!"
      redirect_to @user
      # same as, redirect_to user_path(@user)
      #redirect_to @user, :flash => { :success => "Welcome USER, a great journey begins!" }
    else
      @title = "Sign Up"
  	  render 'new'
      #page will include info about errors
    end
  end

  def edit   #Lesson 59
    @user  = User.find(params[:id])
    @title = "Settings"
  end

  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # update succesful
      flash[:success] = "Your changes have been saved!"
      redirect_to @user #profile page
    else
      # update failed
      @title = "Settings"
      render 'edit'
    end
  end

  private

    ##Created a generic 'deny_access' instead. See 'sessions_helper.rb'
    ##Lesson 60 @11:00
    # def authenticate   
    #   flash[:notice] = "You gotta sign in to access this page."
    #   redirect_to signin_path unless signed_in?
    # end
    def authenticate
      deny_access unless signed_in?
    end

end
