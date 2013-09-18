require 'spec_helper'

describe Micropost do
	before(:each) do
		@user = Factory(:user)
		@var = { :content => "filler text", :user_id => 1 }
	end

	it "should create a new instance with valid attributes" do
		@user.microposts.create!(@var)
	end

	describe "user associations" do
		before(:each) do
			@micropost = @user.microposts.create(@var)
		end

		it "should have a user attribute" do
			@micropost.should respond_to(:user)
		end
	
		it "should have the right associated user" do
			@micropost.user_id.should == @user.id
			@micropost.user.should == @user
		end
	end

	describe "validations" do
		it "should have a user id" do
			Micropost.new(@var).should_not be_valid
		end

		it "should require nonblank content" do
			@user.microposts.build(:content => "  ").should_not be_valid
		end

		it "should reject long content" do
			#150 limit (Twitter is 140)
			@user.microposts.build(:content => "a" * 151).should_not be_valid
		end

	end


end
