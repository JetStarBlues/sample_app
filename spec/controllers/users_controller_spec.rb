require 'spec_helper'

describe UsersController do
  render_views

  #---
  describe "GET 'index'" do
    describe "for non-signed-in users" do
      it "should deny acces to 'index'" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do
      before (:each) do
        #see Spec_Helper.rb for 'test_sign_in' method
        # alternate syntax. See lesson 61 @5:30
        @user = test_sign_in(Factory(:user))

        Factory(:user, :email => "anotheruser@example.com")
        Factory(:user, :email => "anotheruser2@example.com")

        #to test pagination
        30.times do
          Factory(:user, :email => Factory.next(:email) ) 
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Members")
      end

      it "should have an element for each user" do
        get :index
        #User.all.each do |user|
        User.paginate(:page => 1).each do |user|        
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        #previous arrow disabled on pg 1
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2" , 
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2" , 
                                           :content => "Next")
      end

      it "should have delete links for admins" do
        @user.toggle!(:admin)
        other_user = User.all.second
        get :index
        response.should have_selector("a", :href => user_path(other_user),
                                           :content => "delete")
      end

      it "should not have delete links for non-admins" do
        other_user = User.all.second
        get :index
        response.should_not have_selector("a", :href => user_path(other_user),
                                               :content => "delete")
      end

    end
  end

  #---
  describe "GET 'show'" do
  #Lesson 42 (User Profile Page)
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
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
      response.should have_selector('h1', :content => "#{@user.name}")
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => "gravatar")
    end

    # @ 31:00
    it "should have the right URL" do
      get :show, :id => @user
      response.should have_selector('div>a', :content => user_path(@user),
                                             :href    => user_path(@user))
    end
  end
 
  #---
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

  #---
  #Lesson 46 (SignUp page)
  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @var = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end

      it "should have the right title" do
        post :create, :user => @var
        response.should have_selector("title", :content => "RoR Sample App | Sign Up")
      end

      it "should re-render the 'new' page" do
        post :create, :user => @var
        response.should render_template('new')
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @var
        end.should_not change(User, :count)
      end
    end

    describe "success" do
        
      before(:each) do
        @var = { :name => "exampleUser", :email => "user@example.com", :password => "superSecret", :password_confirmation => "superSecret" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @var
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @var
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @var
        #change it up to flash user's name
        flash[:success].should =~ /Welcome #{@var[:name]} - A great journey begins!/     
        #flash[:success].should =~ /welcome USER, a great journey begins!/i    ...the i makes it case-insensitive
      end

      #Lesson 55 @10:00
      it "should sign the user in" do
        post :create, :user => @var
        controller.should be_signed_in
      end
     
    end
  end  

  #---
  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Settings" )
    end

    it "should have a link to change Gravatar" do
      get :edit, :id => @user
      response.should have_selector('a', :href => "https://gravatar.com", 
                                         :content => "change")
    end
  end

  #---
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @var = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        # wtf? - Lesson 59 @21:30
        put :update, :id   => @user,
                     :user => @var  #overrides factory name and password?
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id   => @user, :user => @var
        response.should have_selector('title', :content => "Settings")
      end

    end

    describe "success" do
      before(:each) do
        @var = { :name => "exampleUser2", :email => "user2@example.com", :password => "superSecret2", :password_confirmation => "superSecret2" }
      end

      it "should change the user's attributes" do
        put :update, :id   => @user, :user => @var
        user = assigns(:user)
        @user.reload  #check if updated DB
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end

      it "should have a flash message" do
        put :update, :id   => @user, :user => @var
        flash[:success].should =~  /saved/
      end
    end
  end

  describe "authentication of edit/update actions" do
    before(:each) do
      @user = Factory(:user)
      # haven't signed in 'test_sign_in(@user)'
    end

    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
        wrong_user = Factory(:user, :email => "wrong@email.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)        
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)        
      end
    end
  end

  #---
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
      it "should deny access to 'destroy'" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "for non-admin users" do
      it "should deny access to 'destroy'" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "for signed-in admins" do

      before(:each) do
        @admin = Factory(:user, :email => "daBauss@example.com",
                                :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should return to the 'index' page" do
        delete :destroy, :id => @user
        flash[:success].should =~ /deleted/i
        response.should redirect_to(users_path)
      end

      it "should not be able to destroy themselves" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count)        
      end

    end

  end

end
