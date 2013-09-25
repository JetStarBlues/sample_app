require 'spec_helper'

describe "FriendlyForwards" do
it "should forward to the requested 'edit' page after signin" do
# see SessionsController.rb and SessionsHelper
	user = Factory(:user)
	visit edit_user_path(user)
	# sign in as per redirect
	fill_in :email, :with => user.email
	fill_in :password, :with => user.password
	click_button
	response.should render_template('users/edit')
	# check if sends to /*profile*/ home page after signout then signin
	visit signout_path
	visit signin_path
	fill_in :email, :with => user.email
	fill_in :password, :with => user.password
	click_button
	#response.should render_template('users/show')
	response.should render_template(root_path)
end
  
end
