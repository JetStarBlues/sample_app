require 'spec_helper'

describe SessionsController do
	render_views

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "RoR Sample App | Sign In")
    end     
  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @var = { :email => "", :password => ""}
      end
      it "should re-render the 'new' page" do
        post :create, :sessions => @var
        response.should render_template('new')
      end
      it "should have the right title" do
        post :create, :sessions => @var
        response.should have_selector("title", :content => "RoR Sample App | Sign In")
      end
      it "should have an error message" do
        post :create, :sessions => @var
        flash.now[:error].should =~/invalid/i  #contain word invalid
      end
    end

    describe "success" do
      before(:each) do
        @user = Factory(:user)    #see Factories.rb under spec/
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :sessions => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      # it "should redirect to the user show page" do
      #   post :create, :sessions => @attr
      #   response.should redirect_to(user_path(@user))
      # end

      it "should redirect to the home page" do  #assuming feed and textbox are here
        post :create, :sessions => @attr
        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "should sign the user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

    
  
end
