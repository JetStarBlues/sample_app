require 'spec_helper'

describe PagesController do
  # Lesson 19 @4:00. Added as something to do with deleted files
  render_views

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end

    # Lesson 19 @2:00
    it "should have the correct title" do
      get 'home'
      response.should have_selector("title",
      :content => "Ruby on Rails Tutorial Sample App | Home")
    end

    # Lesson 19 @16:00
    # Cause generic layout used for the 3 pages, testing once likely to catch all
    it "should have a non-blank body" do
      get 'home'
      response.body.should_not =~ /<body>\s*<\/body>/
    end
  end


  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
  end


  # Manual added as page manually created
   describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

end
