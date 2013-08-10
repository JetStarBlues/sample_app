require 'spec_helper'

#Lesson 48
describe "Users" do

  describe "signup" do

  	describe "failure" do
  		it "should not make a new user" do
  			lambda do
	  			visit signup_path
	  			fill_in "Name",				:with => ""
	  			fill_in	"Email",			:with => ""
	  			fill_in "Password",			:with => ""
	  			fill_in "Confirm password",	:with => ""
	  			click_button
	  			response.should render_template('users/new')
	  			response.should have_selector('div#signupError')  #id
	  		end.should_not change(User, :count)
  		end
  	end  

  	describe "success" do
  		it "should make a new user" do
  			lambda do
	  			visit signup_path
	  			fill_in "Name",				:with => "exampleUser"
	  			fill_in	"Email",			:with => "user@example.com"
	  			fill_in "Password",			:with => "superSecret"
	  			fill_in "Confirm password",	:with => "superSecret"
	  			click_button
	  			response.should have_selector('div.flash.success')   #class
	  			response.should render_template('users/show') 
	  		end.should change(User, :count).by(1)
  		end
  	end 


  end
end
