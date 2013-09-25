class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]   #Lesson 60
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def show
  	#@user = User.find(1)
  	@user = User.find(params[:id])
    #@micropsts = @user.micropsts
    @microposts = @user.microposts.paginate(:page => params[:page])    
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
    # raise request.inspect <<allows you to what sent in request
    #@user  = User.find(params[:id])  #as already called in 'correct_user' >see Lesson62 @26:55
    @title = "Settings"
  end

  def update 
    #@user = User.find(params[:id])  #as already called in 'correct_user' >see Lesson62 @26:55
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

  def index
    # @users = User.all
    #paginate gem Lesson 61 @26:00
    @users = User.paginate(:page => params[:page])  #default of 30 per page
    @title = "Members"
  end

  def destroy
    #User.find(params[:id]).destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "The account '#{@user.name}' has been successfully deleted"  
    redirect_to users_path
  end

  
#=====

  private

    def correct_user
      # compare users
      @user = User.find(params[:id])  
      #redirect_to(root_path) unless @user == current_user
      redirect_to(root_path) unless current_user?(@user)   
          #alternate syntax. Created a method 'current_user?'
          #see SessionsHelper and Lesson 60 @30:00
    end

    def admin_user
      #redirect_to(root_path) unless current_user.admin?

      @user = User.find(params[:id])  
      # if current user is admin and not attempting to delete themselves 
        #redirect_to(root_path) unless (current_user.admin? && !current_user?(@user) )
      # alternate syntax
        redirect_to(root_path) if !current_user.admin? || current_user?(@user)
    end

end
