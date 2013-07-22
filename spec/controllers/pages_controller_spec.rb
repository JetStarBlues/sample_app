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
  

  # Contact page
  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
    it "should have the correct title" do
      get 'home'
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
      get 'home'
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
      get 'home'
      response.should have_selector("title",
      :content => "RoR Sample App | Help")
    end   
  end

end
