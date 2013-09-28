require 'spec_helper'

describe PagesController do
  # Lesson 19 @4:00. Added as something to do with deleted files
  render_views

  # Lesson 26 @18:00 ...Defining a local variable
  # Seems redundant to me....
  #before(:each) do
  #  @base_title = "RoR Sample App"
  #end

  describe "GET 'home'" do

    describe "when not signed in" do
      it "returns http success" do
        get 'home'
        response.should be_success
      end

      # Lesson 19 @2:00
      it "should have the correct title" do
        get 'home'
        response.should have_selector("title",
        :content => "RoR Sample App | Home")
        #see lesson 26 @18:00
        # :content => "#{@base_title} | Home")
      end

      # Lesson 19 @16:00
      # Cause generic layout used for the 3 pages, testing once likely to catch all
      it "should have a non-blank body" do
        get 'home'
        response.body.should_not =~ /<body>\s*<\/body>/
      end
    end

    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have right follower/following counts" do
        get :home
        response.should have_selector('a', :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector('a', :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end

  end
  

  # Contact page
  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
    it "should have the correct title" do
      get 'contact'
      response.should have_selector("title",
      :content => "RoR Sample App | Contact")
    end
  end


  # About page
   describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
    it "should have the correct title" do
      get 'about'
      response.should have_selector("title",
      :content => "RoR Sample App | About")
    end   
  end


  # Help page
   describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      response.should be_success
    end
    it "should have the correct title" do
      get 'help'
      response.should have_selector("title",
      :content => "RoR Sample App | Help")
    end   
  end

end
