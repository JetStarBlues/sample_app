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

	describe "from_users_followed_by" do
		before(:each) do
			@other_user = Factory(:user, :email => Factory.next(:email))
			@third_user = Factory(:user, :email => Factory.next(:email))

			@user_post = @user.microposts.create!(:content => "I am numero uno")
			@other_user_post = @other_user.microposts.create!(:content => "Nah, I am the top dog")
			@third_user_post = @third_user.microposts.create!(:content => "Just chilling")

			@user.follow!(@other_user)
		end

		it "should have a from_users_followed_by method" do
			Micropost.should respond_to(:from_users_followed_by)
		end

		it "should include the followed user's microposts" do
			Micropost.from_users_followed_by(@user).
				should include(@other_user_post)
		end

		it "should include the user's own microposts" do
			Micropost.from_users_followed_by(@user).
				should include(@user_post)
		end

		it "should not include an unfollowed user's microposts" do
			Micropost.from_users_followed_by(@user).
				should_not include(@third_user_post)
		end
	end


end
