require 'spec_helper'

describe "LayoutLinks" do
	it "should have a home page at '/'" do
		get '/'
		response.should have_selector('title', :content => "home")
	end
 	it "should have a contact page at '/'" do
		get '/'
		response.should have_selector('title', :content => "contact")
	end   
	it "should have a about page at '/'" do
		get '/'
		response.should have_selector('title', :content => "about")
	end
	it "should have a help page at '/'" do
		get '/'
		response.should have_selector('title', :content => "help")
	end
    
  end
end
