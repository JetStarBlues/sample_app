require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
  #lesson 42
    before(:each) do
      @user = Factory(:user)
    end

    it "should be succesful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end    

    it "should have the right title" do
      get :show, :id => @user
      #response.should have_selector("title", :content => "RoR Sample App | " + @user.name)
      response.should have_selector("title", :content => "RoR Sample App | #{@user.name}")
    end   

    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector('h2', :content => "#{@user.name}")
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h2>img', :class => "gravatar")
    end

  end
 



  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "RoR Sample App | Sign Up")
    end 


  end

end
