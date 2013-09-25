require 'spec_helper'

describe MicropostsController do
  render_views

  describe "for non-signed-in users" do
  	it "should deny access to 'create'" do
  		post :create
  		response.should redirect_to(signin_path)
  	end

  	it "should deny access to 'destroy'" do
  		delete :destroy, :id => 1
  		response.should redirect_to(signin_path)
  	end 
  end

  describe "POST 'create'" do
  	before(:each) do
  		@user = test_sign_in(Factory(:user))
  	end

  	describe "failure" do
  		before(:each) do
  			@var = { :content => "" }
  		end

  		it "should not create a micropost" do
  			lambda do
  				post :create, :micropost => @var
  			end.should_not change(Micropost, :count)
  		end

  		it "should render the home page" do
  			post :create, :micropost => @var
  			response.should render_template('pages/home') #root_path
  		end
  	end

  	describe "success" do
  		before(:each) do
  			@var = { :content => "Filler text" }
  		end

  		it "should create a micropost" do
  			lambda do
  				post :create, :micropost => @var
  			end.should change(Micropost, :count).by(1)
  		end

  		it "should redirect to the root path" do  #difference?
  			post :create, :micropost => @var
  			response.should redirect_to(root_path)
  		end

  		it "should have a flash success message" do
  			post :create, :micropost => @var
  			flash[:success].should =~ /Post created/i     
  		end

  	end

  end

end