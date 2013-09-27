require 'spec_helper'

describe User do

  before(:each) do
  	@var = {
      :name => "exampleUser", 
      :email => "user@example.com",
      :password => "superSecret",
      :password_confirmation => "superSecret"
    }
  end

#Lesson 36 @7:00
  it "should create a new instance given a valid attribute" do
  	User.create!(@var)
  end

  it "should require a name" do
  	#replace 'exampleUser' with blank
  	noNameUser = User.new(@var.merge(:name => ""))
  	noNameUser.should_not be_valid
  end

  it "should require an email address" do
  	noNameUser = User.new(@var.merge(:email => ""))
  	noNameUser.should_not be_valid
  end

  it "should reject names that are too long" do
  	longName = "a" * 51
  	longNameUser = User.new(@var.merge(:name => longName))
  	longNameUser.should_not be_valid
  end

 #by no means robust...(domains,length,@symbol ...see user.rb 'email_regex')
  it "should accept valid email address" do
  	addr = %w[diamond@casino.com spades@casino.org queen.hearts@casino.uk queen-hearts@casino.uk spades@2casino.org spades@2_casino.org]
  	addr.each do |addr|
  		validEmailUser = User.new(@var.merge(:email => addr))
  		validEmailUser.should be_valid
  	end
  end
 #by no means robust...(typos...abc@aol.orgg)
  it "should reject invalid email address" do
  	addr = %w[diamond@casino,com spades@a.com]
  	addr.each do |addr|
  		invalidEmailUser = User.new(@var.merge(:email => addr))
  		invalidEmailUser.should_not be_valid
  	end
   end

  it "should reject duplicate emails" do
  	User.create!(@var)
  	userWithDuplicateEmail = User.new(@var)
  	userWithDuplicateEmail.should_not be_valid
  end

  it "should reject duplicate up to case" do
  	upperCaseEmail = "USER@ExamplE.COM"
  	User.create!(@var.merge(:email => upperCaseEmail))
  	userWithDuplicateEmail = User.new(@var)
  	userWithDuplicateEmail.should_not be_valid
  end

#Lesson 40
  describe "passwords" do

    before(:each) do
      #further simplification
      @user = User.new(@var)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@var.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@var.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      User.new(@var.merge(:password => short, :password_confirmation => short)).
      should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      User.new(@var.merge(:password => long, :password_confirmation => long)).
      should_not be_valid
    end
  end

  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@var)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

    it "should have a salt" do
      @user.should respond_to(:salt)
    end

    describe "has_password? method" do

      it "should exist" do
        @user.should respond_to(:has_password?)
      end

      it "should return true if the passords match" do
        @user.has_password?(@var[:password]).should be_true
      end

      it "should return false if the passords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do

      it "should exist" do
        #class level method...
        User.should respond_to(:authenticate)
      end

      it "should return nil on email/password mismatch" do
        User.authenticate(@var[:email], "wrongPassword").should be_nil
      end

      it "should return nil for an email with no user" do
        User.authenticate("ace@casino.com", @var[:password]).should be_nil
      end

      it "should return the user on email/password match" do
        User.authenticate(@var[:email], @var[:password]). should == @user
      end
    end
  end

#Lesson 60
  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@var)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin  #admin is boolean
                                 #same as, @user.admin?.should_not be_true
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

#Lesson 66
  describe "micropost associations" do
    before(:each) do
      @user = User.create(@var)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)

    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]   #an array and descending order
    end

    it "should destroy associated microposts when destroy a user" do
      @user.destroy
      [@mp2, @mp1].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
      #alternate way (more verbose)
      # [@mp2, @mp1].each do |micropost|      
      #   lambda do
      #     Micropost.find(micropost.id)
      #   end.should raise_error(ActiveRecord::RecordNotFound)
      # end
    end  

  #Lesson 68
    describe "feed" do
      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's posts" do
        #@user.feed.include?(@mp1).should be_true  #alternate way
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end

      it "should not include posts of a non-followed user" do
        @mp3 = Factory(:micropost, 
                       :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include(@mp3)
      end

    end
  end
  
end