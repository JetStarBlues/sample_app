require 'spec_helper'

describe "LayoutLinks" do
	it "should have a home page at '/'" do
		get '/'
		response.should have_selector('title', :content => "Home")
	end
 	it "should have a contact page at '/'" do
		get '/contact'
		response.should have_selector('title', :content => "Contact")
	end   
	it "should have a about page at '/'" do
		get '/about'
		response.should have_selector('title', :content => "About")
	end
	it "should have a help page at '/'" do
		get '/help'
		response.should have_selector('title', :content => "Help")
	end
    it "should have a signup page at '/'" do
		get '/signup'
		response.should have_selector('title', :content => "Sign Up")
	end
	    it "should have a signup page at '/'" do
		get '/signin'
		response.should have_selector('title', :content => "Sign In")
	end
	it "should have the right links on the layout" do
		visit root_path
		response.should have_selector('title', :content => "Home")
		click_link "Contact"
		response.should have_selector('title', :content => "Contact")
		click_link "About"
		response.should have_selector('title', :content => "About")
		click_link "Help"
		response.should have_selector('title', :content => "Help")
		# click_link "Sign up now!"
		# response.should have_selector('title', :content => "Sign Up")
		click_link "Home"
		response.should have_selector('title', :content => "Home")
	end
end

# Lesson 55
describe "when not signed in" do
	it "should have a signin link" do
		visit root_path
		response.should have_selector("a", :href => signin_path,
										   :content => "Sign in")
	end
end
describe "when signed in" do

	before(:each) do
		@user = Factory(:user)
		visit signin_path
		fill_in :email,    :with => @user.email
		fill_in :password, :with => @user.password
		click_button
	end

	it "should have a signout link" do
		visit root_path
		response.should have_selector("a", :href => signout_path,
										   :content => "Sign out")
	end

	it "should have a profile link" do
		visit root_path
		response.should have_selector("a", :href => user_path(@user),
										   :content => "My profile")
	end

	it "should have a settings link" do
		visit root_path
		response.should have_selector("a", :href => edit_user_path(@user),
										   :content => "Settings")
	end

	it "should have a members link" do
		visit root_path
		response.should have_selector("a", :href => users_path,
										   :content => "Members")
	end

end

